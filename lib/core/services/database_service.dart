import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../models/family_model.dart';
import '../models/achievement_model.dart';
import '../models/task_category_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'famtask.db';
  static const int _databaseVersion = 1;

  final Uuid _uuid = const Uuid();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        avatar_url TEXT,
        total_points INTEGER NOT NULL DEFAULT 0,
        level INTEGER NOT NULL DEFAULT 1,
        joined_at TEXT NOT NULL,
        achievements TEXT,
        family_id TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        last_active_at TEXT,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE families (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        owner_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        member_ids TEXT NOT NULL,
        invite_code TEXT UNIQUE,
        description TEXT,
        settings TEXT,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        assigned_user_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        deadline TEXT NOT NULL,
        status TEXT NOT NULL,
        type TEXT NOT NULL,
        points INTEGER NOT NULL DEFAULT 0,
        category_id TEXT,
        family_id TEXT,
        recurrence_type TEXT,
        recurrence_interval INTEGER,
        tags TEXT,
        photo_url TEXT,
        notes TEXT,
        completed_at TEXT,
        last_reminder_sent TEXT,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (assigned_user_id) REFERENCES users (id),
        FOREIGN KEY (family_id) REFERENCES families (id),
        FOREIGN KEY (category_id) REFERENCES task_categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE task_categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        color TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        icon_url TEXT NOT NULL,
        required_points INTEGER NOT NULL,
        conditions TEXT NOT NULL,
        unlocked_at TEXT,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE user_achievements (
        user_id TEXT NOT NULL,
        achievement_id TEXT NOT NULL,
        unlocked_at TEXT NOT NULL,
        PRIMARY KEY (user_id, achievement_id),
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (achievement_id) REFERENCES achievements (id)
      )
    ''');

    await _insertDefaultCategories(db);
    await _insertDefaultAchievements(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> _insertDefaultCategories(Database db) async {
    final categories = [
      {
        'id': _uuid.v4(),
        'name': 'Việc nhà',
        'icon_name': 'home',
        'color': '#4A90E2',
        'description': 'Các công việc dọn dẹp nhà cửa',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'name': 'Việc cá nhân',
        'icon_name': 'person',
        'color': '#6B46C1',
        'description': 'Các công việc cá nhân',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'name': 'Việc định kỳ',
        'icon_name': 'schedule',
        'color': '#FF6B35',
        'description': 'Các công việc lặp lại định kỳ',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (final category in categories) {
      await db.insert('task_categories', category);
    }
  }

  Future<void> _insertDefaultAchievements(Database db) async {
    final achievements = [
      {
        'id': _uuid.v4(),
        'title': 'Người mới bắt đầu',
        'description': 'Hoàn thành 5 công việc đầu tiên',
        'icon_url': 'assets/icons/beginner.png',
        'required_points': 50,
        'conditions': '["completed_tasks:5"]',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'title': 'Người dọn dẹp siêu đẳng',
        'description': 'Hoàn thành 50 công việc nhà',
        'icon_url': 'assets/icons/super_cleaner.png',
        'required_points': 500,
        'conditions': '["house_tasks:50"]',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'title': 'Bậc thầy hút bụi',
        'description': 'Hút bụi 20 lần trong tháng',
        'icon_url': 'assets/icons/vacuum_master.png',
        'required_points': 200,
        'conditions': '["vacuum_tasks:20"]',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (final achievement in achievements) {
      await db.insert('achievements', achievement);
    }
  }

  // User
  Future<String> insertUser(User user) async {
    final db = await database;
    final id = user.id.isEmpty ? _uuid.v4() : user.id;
    final userWithId = user.copyWith(id: id);

    await db.insert('users', {
      'id': userWithId.id,
      'name': userWithId.name,
      'email': userWithId.email,
      'avatar_url': userWithId.avatarUrl,
      'total_points': userWithId.totalPoints,
      'level': userWithId.level,
      'joined_at': userWithId.joinedAt.toIso8601String(),
      'achievements': userWithId.achievements?.join(','),
      'family_id': userWithId.familyId,
      'is_active': userWithId.isActive == true ? 1 : 0,
      'last_active_at': userWithId.lastActiveAt?.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    return id;
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? _mapToUser(maps.first) : null;
  }

  Future<User?> getCurrentUser() async {
    final db = await database;
    final maps = await db.query('users', where: 'is_active = ?', whereArgs: [1], limit: 1);
    return maps.isNotEmpty ? _mapToUser(maps.first) : null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update('users', {
      'name': user.name,
      'email': user.email,
      'avatar_url': user.avatarUrl,
      'total_points': user.totalPoints,
      'level': user.level,
      'achievements': user.achievements?.join(','),
      'family_id': user.familyId,
      'is_active': user.isActive == true ? 1 : 0,
      'last_active_at': user.lastActiveAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [user.id]);
  }

  User _mapToUser(Map<String, dynamic> map) => User(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    avatarUrl: map['avatar_url'],
    totalPoints: map['total_points'],
    level: map['level'],
    joinedAt: DateTime.parse(map['joined_at']),
    achievements: map['achievements']?.split(','),
    familyId: map['family_id'],
    isActive: map['is_active'] == 1,
    lastActiveAt: map['last_active_at'] != null ? DateTime.parse(map['last_active_at']) : null,
  );

  // Family
  Future<Family> createFamily(String name, String description) async {
    final db = await database;
    final id = _uuid.v4();
    final inviteCode = _generateInviteCode();
    final currentUser = await getCurrentUser();
    if (currentUser == null) throw Exception('No current user');

    final family = Family(
      id: id,
      name: name,
      ownerId: currentUser.id,
      createdAt: DateTime.now(),
      memberIds: [currentUser.id],
      inviteCode: inviteCode,
      description: description,
    );

    await db.insert('families', {
      'id': family.id,
      'name': family.name,
      'owner_id': family.ownerId,
      'created_at': family.createdAt.toIso8601String(),
      'member_ids': family.memberIds.join(','),
      'invite_code': family.inviteCode,
      'description': family.description,
      'updated_at': DateTime.now().toIso8601String(),
    });

    await updateUser(currentUser.copyWith(familyId: id));
    return family;
  }

  Future<Family?> getCurrentFamily() async {
    final currentUser = await getCurrentUser();
    if (currentUser?.familyId == null) return null;

    final db = await database;
    final maps = await db.query('families', where: 'id = ?', whereArgs: [currentUser!.familyId]);
    return maps.isNotEmpty ? _mapToFamily(maps.first) : null;
  }

  Future<Family?> joinFamily(String inviteCode) async {
    final db = await database;
    final maps = await db.query('families', where: 'invite_code = ?', whereArgs: [inviteCode]);
    if (maps.isEmpty) throw Exception('Invalid invite code');

    final family = _mapToFamily(maps.first);
    final currentUser = await getCurrentUser();
    if (currentUser == null) throw Exception('No current user');

    final updatedMemberIds = [...family.memberIds, currentUser.id];
    await db.update('families', {
      'member_ids': updatedMemberIds.join(','),
      'updated_at': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [family.id]);

    await updateUser(currentUser.copyWith(familyId: family.id));
    return family.copyWith(memberIds: updatedMemberIds);
  }

  Family _mapToFamily(Map<String, dynamic> map) => Family(
    id: map['id'],
    name: map['name'],
    ownerId: map['owner_id'],
    createdAt: DateTime.parse(map['created_at']),
    memberIds: map['member_ids'].split(','),
    inviteCode: map['invite_code'],
    description: map['description'],
  );

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(random % chars.length)));
  }

  // Tasks
  Future<String> insertTask(Task task) async {
    final db = await database;
    final id = task.id.isEmpty ? _uuid.v4() : task.id;
    await db.insert('tasks', {
      'id': id,
      'title': task.title,
      'description': task.description,
      'assigned_user_id': task.assignedUserId,
      'created_at': DateTime.now().toIso8601String(),
      'deadline': task.deadline.toIso8601String(),
      'status': task.status.name,
      'type': task.type.name,
      'points': task.points,
      'category_id': task.categoryId,
      'family_id': task.familyId,
      'recurrence_type': task.recurrenceType?.name,
      'recurrence_interval': task.recurrenceInterval,
      'tags': task.tags?.join(','),
      'photo_url': task.photoUrl,
      'notes': task.notes,
      'completed_at': task.completedAt?.toIso8601String(),
      'last_reminder_sent': task.lastReminderSent?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    return id;
  }

  Future<List<Task>> getTasksForFamily(String familyId, {DateTime? forDate}) async {
    final db = await database;
    String where = 'family_id = ?';
    List<dynamic> whereArgs = [familyId];

    if (forDate != null) {
      final dayStart = DateTime(forDate.year, forDate.month, forDate.day).toIso8601String();
      final dayEnd = DateTime(forDate.year, forDate.month, forDate.day, 23, 59, 59).toIso8601String();
      where += ' AND deadline BETWEEN ? AND ?';
      whereArgs.addAll([dayStart, dayEnd]);
    }

    final maps = await db.query('tasks', where: where, whereArgs: whereArgs, orderBy: 'deadline ASC');
    return maps.map(_mapToTask).toList();
  }

  Future<void> markTaskAsComplete(String taskId) async {
    final db = await database;
    await db.update('tasks', {
      'status': TaskStatus.completed.name,
      'completed_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [taskId]);
  }

  Future<int> countCompletedTasks(String familyId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE family_id = ? AND status = ?',
      [familyId, TaskStatus.completed.name],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> duplicateRecurringTask(Task task) async {
    if (task.recurrenceType == null || task.recurrenceInterval == null) return;
    DateTime newDeadline;
    switch (task.recurrenceType) {
      case RecurrenceType.daily:
        newDeadline = task.deadline.add(Duration(days: task.recurrenceInterval!));
        break;
      case RecurrenceType.weekly:
        newDeadline = task.deadline.add(Duration(days: 7 * task.recurrenceInterval!));
        break;
      case RecurrenceType.monthly:
        newDeadline = DateTime(task.deadline.year, task.deadline.month + task.recurrenceInterval!, task.deadline.day);
        break;
      default:
        return;
    }
    await insertTask(task.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      deadline: newDeadline,
      status: TaskStatus.pending,
      completedAt: null,
    ));
  }

  Task _mapToTask(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    assignedUserId: map['assigned_user_id'],
    createdAt: DateTime.parse(map['created_at']),
    deadline: DateTime.parse(map['deadline']),
    status: TaskStatus.values.firstWhere((e) => e.name == map['status']),
    type: TaskType.values.firstWhere((e) => e.name == map['type']),
    points: map['points'],
    categoryId: map['category_id'],
    familyId: map['family_id'],
    recurrenceType: map['recurrence_type'] != null ? RecurrenceType.values.firstWhere((e) => e.name == map['recurrence_type']) : null,
    recurrenceInterval: map['recurrence_interval'],
    tags: map['tags']?.split(','),
    photoUrl: map['photo_url'],
    notes: map['notes'],
    completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
    lastReminderSent: map['last_reminder_sent'] != null ? DateTime.parse(map['last_reminder_sent']) : null,
  );
}
