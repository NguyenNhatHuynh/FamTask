import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:famtask/core/models/task_model.dart';
import 'package:famtask/core/models/user_model.dart';
import 'package:famtask/core/models/family_model.dart' as fam;
import 'package:famtask/core/models/task_category_model.dart';
import 'package:famtask/core/models/achievement_model.dart';
import 'package:famtask/core/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

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
      } else {
        state = null;
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
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
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    state = null;
  }

  Future<void> updatePoints(int points) async {
    if (state == null) return;
    final dbService = ref.read(databaseServiceProvider);
    final updatedUser = state!.copyWith(
      totalPoints: state!.totalPoints + points,
      level: _calculateLevel(state!.totalPoints + points),
    );
    await dbService.updateUser(updatedUser);
    state = updatedUser;
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
      final family = await ref.read(databaseServiceProvider).getFamilyForUser(user);
      state = family;
    }
  }

  Future<void> createFamily(String name, String? description) async {
    final user = ref.read(authProvider);
    if (user == null) return;
    final family = await ref.read(databaseServiceProvider).createFamily(user, name, description);
    state = family;
  }

  Future<void> joinFamily(String inviteCode) async {
    final user = ref.read(authProvider);
    if (user == null) return;
    final family = await ref.read(databaseServiceProvider).joinFamily(inviteCode, user);
    state = family;
  }
}

final familyMembersProvider = FutureProvider<List<User>>((ref) async {
  final currentFamily = ref.watch(currentFamilyProvider);
  if (currentFamily == null) return [];
  return await ref.read(databaseServiceProvider).getFamilyMembers(currentFamily.id);
});

final taskCategoriesProvider = FutureProvider<List<TaskCategory>>((ref) async {
  return await ref.read(databaseServiceProvider).getTaskCategories();
});

final userAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final currentUser = ref.watch(authProvider);
  if (currentUser == null) return [];
  return await ref.read(databaseServiceProvider).getUserAchievements(currentUser.id);
});

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier(ref);
});

class TasksNotifier extends StateNotifier<List<Task>> {
  final Ref ref;
  final DatabaseService _databaseService;

  TasksNotifier(this.ref)
      : _databaseService = ref.read(databaseServiceProvider),
        super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _databaseService.getAllTasks();
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    await _databaseService.insertTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(task);
    state = state.map((t) => t.id == task.id ? task : t).toList();
  }

  Future<void> deleteTask(String taskId) async {
    await _databaseService.deleteTask(taskId);
    state = state.where((t) => t.id != taskId).toList();
  }

  Future<void> completeTask(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final user = ref.read(authProvider);
    if (user == null) return;
    await _databaseService.completeTask(task, user);
    await _loadTasks();
    await ref.read(authProvider.notifier).updatePoints(task.points);
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
    return {
      'totalTasks': userTasks.length,
      'completedTasks': completedTasks.length,
      'totalPoints': currentUser.totalPoints,
      'level': currentUser.level,
    };
  }
}