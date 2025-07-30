class PlayerProgress {
  int? id;
  String playerName;
  String profileImageUrl;
  int currentExp;
  int currentGold;
  int level;
  String playerRank;
  DateTime lastUpdated;

  PlayerProgress({
    this.id,
    required this.playerName,
    required this.profileImageUrl,
    this.currentExp = 0,
    this.currentGold = 0,
    this.level = 1,
    this.playerRank = 'F',
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerName': playerName,
      'profileImageUrl': profileImageUrl,
      'currentExp': currentExp,
      'currentGold': currentGold,
      'level': level,
      'playerRank': playerRank,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  factory PlayerProgress.fromMap(Map<String, dynamic> map) {
    return PlayerProgress(
      id: map['id'],
      playerName: map['playerName'],
      profileImageUrl: map['profileImageUrl'],
      currentExp: map['currentExp'],
      currentGold: map['currentGold'],
      level: map['level'],
      playerRank: map['playerRank'],
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated']),
    );
  }
}

class TaskModel {
  int? id;
  String title;
  DateTime dueDate;
  String difficulty; // 'Easy', 'Medium', 'Hard'
  bool isCompleted;
  DateTime createdAt;

  TaskModel({
    this.id,
    required this.title,
    required this.dueDate,
    required this.difficulty,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'difficulty': difficulty,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      difficulty: map['difficulty'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  int get xpReward {
    switch (difficulty) {
      case 'Easy':
        return 50;
      case 'Medium':
        return 100;
      case 'Hard':
        return 200;
      default:
        return 50;
    }
  }
}

class SkillModel {
  int? id;
  String name;
  String description;
  int currentStageIndex;
  String currentRank;
  bool isMastered;
  DateTime createdAt;

  SkillModel({
    this.id,
    required this.name,
    this.description = '',
    this.currentStageIndex = 0,
    this.currentRank = 'F',
    this.isMastered = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'currentStageIndex': currentStageIndex,
      'currentRank': currentRank,
      'isMastered': isMastered ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      currentStageIndex: map['currentStageIndex'],
      currentRank: map['currentRank'],
      isMastered: map['isMastered'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}

class SkillStageModel {
  int? id;
  int skillId;
  String title;
  String description;
  int xpReward;
  int goldReward;
  String rankAchieved;
  bool isCompleted;
  int stageOrder;

  SkillStageModel({
    this.id,
    required this.skillId,
    required this.title,
    this.description = '',
    required this.xpReward,
    required this.goldReward,
    required this.rankAchieved,
    this.isCompleted = false,
    required this.stageOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'skillId': skillId,
      'title': title,
      'description': description,
      'xpReward': xpReward,
      'goldReward': goldReward,
      'rankAchieved': rankAchieved,
      'isCompleted': isCompleted ? 1 : 0,
      'stageOrder': stageOrder,
    };
  }

  factory SkillStageModel.fromMap(Map<String, dynamic> map) {
    return SkillStageModel(
      id: map['id'],
      skillId: map['skillId'],
      title: map['title'],
      description: map['description'],
      xpReward: map['xpReward'],
      goldReward: map['goldReward'],
      rankAchieved: map['rankAchieved'],
      isCompleted: map['isCompleted'] == 1,
      stageOrder: map['stageOrder'],
    );
  }
}

class AchievementModel {
  int? id;
  String name;
  String description;
  int goldCost;
  bool isUnlocked;
  DateTime createdAt;

  AchievementModel({
    this.id,
    required this.name,
    this.description = '',
    required this.goldCost,
    this.isUnlocked = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'goldCost': goldCost,
      'isUnlocked': isUnlocked ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AchievementModel.fromMap(Map<String, dynamic> map) {
    return AchievementModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      goldCost: map['goldCost'],
      isUnlocked: map['isUnlocked'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
