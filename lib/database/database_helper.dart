import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/progress_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tekmaster.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create PlayerProgress table
    await db.execute('''
      CREATE TABLE player_progress(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playerName TEXT NOT NULL,
        profileImageUrl TEXT NOT NULL,
        currentExp INTEGER DEFAULT 0,
        currentGold INTEGER DEFAULT 0,
        level INTEGER DEFAULT 1,
        playerRank TEXT DEFAULT 'F',
        lastUpdated INTEGER NOT NULL
      )
    ''');

    // Create Tasks table
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        dueDate INTEGER NOT NULL,
        difficulty TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Create Skills table
    await db.execute('''
      CREATE TABLE skills(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        currentStageIndex INTEGER DEFAULT 0,
        currentRank TEXT DEFAULT 'F',
        isMastered INTEGER DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Create SkillStages table
    await db.execute('''
      CREATE TABLE skill_stages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        skillId INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        xpReward INTEGER NOT NULL,
        goldReward INTEGER NOT NULL,
        rankAchieved TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        stageOrder INTEGER NOT NULL,
        FOREIGN KEY (skillId) REFERENCES skills (id) ON DELETE CASCADE
      )
    ''');

    // Create Achievements table
    await db.execute('''
      CREATE TABLE achievements(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        goldCost INTEGER NOT NULL,
        isUnlocked INTEGER DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  // Player Progress methods
  Future<int> insertPlayerProgress(PlayerProgress progress) async {
    final db = await database;
    return await db.insert('player_progress', progress.toMap());
  }

  Future<PlayerProgress?> getPlayerProgress() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'player_progress',
      orderBy: 'lastUpdated DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return PlayerProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePlayerProgress(PlayerProgress progress) async {
    final db = await database;
    return await db.update(
      'player_progress',
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  // Task methods
  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'isCompleted ASC, createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Skill methods
  Future<int> insertSkill(SkillModel skill) async {
    final db = await database;
    return await db.insert('skills', skill.toMap());
  }

  Future<List<SkillModel>> getAllSkills() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'skills',
      orderBy: 'isMastered ASC, createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return SkillModel.fromMap(maps[i]);
    });
  }

  Future<int> updateSkill(SkillModel skill) async {
    final db = await database;
    return await db.update(
      'skills',
      skill.toMap(),
      where: 'id = ?',
      whereArgs: [skill.id],
    );
  }

  Future<int> deleteSkill(int id) async {
    final db = await database;
    return await db.delete(
      'skills',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Skill Stage methods
  Future<int> insertSkillStage(SkillStageModel stage) async {
    final db = await database;
    return await db.insert('skill_stages', stage.toMap());
  }

  Future<List<SkillStageModel>> getSkillStages(int skillId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'skill_stages',
      where: 'skillId = ?',
      whereArgs: [skillId],
      orderBy: 'stageOrder ASC',
    );

    return List.generate(maps.length, (i) {
      return SkillStageModel.fromMap(maps[i]);
    });
  }

  Future<int> updateSkillStage(SkillStageModel stage) async {
    final db = await database;
    return await db.update(
      'skill_stages',
      stage.toMap(),
      where: 'id = ?',
      whereArgs: [stage.id],
    );
  }

  Future<int> deleteSkillStages(int skillId) async {
    final db = await database;
    return await db.delete(
      'skill_stages',
      where: 'skillId = ?',
      whereArgs: [skillId],
    );
  }

  // Achievement methods
  Future<int> insertAchievement(AchievementModel achievement) async {
    final db = await database;
    return await db.insert('achievements', achievement.toMap());
  }

  Future<List<AchievementModel>> getAllAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'achievements',
      orderBy: 'isUnlocked ASC, createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return AchievementModel.fromMap(maps[i]);
    });
  }

  Future<int> updateAchievement(AchievementModel achievement) async {
    final db = await database;
    return await db.update(
      'achievements',
      achievement.toMap(),
      where: 'id = ?',
      whereArgs: [achievement.id],
    );
  }

  Future<int> deleteAchievement(int id) async {
    final db = await database;
    return await db.delete(
      'achievements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Utility methods
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('player_progress');
    await db.delete('tasks');
    await db.delete('skill_stages');
    await db.delete('skills');
    await db.delete('achievements');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
