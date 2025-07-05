import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/constants/colors.dart';
import '../models/task_model.dart';

class TaskDatabaseHelper {
  static final TaskDatabaseHelper _instance = TaskDatabaseHelper._internal();
  factory TaskDatabaseHelper() => _instance;
  static Database? _db;

  TaskDatabaseHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            startDateTime TEXT,
            stopDateTime TEXT,
            completed INTEGER,
            priority TEXT
          )
        ''');
      },
    );
  }

  Future<bool> insertTask(BuildContext context, TaskModel task) async {
    try {
      final db = await database;
      await db.insert(
        'tasks',
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _showSnackBar(context, "Task created successfully", Colors.green);
      return true;
    } catch (e) {
      _showSnackBar(context, "Insert failed: $e", Colors.red);
      return false;
    }
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((map) => TaskModel.fromJson(map)).toList();
  }

  Future<bool> updateTask(BuildContext context, TaskModel task) async {
    try {
      final db = await database;
      int result = await db.update(
        'tasks',
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      if (result > 0) {
        _showSnackBar(context, "Task updated successfully", Colors.blue);
        return true;
      } else {
        _showSnackBar(context, "Task not found", Colors.orange);
        return false;
      }
    } catch (e) {
      _showSnackBar(context, "Update failed: $e", Colors.red);
      return false;
    }
  }

  Future<bool> deleteTask(BuildContext context, String id) async {
    try {
      final db = await database;
      int result = await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result > 0) {
        _showSnackBar(context, "Task deleted successfully", kPrimaryColor);
        return true;
      } else {
        _showSnackBar(context, "Task not found", Colors.orange);
        return false;
      }
    } catch (e) {
      _showSnackBar(context, "Delete failed", Colors.red);
      return false;
    }
  }

  Future<TaskModel?> getTaskById(String id) async {
    final db = await database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    }
    return null;
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: color,
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
