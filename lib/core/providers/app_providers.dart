import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../models/family_model.dart';
import '../services/database_service.dart';

// Database service provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// Current user provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier(ref.read(databaseServiceProvider));
});

class CurrentUserNotifier extends StateNotifier<User?> {
  final DatabaseService _databaseService;

  CurrentUserNotifier(this._databaseService) : super(null);

  Future<void> loadCurrentUser() async {
    try {
      final user = await _databaseService.getCurrentUser();
      state = user;
    } catch (e) {
      // Handle error
      state = null;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _databaseService.updateUser(user);
      state = user;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addPoints(int points) async {
    if (state != null) {
      final updatedUser = state!.copyWith(
        totalPoints: state!.totalPoints + points,
        level: _calculateLevel(state!.totalPoints + points),
      );
      await updateUser(updatedUser);
    }
  }

  int _calculateLevel(int totalPoints) {
    // Simple level calculation: 100 points per level
    return (totalPoints / 100).floor() + 1;
  }
}

// Current family provider
final currentFamilyProvider = StateNotifierProvider<CurrentFamilyNotifier, Family?>((ref) {
  return CurrentFamilyNotifier(ref.read(databaseServiceProvider));
});

class CurrentFamilyNotifier extends StateNotifier<Family?> {
  final DatabaseService _databaseService;

  CurrentFamilyNotifier(this._databaseService) : super(null);

  Future<void> loadCurrentFamily() async {
    try {
      final family = await _databaseService.getCurrentFamily();
      state = family;
    } catch (e) {
      state = null;
    }
  }

  Future<void> createFamily(String name, String description) async {
    try {
      final family = await _databaseService.createFamily(name, description);
      state = family;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> joinFamily(String inviteCode) async {
    try {
      final family = await _databaseService.joinFamily(inviteCode);
      state = family;
    } catch (e) {
      // Handle error
    }
  }
}

// Tasks provider
final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier(ref.read(databaseServiceProvider));
});

class TasksNotifier extends StateNotifier<List<Task>> {
  final DatabaseService _databaseService;

  TasksNotifier(this._databaseService) : super([]);

  Future<void> loadTasks() async {
    try {
      final tasks = await _databaseService.getAllTasks();
      state = tasks;
    } catch (e) {
      // Handle error
      state = [];
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _databaseService.insertTask(task);
      state = [...state, task];
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _databaseService.updateTask(task);
      state = state.map((t) => t.id == task.id ? task : t).toList();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _databaseService.deleteTask(taskId);
      state = state.where((t) => t.id != taskId).toList();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> completeTask(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final completedTask = task.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
    await updateTask(completedTask);
  }

  // Filter methods
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
      t.deadline.day == today.day
    ).toList();
  }
}

// Family members provider
final familyMembersProvider = FutureProvider<List<User>>((ref) async {
  final databaseService = ref.read(databaseServiceProvider);
  final currentFamily = ref.watch(currentFamilyProvider);
  
  if (currentFamily == null) return [];
  
  return await databaseService.getFamilyMembers(currentFamily.id);
});

// Task categories provider
final taskCategoriesProvider = FutureProvider<List<TaskCategory>>((ref) async {
  final databaseService = ref.read(databaseServiceProvider);
  return await databaseService.getTaskCategories();
});

// User achievements provider
final userAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final databaseService = ref.read(databaseServiceProvider);
  final currentUser = ref.watch(currentUserProvider);
  
  if (currentUser == null) return [];
  
  return await databaseService.getUserAchievements(currentUser.id);
});

// Dashboard stats provider
final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final tasks = ref.watch(tasksProvider);
  final currentUser = ref.watch(currentUserProvider);
  
  if (currentUser == null) return {};
  
  final userTasks = tasks.where((t) => t.assignedUserId == currentUser.id).toList();
  final completedTasks = userTasks.where((t) => t.status == TaskStatus.completed).toList();
  final todayTasks = userTasks.where((t) {
    final today = DateTime.now();
    return t.deadline.year == today.year &&
           t.deadline.month == today.month &&
           t.deadline.day == today.day;
  }).toList();
  
  final todayCompletedTasks = todayTasks.where((t) => t.status == TaskStatus.completed).toList();
  final todayProgress = todayTasks.isEmpty ? 0.0 : todayCompletedTasks.length / todayTasks.length;
  
  return {
    'totalTasks': userTasks.length,
    'completedTasks': completedTasks.length,
    'todayTasks': todayTasks.length,
    'todayProgress': todayProgress,
    'totalPoints': currentUser.totalPoints,
    'level': currentUser.level,
  };
});