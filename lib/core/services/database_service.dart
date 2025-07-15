import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:famtask/core/models/user_model.dart';
import 'package:famtask/core/models/family_model.dart';
import 'package:famtask/core/models/task_model.dart';
import 'package:famtask/core/models/task_category_model.dart';
import 'package:famtask/core/models/achievement_model.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'famtask.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            avatar_url TEXT,
            total_points INTEGER,
            level INTEGER,
            joined_at TEXT,
            achievements TEXT,
            family_id TEXT,
            is_active INTEGER,
            last_active_at TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE families (
            id TEXT PRIMARY KEY,
            name TEXT,
            owner_id TEXT,
            created_at TEXT,
            member_ids TEXT,
            invite_code TEXT,
            description TEXT,
            settings TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            assigned_user_id TEXT,
            created_at TEXT,
            deadline TEXT,
            status TEXT,
            type TEXT,
            points INTEGER,
            category_id TEXT,
            family_id TEXT,
            recurrence_type TEXT,
            recurrence_interval INTEGER,
            tags TEXT,
            photo_url TEXT,
            notes TEXT,
            completed_at TEXT,
            last_reminder_sent TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE task_categories (
            id TEXT PRIMARY KEY,
            name TEXT,
            icon_name TEXT,
            color TEXT,
            description TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE achievements (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            icon TEXT,
            points_required INTEGER,
            achieved_at TEXT,
            user_id TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      {
        ...user.toJson(),
        'achievements': user.achievements?.join(','),
        'joined_at': user.joinedAt.toIso8601String(),
        'last_active_at': user.lastActiveAt?.toIso8601String(),
        'is_active': user.isActive == true ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      {
        ...user.toJson(),
        'achievements': user.achievements?.join(','),
        'joined_at': user.joinedAt.toIso8601String(),
        'last_active_at': user.lastActiveAt?.toIso8601String(),
        'is_active': user.isActive == true ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<Family?> getFamilyForUser(User user) async {
    final db = await database;
    final families = await db.query(
      'families',
      where: 'member_ids LIKE ?',
      whereArgs: ['%${user.id}%'],
    );
    if (families.isNotEmpty) {
      return Family.fromJson({
        ...families.first,
        'created_at': DateTime.parse(families.first['created_at'] as String),
        'member_ids': (families.first['member_ids'] as String).split(','),
        'settings': families.first['settings'] != null
            ? Map<String, dynamic>.from(families.first['settings'] as Map)
            : null,
      });
    }
    return null;
  }

  Future<Family> createFamily(User user, String name, String? description) async {
    final db = await database;
    final family = Family(
      id: const Uuid().v4(),
      name: name,
      ownerId: user.id,
      createdAt: DateTime.now(),
      memberIds: [user.id],
      inviteCode: const Uuid().v4().substring(0, 8),
      description: description,
    );
    await db.insert(
      'families',
      {
        ...family.toJson(),
        'created_at': family.createdAt.toIso8601String(),
        'member_ids': family.memberIds.join(','),
        'settings': family.settings != null ? jsonEncode(family.settings) : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await updateUser(user.copyWith(familyId: family.id));
    return family;
  }

  Future<Family?> joinFamily(String inviteCode, User user) async {
    final db = await database;
    final families = await db.query(
      'families',
      where: 'invite_code = ?',
      whereArgs: [inviteCode],
    );
    if (families.isNotEmpty) {
      final family = Family.fromJson({
        ...families.first,
        'created_at': DateTime.parse(families.first['created_at'] as String),
        'member_ids': (families.first['member_ids'] as String).split(','),
        'settings': families.first['settings'] != null
            ? Map<String, dynamic>.from(families.first['settings'] as Map)
            : null,
      });
      final updatedFamily = family.copyWith(
        memberIds: [...family.memberIds, user.id],
      );
      await db.update(
        'families',
        {
          ...updatedFamily.toJson(),
          'created_at': updatedFamily.createdAt.toIso8601String(),
          'member_ids': updatedFamily.memberIds.join(','),
          'settings': updatedFamily.settings != null ? jsonEncode(updatedFamily.settings) : null,
        },
        where: 'id = ?',
        whereArgs: [family.id],
      );
      await updateUser(user.copyWith(familyId: family.id));
      return updatedFamily;
    }
    return null;
  }

  Future<List<User>> getFamilyMembers(String familyId) async {
    final db = await database;
    final users = await db.query(
      'users',
      where: 'family_id = ?',
      whereArgs: [familyId],
    );
    return users.map((u) => User.fromJson({
          ...u,
          'achievements': (u['achievements'] as String?)?.split(',') ?? [],
          'joined_at': DateTime.parse(u['joined_at'] as String),
          'last_active_at': u['last_active_at'] != null ? DateTime.parse(u['last_active_at'] as String) : null,
          'is_active': (u['is_active'] as int?) == 1,
        })).toList();
  }

  Future<List<TaskCategory>> getTaskCategories() async {
    final db = await database;
    final categories = await db.query('task_categories');
    return categories.map((c) => TaskCategory.fromJson(c)).toList();
  }

  Future<List<Achievement>> getUserAchievements(String userId) async {
    final db = await database;
    final achievements = await db.query(
      'achievements',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return achievements.map((a) => Achievement.fromJson({
          ...a,
          'achieved_at': a['achieved_at'] != null ? DateTime.parse(a['achieved_at'] as String) : null,
        })).toList();
  }

Future<List<Task>> getAllTasks() async {
  final db = await database;
  final tasks = await db.query('tasks');
  return tasks.map((t) => Task.fromJson({
    ...t,
    'created_at': DateTime.parse(t['created_at'] as String),
    'deadline': DateTime.parse(t['deadline'] as String),
    'completed_at': t['completed_at'] != null ? DateTime.parse(t['completed_at'] as String) : null,
    'last_reminder_sent': t['last_reminder_sent'] != null ? DateTime.parse(t['last_reminder_sent'] as String) : null,
    'tags': (t['tags'] as String?)?.split(',') ?? [],
    // status, type, recurrence_type giữ nguyên string cho fromJson tự parse
  })).toList();
}


  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        ...task.toJson(),
        'created_at': task.createdAt.toIso8601String(),
        'deadline': task.deadline.toIso8601String(),
        'completed_at': task.completedAt?.toIso8601String(),
        'last_reminder_sent': task.lastReminderSent?.toIso8601String(),
        'tags': task.tags?.join(','),
        'status': task.status.toString().split('.').last,
        'type': task.type.toString().split('.').last,
        'recurrence_type': task.recurrenceType?.toString().split('.').last,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        ...task.toJson(),
        'created_at': task.createdAt.toIso8601String(),
        'deadline': task.deadline.toIso8601String(),
        'completed_at': task.completedAt?.toIso8601String(),
        'last_reminder_sent': task.lastReminderSent?.toIso8601String(),
        'tags': task.tags?.join(','),
        'status': task.status.toString().split('.').last,
        'type': task.type.toString().split('.').last,
        'recurrence_type': task.recurrenceType?.toString().split('.').last,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String taskId) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> completeTask(Task task, User user) async {
    final updatedTask = task.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
    await updateTask(updatedTask);
    final updatedUser = user.copyWith(
      totalPoints: user.totalPoints + task.points,
      level: (user.totalPoints + task.points) ~/ 100 + 1,
    );
    await updateUser(updatedUser);
  }
}