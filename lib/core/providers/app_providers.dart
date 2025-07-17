import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:famtask/core/models/task_model.dart';
import 'package:famtask/core/models/user_model.dart';
import 'package:famtask/core/models/family_model.dart' as fam;
import 'package:famtask/core/models/task_category_model.dart';
import 'package:famtask/core/models/achievement_model.dart';
import 'package:famtask/core/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:uuid/uuid.dart'; // Added import for Uuid

// Provider for DatabaseService
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<User?> {
  final Ref ref;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  AuthNotifier(this.ref) : super(null) {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        try {
          final dbService = ref.read(databaseServiceProvider);
          final users = await dbService.database.then(
            (db) => db.query('users', where: 'email = ?', whereArgs: [firebaseUser.email]),
          );
          if (users.isNotEmpty) {
            state = User.fromJson({
              ...users.first,
              'achievements': (users.first['achievements'] as String?)?.split(',') ?? [],
              'joined_at': DateTime.parse(users.first['joined_at'] as String),
              'last_active_at': users.first['last_active_at'] != null
                  ? DateTime.parse(users.first['last_active_at'] as String)
                  : null,
              'is_active': (users.first['is_active'] as int?) == 1,
            });
          }
        } catch (e) {
          print('Error loading user: $e');
        }
      } else {
        state = null;
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Sign-in error: $e');
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final dbService = ref.read(databaseServiceProvider);
        final user = User(
          id: firebaseUser.uid,
          name: name,
          email: email,
          totalPoints: 0,
          level: 1,
          joinedAt: DateTime.now(),
          isActive: true,
        );
        await dbService.insertUser(user);
        state = user;
      }
    } catch (e) {
      print('Sign-up error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      state = null;
    } catch (e) {
      print('Sign-out error: $e');
      rethrow;
    }
  }

  Future<void> updatePoints(int points) async {
    if (state == null) return;
    try {
      final dbService = ref.read(databaseServiceProvider);
      final updatedUser = state!.copyWith(
        totalPoints: state!.totalPoints + points,
        level: _calculateLevel(state!.totalPoints + points),
      );
      await dbService.updateUser(updatedUser);
      state = updatedUser;
    } catch (e) {
      print('Update points error: $e');
    }
  }

  int _calculateLevel(int totalPoints) => (totalPoints ~/ 100) + 1;
}

// Current Family provider
final currentFamilyProvider = StateNotifierProvider<CurrentFamilyNotifier, fam.Family?>((ref) {
  return CurrentFamilyNotifier(ref);
});

class CurrentFamilyNotifier extends StateNotifier<fam.Family?> {
  final Ref ref;

  CurrentFamilyNotifier(this.ref) : super(null) {
    _loadFamily();
  }

  Future<void> _loadFamily() async {
    final user = ref.read(authProvider);
    if (user != null) {
      try {
        final family = await ref.read(databaseServiceProvider).getFamilyForUser(user);
        state = family;
      } catch (e) {
        print('Error loading family: $e');
      }
    }
  }

  Future<void> createFamily(String name, String? description) async {
    final user = ref.read(authProvider);
    if (user == null) return;
    try {
      final family = await ref.read(databaseServiceProvider).createFamily(user, name, description);
      state = family;
    } catch (e) {
      print('Error creating family: $e');
    }
  }

  Future<void> joinFamily(String inviteCode) async {
    final user = ref.read(authProvider);
    if (user == null) return;
    try {
      final family = await ref.read(databaseServiceProvider).joinFamily(inviteCode, user);
      state = family;
    } catch (e) {
      print('Error joining family: $e');
    }
  }
}

final familyMembersProvider = FutureProvider<List<User>>((ref) async {
  final currentFamily = ref.watch(currentFamilyProvider);
  if (currentFamily == null) return [];
  try {
    return await ref.read(databaseServiceProvider).getFamilyMembers(currentFamily.id);
  } catch (e) {
    print('Error loading family members: $e');
    return [];
  }
});

final taskCategoriesProvider = FutureProvider<List<TaskCategory>>((ref) async {
  try {
    return await ref.read(databaseServiceProvider).getTaskCategories();
  } catch (e) {
    print('Error loading task categories: $e');
    return [];
  }
});

final userAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final currentUser = ref.watch(authProvider);
  if (currentUser == null) return [];
  try {
    return await ref.read(databaseServiceProvider).getUserAchievements(currentUser.id);
  } catch (e) {
    print('Error loading achievements: $e');
    return [];
  }
});

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier(ref);
});

class TasksNotifier extends StateNotifier<List<Task>> {
  final Ref ref;
  final DatabaseService _databaseService;
  Timer? _refreshTimer;
  final uuid = Uuid(); // Non-const instance

  TasksNotifier(this.ref)
      : _databaseService = ref.read(databaseServiceProvider),
        super([]) {
    _loadTasks();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _databaseService.getAllTasks();
      state = tasks;
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) => _loadTasks());
  }

  Future<void> addTask(Task task) async {
    try {
      await _databaseService.insertTask(task);
      state = [...state, task];
      _generateRecurringTasks(task);
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _databaseService.updateTask(task);
      state = state.map((t) => t.id == task.id ? task : t).toList();
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _databaseService.deleteTask(taskId);
      state = state.where((t) => t.id != taskId).toList();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> completeTask(String taskId) async {
    try {
      final task = state.firstWhere((t) => t.id == taskId);
      final user = ref.read(authProvider);
      if (user == null) return;
      await _databaseService.completeTask(task, user);
      await _loadTasks();
      await ref.read(authProvider.notifier).updatePoints(task.points);
    } catch (e) {
      print('Error completing task: $e');
    }
  }

  String? suggestTaskAssignment() {
    final user = ref.read(authProvider);
    if (user == null) return null;
    final currentFamily = ref.read(currentFamilyProvider);
    if (currentFamily == null) return user.id;

    final members = ref.read(familyMembersProvider).maybeWhen(
          data: (users) => users,
          orElse: () => [],
        );
    if (members.isEmpty) return user.id;

    // Simple rule: Assign to the member with the least completed tasks
    final taskCounts = <String, int>{};
    for (var member in members) {
      final memberTasks = getTasksByUser(member.id).where((t) => t.status == TaskStatus.completed).length;
      taskCounts[member.id] = memberTasks;
    }
    return taskCounts.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  void _generateRecurringTasks(Task task) {
    if (task.type == TaskType.oneTime || task.recurrenceType == null) return;
    final now = DateTime.now();
    DateTime nextDeadline = task.deadline;
    while (nextDeadline.isBefore(now.add(const Duration(days: 30)))) {
      switch (task.recurrenceType) {
        case RecurrenceType.daily:
          nextDeadline = nextDeadline.add(const Duration(days: 1));
          break;
        case RecurrenceType.weekly:
          nextDeadline = nextDeadline.add(const Duration(days: 7));
          break;
        case RecurrenceType.monthly:
          nextDeadline = DateTime(nextDeadline.year, nextDeadline.month + 1, nextDeadline.day);
          break;
        case RecurrenceType.custom:
          nextDeadline = nextDeadline.add(Duration(days: task.recurrenceInterval ?? 1));
          break;
        default:
          break; // Handle null or unexpected cases
      }
      final newTask = task.copyWith(
        id: uuid.v4(), // Use the Uuid instance
        createdAt: now,
        deadline: nextDeadline,
        status: TaskStatus.pending,
      );
      addTask(newTask);
    }
  }

  List<Task> get pendingTasks => state.where((t) => t.status == TaskStatus.pending).toList();
  List<Task> get inProgressTasks => state.where((t) => t.status == TaskStatus.inProgress).toList();
  List<Task> get completedTasks => state.where((t) => t.status == TaskStatus.completed).toList();
  List<Task> get overdueTasks => state.where((t) => t.status == TaskStatus.overdue).toList();

  List<Task> getTasksByUser(String userId) => state.where((t) => t.assignedUserId == userId).toList();
  List<Task> getTasksByCategory(String categoryId) => state.where((t) => t.categoryId == categoryId).toList();

  List<Task> getTodayTasks() {
    final today = DateTime.now();
    return state.where((t) =>
        t.deadline.year == today.year &&
        t.deadline.month == today.month &&
        t.deadline.day == today.day).toList();
  }

  double getTodayProgress() {
    final todayTasks = getTodayTasks();
    if (todayTasks.isEmpty) return 0.0;
    final todayCompletedTasks = todayTasks.where((t) => t.status == TaskStatus.completed).toList();
    return todayCompletedTasks.length / todayTasks.length;
  }

  Map<String, dynamic> getUserStats() {
    final currentUser = ref.read(authProvider);
    if (currentUser == null) return {};
    final userTasks = getTasksByUser(currentUser.id);
    final completedTasks = userTasks.where((t) => t.status == TaskStatus.completed).toList();
    final overdueTasks = userTasks.where((t) => t.status == TaskStatus.overdue).toList();
    final avgPoints = userTasks.isNotEmpty ? userTasks.map((t) => t.points).reduce((a, b) => a + b) / userTasks.length : 0;
    return {
      'totalTasks': userTasks.length,
      'completedTasks': completedTasks.length,
      'overdueTasks': overdueTasks.length,
      'totalPoints': currentUser.totalPoints,
      'level': currentUser.level,
      'avgPointsPerTask': avgPoints,
    };
  }
}