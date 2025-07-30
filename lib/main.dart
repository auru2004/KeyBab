import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'database/database_helper.dart';
import 'models/progress_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEKMASTER Enhanced',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Splash Screen dengan animasi tulisan TEKMASTER
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _rotateController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.bounceOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeInOut,
    ));

    // Start animations in sequence
    _startAnimations();
  }

  void _startAnimations() async {
    // Start fade animation
    _fadeController.forward();
    
    // Wait a bit then start scale
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    
    // Start slide animation
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    
    // Start rotate animation
    await Future.delayed(const Duration(milliseconds: 300));
    _rotateController.forward();
    
    // Navigate to main screen after all animations
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const TekMasterIdCard(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1a1a1a)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated TEKMASTER text
              SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF14B8A6),
                          Color(0xFF0F766E),
                          Color(0xFFEAB308),
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'KeyBab',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Animated subtitle
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'Level Up Your Skills',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Animated loading indicator
              RotationTransition(
                turns: _rotateAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF14B8A6),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF14B8A6),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TekMasterIdCard extends StatefulWidget {
  const TekMasterIdCard({Key? key}) : super(key: key);

  @override
  State<TekMasterIdCard> createState() => _TekMasterIdCardState();
}

class _TekMasterIdCardState extends State<TekMasterIdCard>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;
  final FocusNode _focusNode = FocusNode();
  late AnimationController _cardAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _cardAnimation;
  late Animation<double> _pulseAnimation;

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  PlayerProgress? _savedProgress;

  final List<String> _profileImages = [
    'https://res.cloudinary.com/jerrick/image/upload/d_642250b563292b35f27461a7.png,f_jpg,q_auto,w_720/67347bab768161001d967d28.png',
    'https://pbs.twimg.com/media/GSbiP3-XwAAwTz_.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNytxh56jwPUhoM9CfIoAaqx8sp4UGPkBpXw&s',
  ];
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedProgress();
    
    _nameController.text = "Masukkan Nama";
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _cardAnimationController.forward();
    _pulseAnimationController.repeat(reverse: true);
  }

  Future<void> _loadSavedProgress() async {
    try {
      final progress = await _databaseHelper.getPlayerProgress();
      if (progress != null) {
        setState(() {
          _savedProgress = progress;
          _nameController.text = progress.playerName;
          // Find the index of the saved profile image
          for (int i = 0; i < _profileImages.length; i++) {
            if (_profileImages[i] == progress.profileImageUrl) {
              _selectedImageIndex = i;
              break;
            }
          }
        });
      }
    } catch (e) {
      print('Error loading saved progress: $e');
    }
  }

  Future<void> _saveProgress() async {
    try {
      final progress = PlayerProgress(
        id: _savedProgress?.id,
        playerName: _nameController.text,
        profileImageUrl: _profileImages[_selectedImageIndex],
        currentExp: _savedProgress?.currentExp ?? 0,
        currentGold: _savedProgress?.currentGold ?? 0,
        level: _savedProgress?.level ?? 1,
        playerRank: _savedProgress?.playerRank ?? 'F',
      );

      if (_savedProgress == null) {
        await _databaseHelper.insertPlayerProgress(progress);
      } else {
        await _databaseHelper.updatePlayerProgress(progress);
      }
      
      _savedProgress = progress;
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    _cardAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _focusNode.requestFocus();
        _nameController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _nameController.text.length,
        );
      }
    });
    HapticFeedback.lightImpact();
  }

  void _saveEdit() {
    setState(() {
      _isEditing = false;
    });
    _focusNode.unfocus();
    _saveProgress(); // Save to database
    HapticFeedback.mediumImpact();
  }

  void _showProfileSelector() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF14B8A6).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🎭 Pilih Avatar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _profileImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImageIndex = index;
                          });
                          _saveProgress(); // Save to database
                          HapticFeedback.selectionClick();
                          Navigator.of(context).pop();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: _selectedImageIndex == index
                                  ? const Color(0xFF14B8A6)
                                  : Colors.grey.withOpacity(0.3),
                              width: _selectedImageIndex == index ? 3 : 1,
                            ),
                            boxShadow: _selectedImageIndex == index
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF14B8A6).withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _profileImages[index],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF14B8A6),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.error_outline,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToProfile() {
    _saveProgress(); // Save before navigating
    HapticFeedback.heavyImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(
          playerName: _nameController.text,
          profileImageUrl: _profileImages[_selectedImageIndex],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1a1a1a)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimatedBuilder(
              animation: _cardAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _cardAnimation.value,
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: const Color(0xFF14B8A6).withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with Profile Image
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 220,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(_profileImages[_selectedImageIndex]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF14B8A6).withOpacity(0.8),
                                            const Color(0xFF0F766E).withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF14B8A6).withOpacity(0.4),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: _showProfileSelector,
                                        icon: const Icon(
                                          Icons.photo_camera_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        tooltip: 'Ganti Avatar',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        // Card Content
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name Section
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _nameController,
                                      focusNode: _focusNode,
                                      readOnly: !_isEditing,
                                      maxLength: 20,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        border: _isEditing
                                            ? const UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey),
                                              )
                                            : InputBorder.none,
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF14B8A6),
                                            width: 2,
                                          ),
                                        ),
                                        counterText: '',
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onSubmitted: (_) => _saveEdit(),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: _isEditing ? _saveEdit : _toggleEdit,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: _isEditing
                                            ? const Color(0xFF14B8A6)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF14B8A6),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        _isEditing ? Icons.check_rounded : Icons.edit_rounded,
                                        color: _isEditing ? Colors.white : const Color(0xFF14B8A6),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Stats Section (from saved progress or default)
                              _buildStatRow('🎯 Level', '${_savedProgress?.level ?? 1}', Colors.white),
                              const SizedBox(height: 12),
                              _buildProgressBar((_savedProgress?.currentExp ?? 0) % 500 / 500), // Progress bar based on saved data
                              const SizedBox(height: 12),
                              _buildStatRow('📊 Progress', '${_savedProgress?.currentExp ?? 0}/500', Colors.white),
                              const SizedBox(height: 8),
                              _buildStatRow('🏆 Rank', _savedProgress?.playerRank ?? 'F', const Color(0xFFDC2626)),
                              const SizedBox(height: 8),
                              _buildStatRow('⭐ Total EXP', '${_savedProgress?.currentExp ?? 0}', const Color(0xFFA855F7)),
                              const SizedBox(height: 8),
                              _buildStatRow('💰 Tabungan', '${_savedProgress?.currentGold ?? 0} Gold', const Color(0xFFEAB308)),
                              const SizedBox(height: 30),
                              // Start Button
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF14B8A6).withOpacity(0.4),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _navigateToProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      '🚀 MULAI PETUALANGAN',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFF0F766E).withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

// Enum for Difficulty
enum Difficulty { Easy, Medium, Hard }

// Task Model Class
class Task {
  String title;
  DateTime dueDate;
  Difficulty difficulty;
  bool isCompleted;

  Task({
    required this.title,
    required this.dueDate,
    required this.difficulty,
    this.isCompleted = false,
  });

  int get xpReward {
    switch (difficulty) {
      case Difficulty.Easy:
        return 50;
      case Difficulty.Medium:
        return 100;
      case Difficulty.Hard:
        return 200;
    }
  }
}

// SkillStage Model Class
class SkillStage {
  String title;
  String description;
  int xpReward;
  int goldReward;
  String rankAchieved;
  bool isCompleted;

  SkillStage({
    required this.title,
    this.description = '',
    required this.xpReward,
    required this.goldReward,
    required this.rankAchieved,
    this.isCompleted = false,
  });
}

// Skill Model Class
class Skill {
  String name;
  String description;
  List<SkillStage> stages;
  int currentStageIndex;
  String currentRank;

  Skill({
    required this.name,
    this.description = '',
    required this.stages,
    this.currentStageIndex = 0,
  }) : currentRank = stages.isNotEmpty ? stages[0].rankAchieved : 'F';

  bool get isMastered => currentStageIndex >= stages.length;

  SkillStage? get currentActiveStage {
    if (!isMastered) {
      return stages[currentStageIndex];
    }
    return null;
  }

  void completeCurrentStage() {
    if (!isMastered) {
      stages[currentStageIndex].isCompleted = true;
      currentRank = stages[currentStageIndex].rankAchieved;
      currentStageIndex++;
    }
  }
}

// AchievementItem Model Class
class AchievementItem {
  String name;
  String description;
  int goldCost;
  bool isUnlocked;

  AchievementItem({
    required this.name,
    this.description = '',
    required this.goldCost,
    this.isUnlocked = false,
  });
}

// Chat Message Model Class
class ChatMessage {
  String message;
  bool isUser;
  DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}

// AI Chat Service Class
class AIChatService {
  static final Map<String, List<String>> _skillDatabase = {
    'programming': [
      'Pelajari dasar-dasar sintaks bahasa pemrograman pilihan Anda',
      'Praktikkan dengan membuat program sederhana',
      'Pelajari struktur data dan algoritma',
      'Buat proyek kecil untuk mengaplikasikan pengetahuan',
      'Pelajari framework dan library populer',
      'Kontribusi ke proyek open source',
      'Bangun portfolio dengan proyek kompleks'
    ],
    'design': [
      'Pelajari prinsip-prinsip desain dasar',
      'Kuasai tools desain seperti Figma atau Adobe',
      'Praktikkan dengan membuat desain sederhana',
      'Pelajari teori warna dan tipografi',
      'Buat portfolio desain yang menarik',
      'Ikuti tren desain terkini',
      'Kerjakan proyek desain yang kompleks'
    ],
    'marketing': [
      'Pelajari dasar-dasar pemasaran digital',
      'Kuasai social media marketing',
      'Pelajari SEO dan content marketing',
      'Praktikkan dengan kampanye kecil',
      'Analisis data dan metrics',
      'Pelajari paid advertising',
      'Buat strategi marketing yang komprehensif'
    ],
    'data science': [
      'Pelajari statistik dan matematika dasar',
      'Kuasai Python atau R untuk analisis data',
      'Pelajari SQL untuk database',
      'Praktikkan dengan dataset sederhana',
      'Pelajari machine learning basics',
      'Buat visualisasi data yang menarik',
      'Kerjakan proyek data science end-to-end'
    ],
    'business': [
      'Pelajari fundamental bisnis',
      'Kuasai analisis pasar dan kompetitor',
      'Pelajari financial planning',
      'Praktikkan dengan business plan',
      'Pelajari leadership dan management',
      'Networking dan relationship building',
      'Implementasikan strategi bisnis nyata'
    ]
  };

  static String generateResponse(String userMessage) {
    String message = userMessage.toLowerCase();
    
    // Greeting responses
    if (message.contains('halo') || message.contains('hai') || message.contains('hello')) {
      return '🤖 Halo! Saya AI Assistant KeyBab. Saya siap membantu Anda merencanakan pembelajaran skill baru! Skill apa yang ingin Anda kuasai?';
    }
    
    // Help responses
    if (message.contains('help') || message.contains('bantuan')) {
      return '🤖 Saya bisa membantu Anda:\n\n• Memberikan roadmap pembelajaran skill\n• Menyarankan tahapan belajar\n• Menentukan XP dan Gold reward\n• Memberikan tips motivasi\n\nCoba tanya: "Bagaimana cara belajar programming?" atau "Roadmap untuk design?"';
    }
    
    // Skill-specific responses
    for (String skill in _skillDatabase.keys) {
      if (message.contains(skill)) {
        return _generateSkillRoadmap(skill);
      }
    }
    
    // Programming related keywords
    if (message.contains('coding') || message.contains('pemrograman') || message.contains('developer')) {
      return _generateSkillRoadmap('programming');
    }
    
    // Design related keywords
    if (message.contains('desain') || message.contains('ui') || message.contains('ux')) {
      return _generateSkillRoadmap('design');
    }
    
    // Marketing related keywords
    if (message.contains('pemasaran') || message.contains('digital marketing')) {
      return _generateSkillRoadmap('marketing');
    }
    
    // Data related keywords
    if (message.contains('data') || message.contains('analisis') || message.contains('machine learning')) {
      return _generateSkillRoadmap('data science');
    }
    
    // Business related keywords
    if (message.contains('bisnis') || message.contains('entrepreneur') || message.contains('startup')) {
      return _generateSkillRoadmap('business');
    }
    
    // Motivation responses
    if (message.contains('motivasi') || message.contains('semangat') || message.contains('susah')) {
      return '🤖 💪 Ingat, setiap expert pernah menjadi pemula! Tips untuk tetap termotivasi:\n\n• Set target kecil yang achievable\n• Rayakan setiap progress kecil\n• Bergabung dengan komunitas\n• Praktik konsisten lebih baik dari belajar intensif sesekali\n• Jangan takut membuat kesalahan\n\nKamu pasti bisa! 🚀';
    }
    
    // Default response
    return '🤖 Maaf, saya belum memahami pertanyaan Anda. Coba tanyakan tentang skill yang ingin dipelajari seperti:\n\n• "Bagaimana belajar programming?"\n• "Roadmap untuk design?"\n• "Tips belajar marketing?"\n• "Cara mulai data science?"\n• "Belajar bisnis dari mana?"\n\nAtau ketik "bantuan" untuk info lebih lanjut!';
  }

  static String _generateSkillRoadmap(String skill) {
    List<String> steps = _skillDatabase[skill] ?? [];
    String skillName = skill.replaceAll('_', ' ').toUpperCase();
    
    String roadmap = '🤖 🎯 ROADMAP BELAJAR $skillName\n\n';
    
    for (int i = 0; i < steps.length; i++) {
      String rank = _getRankForStage(i);
      int xp = _getXPForStage(i);
      int gold = _getGoldForStage(i);
      
      roadmap += '${i + 1}. ${steps[i]}\n';
      roadmap += '   📊 Rank: $rank | ⭐ XP: $xp | 💰 Gold: $gold\n\n';
    }
    
    roadmap += '🏆 TOTAL REWARD:\n';
    roadmap += '⭐ Total XP: ${_getTotalXP()} | 💰 Total Gold: ${_getTotalGold()}\n';
    roadmap += '🎖️ Final Rank: S (Master Level)\n\n';
    roadmap += '💡 Tips: Selesaikan tahap demi tahap untuk hasil optimal!';
    
    return roadmap;
  }

  static String _getRankForStage(int stage) {
    List<String> ranks = ['F', 'D', 'C', 'B', 'A', 'S', 'S+'];
    return ranks[min(stage, ranks.length - 1)];
  }

  static int _getXPForStage(int stage) {
    List<int> xpValues = [100, 150, 200, 300, 400, 500, 600];
    return xpValues[min(stage, xpValues.length - 1)];
  }

  static int _getGoldForStage(int stage) {
    List<int> goldValues = [50, 75, 100, 150, 200, 250, 300];
    return goldValues[min(stage, goldValues.length - 1)];
  }

  static int _getTotalXP() {
    return [100, 150, 200, 300, 400, 500, 600].reduce((a, b) => a + b);
  }

  static int _getTotalGold() {
    return [50, 75, 100, 150, 200, 250, 300].reduce((a, b) => a + b);
  }
}

// Profile Page Class
class ProfilePage extends StatefulWidget {
  final String playerName;
  final String profileImageUrl;

  const ProfilePage({
    Key? key,
    required this.playerName,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final List<String> _navItems = ['Home', 'Tugas', 'Skill', 'Pencapaian', 'Chat AI', 'Stats', 'Pengaturan'];
  int _selectedNavIndex = 0;

  // State for XP, Gold, Level, Rank, and Tasks/Skills
  int _currentExp = 0;
  int _currentGold = 0;
  int _level = 1;
  double _progress = 0.0;
  final int _expPerLevel = 500;
  String _playerRank = 'F';
  List<Task> _tasks = [];
  List<Skill> _skills = [];
  List<AchievementItem> _achievementItems = [];

  // Database models
  List<TaskModel> _dbTasks = [];
  List<SkillModel> _dbSkills = [];
  List<AchievementModel> _dbAchievements = [];
  PlayerProgress? _playerProgress;

  // Chat AI State
  List<ChatMessage> _chatMessages = [];
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadDataFromDatabase();
    _initializeChat();
  }

  void _initializeAnimations() {
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _floatController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  void _initializeChat() {
    _chatMessages.add(ChatMessage(
      message: 'Halo ${widget.playerName}! 👋 Saya AI Assistant KeyBab. Saya siap membantu Anda merencanakan pembelajaran skill baru! Skill apa yang ingin Anda kuasai?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _loadDataFromDatabase() async {
    try {
      // Load player progress
      _playerProgress = await _databaseHelper.getPlayerProgress();
      if (_playerProgress != null) {
        setState(() {
          _currentExp = _playerProgress!.currentExp;
          _currentGold = _playerProgress!.currentGold;
          _level = _playerProgress!.level;
          _playerRank = _playerProgress!.playerRank;
          _updateLevelAndProgress();
        });
      }

      // Load tasks
      _dbTasks = await _databaseHelper.getAllTasks();
      setState(() {
        _tasks = _dbTasks.map((dbTask) => Task(
          title: dbTask.title,
          dueDate: dbTask.dueDate,
          difficulty: Difficulty.values.firstWhere(
            (d) => d.toString().split('.').last == dbTask.difficulty,
            orElse: () => Difficulty.Easy,
          ),
          isCompleted: dbTask.isCompleted,
        )).toList();
      });

      // Load skills
      _dbSkills = await _databaseHelper.getAllSkills();
      for (var dbSkill in _dbSkills) {
        final stages = await _databaseHelper.getSkillStages(dbSkill.id!);
        final skillStages = stages.map((stage) => SkillStage(
          title: stage.title,
          description: stage.description,
          xpReward: stage.xpReward,
          goldReward: stage.goldReward,
          rankAchieved: stage.rankAchieved,
          isCompleted: stage.isCompleted,
        )).toList();

        _skills.add(Skill(
          name: dbSkill.name,
          description: dbSkill.description,
          stages: skillStages,
          currentStageIndex: dbSkill.currentStageIndex,
        ));
      }

      // Load achievements
      _dbAchievements = await _databaseHelper.getAllAchievements();
      setState(() {
        _achievementItems = _dbAchievements.map((dbAchievement) => AchievementItem(
          name: dbAchievement.name,
          description: dbAchievement.description,
          goldCost: dbAchievement.goldCost,
          isUnlocked: dbAchievement.isUnlocked,
        )).toList();
      });

    } catch (e) {
      print('Error loading data from database: $e');
    }
  }

  Future<void> _savePlayerProgress() async {
    try {
      final progress = PlayerProgress(
        id: _playerProgress?.id,
        playerName: widget.playerName,
        profileImageUrl: widget.profileImageUrl,
        currentExp: _currentExp,
        currentGold: _currentGold,
        level: _level,
        playerRank: _playerRank,
      );

      if (_playerProgress == null) {
        final id = await _databaseHelper.insertPlayerProgress(progress);
        progress.id = id;
        _playerProgress = progress;
      } else {
        await _databaseHelper.updatePlayerProgress(progress);
        _playerProgress = progress;
      }
    } catch (e) {
      print('Error saving player progress: $e');
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _updateLevelAndProgress() {
    setState(() {
      _level = (_currentExp / _expPerLevel).floor() + 1;
      _progress = (_currentExp % _expPerLevel) / _expPerLevel;
      _playerRank = _getRank(_level);
    });
    _savePlayerProgress();
  }

  void _addExpAndGold(int xp, int gold) {
    setState(() {
      _currentExp += xp;
      _currentGold += gold;
      _updateLevelAndProgress();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Kamu mendapatkan $xp EXP dan $gold Gold! Total EXP: $_currentExp, Total Gold: $_currentGold'),
        backgroundColor: const Color(0xFF14B8A6),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _completeTask(Task task) async {
    try {
      // Find the corresponding database task
      final dbTask = _dbTasks.firstWhere((t) => t.title == task.title);
      dbTask.isCompleted = true;
      await _databaseHelper.updateTask(dbTask);

      setState(() {
        task.isCompleted = true;
        _addExpAndGold(task.xpReward, task.xpReward ~/ 2);
        _tasks.sort((a, b) {
          if (a.isCompleted && !b.isCompleted) return 1;
          if (!a.isCompleted && b.isCompleted) return -1;
          return 0;
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tugas "${task.title}" selesai! Kamu mendapatkan ${task.xpReward} EXP.'),
          backgroundColor: const Color(0xFF14B8A6),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error completing task: $e');
    }
  }

  void _completeSkillStage(Skill skill, SkillStage stage) async {
    try {
      // Find the corresponding database skill
      final dbSkill = _dbSkills.firstWhere((s) => s.name == skill.name);
      dbSkill.currentStageIndex++;
      dbSkill.currentRank = stage.rankAchieved;
      if (dbSkill.currentStageIndex >= skill.stages.length) {
        dbSkill.isMastered = true;
      }
      await _databaseHelper.updateSkill(dbSkill);

      // Update skill stage in database
      final stages = await _databaseHelper.getSkillStages(dbSkill.id!);
      final dbStage = stages[skill.currentStageIndex];
      dbStage.isCompleted = true;
      await _databaseHelper.updateSkillStage(dbStage);

      setState(() {
        skill.completeCurrentStage();
        _addExpAndGold(stage.xpReward, stage.goldReward);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tahap "${stage.title}" untuk skill "${skill.name}" selesai! Kamu mendapatkan ${stage.xpReward} EXP dan ${stage.goldReward} Gold.'),
          backgroundColor: const Color(0xFF14B8A6),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error completing skill stage: $e');
    }
  }

  void _buyAchievementItem(AchievementItem item) async {
    try {
      if (_currentGold >= item.goldCost) {
        // Find the corresponding database achievement
        final dbAchievement = _dbAchievements.firstWhere((a) => a.name == item.name);
        dbAchievement.isUnlocked = true;
        await _databaseHelper.updateAchievement(dbAchievement);

        setState(() {
          _currentGold -= item.goldCost;
          item.isUnlocked = true;
          _savePlayerProgress();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Kamu berhasil membeli "${item.name}"! Sisa Gold: $_currentGold'),
              backgroundColor: const Color(0xFF14B8A6),
              duration: const Duration(seconds: 2),
            ),
          );
          
          _achievementItems.sort((a, b) {
            if (a.isUnlocked && !b.isUnlocked) return 1;
            if (!a.isUnlocked && b.isUnlocked) return -1;
            return 0;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('💰 Gold tidak cukup untuk membeli "${item.name}". Kamu butuh ${item.goldCost - _currentGold} Gold lagi.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error buying achievement item: $e');
    }
  }

  void _sendChatMessage() {
    if (_chatController.text.trim().isEmpty) return;
    
    String userMessage = _chatController.text.trim();
    
    setState(() {
      _chatMessages.add(ChatMessage(
        message: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    
    _chatController.clear();
    
    // Simulate AI thinking delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      String aiResponse = AIChatService.generateResponse(userMessage);
      
      setState(() {
        _chatMessages.add(ChatMessage(
          message: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      
      // Auto scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
    
    // Auto scroll to bottom for user message
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController taskTitleController = TextEditingController();
    DateTime? selectedDate;
    Difficulty? selectedDifficulty;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '➕ Tambah Tugas Baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: taskTitleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nama Tugas',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFF14B8A6),
                                  onPrimary: Colors.white,
                                  onSurface: Colors.white,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF14B8A6),
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'Pilih Tanggal Selesai'
                                  : 'Selesai pada: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                              style: const TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today, color: Colors.white70),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<Difficulty>(
                      value: selectedDifficulty,
                      decoration: const InputDecoration(
                        labelText: 'Tingkat Kesulitan',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: const Color(0xFF1a1a1a),
                      style: const TextStyle(color: Colors.white),
                      items: Difficulty.values.map((Difficulty difficulty) {
                        return DropdownMenuItem<Difficulty>(
                          value: difficulty,
                          child: Text(
                            difficulty.toString().split('.').last,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (Difficulty? newValue) {
                        setState(() {
                          selectedDifficulty = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (taskTitleController.text.isNotEmpty &&
                              selectedDate != null &&
                              selectedDifficulty != null) {
                            try {
                              // Save to database
                              final dbTask = TaskModel(
                                title: taskTitleController.text,
                                dueDate: selectedDate!,
                                difficulty: selectedDifficulty!.toString().split('.').last,
                              );
                              await _databaseHelper.insertTask(dbTask);

                              // Add to local list
                              setState(() {
                                _tasks.add(Task(
                                  title: taskTitleController.text,
                                  dueDate: selectedDate!,
                                  difficulty: selectedDifficulty!,
                                ));
                              });

                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tugas "${taskTitleController.text}" berhasil ditambahkan!'),
                                  backgroundColor: const Color(0xFF14B8A6),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } catch (e) {
                              print('Error adding task: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal menambahkan tugas. Silakan coba lagi.'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mohon lengkapi semua detail tugas.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14B8A6),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Tambahkan Tugas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Color(0xFF14B8A6),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddSkillDialog() {
    final TextEditingController skillNameController = TextEditingController();
    final TextEditingController skillDescriptionController = TextEditingController();
    List<SkillStage> newSkillStages = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '✨ Tambah Skill Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: skillNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nama Skill',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: skillDescriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Skill (Opsional)',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tahapan Skill (Urutkan dari F ke S)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: newSkillStages.length,
                        itemBuilder: (context, index) {
                          final stage = newSkillStages[index];
                          return Card(
                            color: Colors.black.withOpacity(0.3),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tahap ${index + 1}: ${stage.title}',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'EXP: ${stage.xpReward}, Gold: ${stage.goldReward}, Rank: ${stage.rankAchieved}',
                                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        newSkillStages.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showAddSkillStageDialog(
                            onAdd: (stage) {
                              setState(() {
                                newSkillStages.add(stage);
                              });
                            },
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Tambah Tahap', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (skillNameController.text.isNotEmpty && newSkillStages.isNotEmpty) {
                              try {
                                // Save skill to database
                                final dbSkill = SkillModel(
                                  name: skillNameController.text,
                                  description: skillDescriptionController.text,
                                );
                                final skillId = await _databaseHelper.insertSkill(dbSkill);

                                // Save skill stages to database
                                for (int i = 0; i < newSkillStages.length; i++) {
                                  final stage = newSkillStages[i];
                                  final dbStage = SkillStageModel(
                                    skillId: skillId,
                                    title: stage.title,
                                    description: stage.description,
                                    xpReward: stage.xpReward,
                                    goldReward: stage.goldReward,
                                    rankAchieved: stage.rankAchieved,
                                    stageOrder: i,
                                  );
                                  await _databaseHelper.insertSkillStage(dbStage);
                                }

                                // Add to local list
                                setState(() {
                                  _skills.add(Skill(
                                    name: skillNameController.text,
                                    description: skillDescriptionController.text,
                                    stages: newSkillStages,
                                  ));
                                });

                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Skill "${skillNameController.text}" berhasil ditambahkan!'),
                                    backgroundColor: const Color(0xFF14B8A6),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } catch (e) {
                                print('Error adding skill: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal menambahkan skill. Silakan coba lagi.'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mohon lengkapi nama skill dan tambahkan setidaknya satu tahap.'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Tambahkan Skill',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Color(0xFF14B8A6),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddSkillStageDialog({required Function(SkillStage) onAdd}) {
    final TextEditingController stageTitleController = TextEditingController();
    final TextEditingController xpRewardController = TextEditingController();
    final TextEditingController goldRewardController = TextEditingController();
    String? selectedRank;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '➕ Tambah Tahap Skill',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: stageTitleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nama Tahap',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: xpRewardController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'EXP Reward',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: goldRewardController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Gold Reward',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedRank,
                      decoration: const InputDecoration(
                        labelText: 'Rank yang Dicapai',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: const Color(0xFF1a1a1a),
                      style: const TextStyle(color: Colors.white),
                      items: ['F', 'D', 'C', 'B', 'A', 'S'].map((String rank) {
                        return DropdownMenuItem<String>(
                          value: rank,
                          child: Text(rank, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRank = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (stageTitleController.text.isNotEmpty &&
                              xpRewardController.text.isNotEmpty &&
                              goldRewardController.text.isNotEmpty &&
                              selectedRank != null) {
                            onAdd(SkillStage(
                              title: stageTitleController.text,
                              xpReward: int.parse(xpRewardController.text),
                              goldReward: int.parse(goldRewardController.text),
                              rankAchieved: selectedRank!,
                            ));
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mohon lengkapi semua detail tahap skill.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14B8A6),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Tambahkan Tahap',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Color(0xFF14B8A6),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddAchievementItemDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController goldCostController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '⭐ Tambah Pencapaian Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nama Pencapaian',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi (Opsional)',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: goldCostController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'Biaya Gold',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isNotEmpty && goldCostController.text.isNotEmpty) {
                              try {
                                // Save to database
                                final dbAchievement = AchievementModel(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  goldCost: int.parse(goldCostController.text),
                                );
                                await _databaseHelper.insertAchievement(dbAchievement);

                                // Add to local list
                                setState(() {
                                  _achievementItems.add(AchievementItem(
                                    name: nameController.text,
                                    description: descriptionController.text,
                                    goldCost: int.parse(goldCostController.text),
                                  ));
                                });

                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Pencapaian "${nameController.text}" berhasil ditambahkan!'),
                                    backgroundColor: const Color(0xFF14B8A6),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } catch (e) {
                                print('Error adding achievement: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal menambahkan pencapaian. Silakan coba lagi.'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mohon lengkapi nama pencapaian dan biaya gold.'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Tambahkan Pencapaian',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Color(0xFF14B8A6),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA855F7).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '📊 Stats ${widget.playerName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildStatItem('🎯 Level', '$_level', const Color(0xFF14B8A6)),
                _buildStatItem('⭐ Total EXP', '$_currentExp', const Color(0xFFA855F7)),
                _buildStatItem('🏆 Rank', _playerRank, const Color(0xFFDC2626)),
                _buildStatItem('💰 Gold', '$_currentGold', const Color(0xFFEAB308)),
                _buildStatItem('✅ Tugas Selesai', '${_tasks.where((t) => t.isCompleted).length}', const Color(0xFF3B82F6)),
                _buildStatItem('✨ Skill Dikuasai', '${_skills.where((s) => s.isMastered).length}', const Color(0xFF10B981)),
                _buildStatItem('⭐ Pencapaian Terbuka', '${_achievementItems.where((a) => a.isUnlocked).length}', const Color(0xFF3B82F6)),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      color: Color(0xFFA855F7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getRank(int level) {
    if (level < 5) return 'F';
    if (level < 10) return 'D';
    if (level < 15) return 'C';
    if (level < 20) return 'B';
    if (level < 25) return 'A';
    return 'S';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1a1a1a)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildTopNavBar(),
                  const SizedBox(height: 40),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_selectedNavIndex == 0)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth > 800) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: _buildProfileInfo(),
                                      ),
                                      const SizedBox(width: 40),
                                      Expanded(
                                        flex: 6,
                                        child: _buildAnimatedProfile(),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      _buildAnimatedProfile(),
                                      const SizedBox(height: 20),
                                      _buildProfileInfo(),
                                    ],
                                  );
                                }
                              },
                            ),
                          if (_selectedNavIndex == 1)
                            _buildTaskList(),
                          if (_selectedNavIndex == 2)
                            _buildSkillList(),
                          if (_selectedNavIndex == 3)
                            _buildAchievementList(),
                          if (_selectedNavIndex == 4)
                            _buildChatAI(),
                          if (_selectedNavIndex == 5)
                            _buildStatsContent(),
                          if (_selectedNavIndex == 6)
                            _buildSettingsContent(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF14B8A6).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF14B8A6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF14B8A6),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _navItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  String item = entry.value;
                  bool isSelected = _selectedNavIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedNavIndex = index;
                      });
                      HapticFeedback.selectionClick();
                      if (item == 'Stats') {
                        _showStatsDialog();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF14B8A6).withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: isSelected
                            ? Border.all(color: const Color(0xFF14B8A6), width: 1)
                            : null,
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF14B8A6) : Colors.white70,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF14B8A6),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.profileImageUrl),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Selamat Datang,',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
          ).createShader(bounds),
          child: Text(
            widget.playerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Siap Untuk Upgrade Skill Kamu? 🚀',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            _buildActionButton(
              'Tambah Tugas',
              Icons.add_task_rounded,
              const Color(0xFF14B8A6),
              () {
                HapticFeedback.heavyImpact();
                _showAddTaskDialog();
              },
            ),
            _buildActionButton(
              'Tambah Skill',
              Icons.auto_awesome_rounded,
              const Color(0xFFEAB308),
              () {
                HapticFeedback.heavyImpact();
                _showAddSkillDialog();
              },
            ),
            _buildActionButton(
              'Chat AI',
              Icons.smart_toy_rounded,
              const Color(0xFFA855F7),
              () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedNavIndex = 4;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedProfile() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFEF4444).withOpacity(0.8),
                      const Color(0xFFDC2626).withOpacity(0.6),
                      const Color(0xFFB91C1C).withOpacity(0.4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_floatAnimation.value),
              child: Container(
                width: 330,
                height: 330,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          top: 20,
          right: 20,
          child: _buildDecorativeDots(),
        ),
      ],
    );
  }

  Widget _buildDecorativeDots() {
    return Row(
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 500 + (index * 100)),
          margin: const EdgeInsets.only(left: 8),
          width: index == 0 ? 20 : 8,
          height: index == 0 ? 20 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0
                ? Colors.transparent
                : Colors.white.withOpacity(0.6),
            border: index == 0
                ? Border.all(color: Colors.white.withOpacity(0.6), width: 2)
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.5), width: 1),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatAI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.smart_toy_rounded, color: Color(0xFFA855F7), size: 28),
            const SizedBox(width: 10),
            const Text(
              'Chat AI Assistant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  _chatMessages.clear();
                  _chatMessages.add(ChatMessage(
                    message: 'Halo ${widget.playerName}! 👋 Saya AI Assistant KeyBab. Saya siap membantu Anda merencanakan pembelajaran skill baru! Skill apa yang ingin Anda kuasai?',
                    isUser: false,
                    timestamp: DateTime.now(),
                  ));
                });
              },
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFFA855F7)),
              tooltip: 'Reset Chat',
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFA855F7).withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.all(15),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = _chatMessages[index];
                    return _buildChatMessage(message);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Tanya tentang skill yang ingin dipelajari...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: const Color(0xFFA855F7).withOpacity(0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: const Color(0xFFA855F7).withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Color(0xFFA855F7), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onSubmitted: (_) => _sendChatMessage(),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        onPressed: _sendChatMessage,
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        tooltip: 'Kirim Pesan',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFA855F7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFA855F7).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFA855F7), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Contoh Pertanyaan:',
                    style: TextStyle(
                      color: Color(0xFFA855F7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  _buildSuggestionChip('Bagaimana belajar programming?'),
                  _buildSuggestionChip('Roadmap untuk design?'),
                  _buildSuggestionChip('Tips belajar marketing?'),
                  _buildSuggestionChip('Cara mulai data science?'),
                  _buildSuggestionChip('Belajar bisnis dari mana?'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: message.isUser
                     ? const Color(0xFF14B8A6).withOpacity(0.2)
                    : Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: message.isUser
                       ? const Color(0xFF14B8A6).withOpacity(0.3)
                      : const Color(0xFFA855F7).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 17.5,
              backgroundColor: const Color(0xFF14B8A6),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.profileImageUrl),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _chatController.text = text;
        _sendChatMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFA855F7).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFA855F7).withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFA855F7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final activeTasks = _tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = _tasks.where((task) => task.isCompleted).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📝 Tugas Aktif',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        activeTasks.isEmpty
            ? const Text(
                'Tidak ada tugas aktif. Tambahkan tugas baru!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeTasks.length,
                itemBuilder: (context, index) {
                  final task = activeTasks[index];
                  return _buildTaskItemCard(task);
                },
              ),
        const SizedBox(height: 30),
        const Text(
          '✅ Tugas Selesai',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        completedTasks.isEmpty
            ? const Text(
                'Belum ada tugas yang diselesaikan.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  final task = completedTasks[index];
                  return _buildTaskItemCard(task, isCompletedView: true);
                },
              ),
      ],
    );
  }

  Widget _buildTaskItemCard(Task task, {bool isCompletedView = false}) {
    Color difficultyColor;
    switch (task.difficulty) {
      case Difficulty.Easy:
        difficultyColor = Colors.green;
        break;
      case Difficulty.Medium:
        difficultyColor = Colors.orange;
        break;
      case Difficulty.Hard:
        difficultyColor = Colors.red;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFF14B8A6).withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      color: task.isCompleted ? Colors.white54 : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Selesai: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: difficultyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.difficulty.toString().split('.').last,
                      style: TextStyle(
                        color: difficultyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isCompletedView)
              Checkbox(
                value: task.isCompleted,
                onChanged: (bool? newValue) {
                  if (newValue == true) {
                    _completeTask(task);
                  }
                },
                activeColor: const Color(0xFF14B8A6),
                checkColor: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillList() {
    final activeSkills = _skills.where((skill) => !skill.isMastered).toList();
    final masteredSkills = _skills.where((skill) => skill.isMastered).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '✨ Skill Aktif',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        activeSkills.isEmpty
            ? const Text(
                'Tidak ada skill aktif. Tambahkan skill baru untuk dipelajari!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeSkills.length,
                itemBuilder: (context, index) {
                  final skill = activeSkills[index];
                  return _buildSkillItemCard(skill);
                },
              ),
        const SizedBox(height: 30),
        const Text(
          '🏆 Skill Dikuasai',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        masteredSkills.isEmpty
            ? const Text(
                'Belum ada skill yang dikuasai.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: masteredSkills.length,
                itemBuilder: (context, index) {
                  final skill = masteredSkills[index];
                  return _buildSkillItemCard(skill, isMasteredView: true);
                },
              ),
      ],
    );
  }

  Widget _buildSkillItemCard(Skill skill, {bool isMasteredView = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFEAB308).withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    skill.name,
                    style: TextStyle(
                      color: isMasteredView ? Colors.white54 : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: isMasteredView ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAB308).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Rank: ${skill.currentRank}',
                    style: const TextStyle(
                      color: Color(0xFFEAB308),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            if (skill.description.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                skill.description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: isMasteredView ? FontStyle.italic : FontStyle.normal,
                  decoration: isMasteredView ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (!isMasteredView) ...[
              Text(
                'Tahap Saat Ini: ${skill.currentActiveStage?.title ?? 'Selesai'}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: skill.isMastered ? 1.0 : (skill.currentStageIndex / skill.stages.length),
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEAB308)),
              ),
              const SizedBox(height: 10),
              Text(
                'Progress: ${skill.currentStageIndex}/${skill.stages.length} Tahap',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 10),
              if (skill.currentActiveStage != null)
                ElevatedButton(
                  onPressed: () {
                    _completeSkillStage(skill, skill.currentActiveStage!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAB308),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Selesaikan Tahap "${skill.currentActiveStage!.title}" (+${skill.currentActiveStage!.xpReward} EXP, +${skill.currentActiveStage!.goldReward} Gold)',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ] else ...[
              const Text(
                'Skill ini telah dikuasai sepenuhnya!',
                style: TextStyle(color: Colors.white54, fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementList() {
    final availableAchievements = _achievementItems.where((item) => !item.isUnlocked).toList();
    final unlockedAchievements = _achievementItems.where((item) => item.isUnlocked).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💰 Barang Pencapaian Tersedia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        availableAchievements.isEmpty
            ? const Text(
                'Tidak ada pencapaian yang tersedia untuk dibeli. Tambahkan yang baru!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: availableAchievements.length,
                itemBuilder: (context, index) {
                  final item = availableAchievements[index];
                  return _buildAchievementItemCard(item);
                },
              ),
        const SizedBox(height: 30),
        const Text(
          '⭐ Pencapaian Terbuka',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        unlockedAchievements.isEmpty
            ? const Text(
                'Belum ada pencapaian yang terbuka.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: unlockedAchievements.length,
                itemBuilder: (context, index) {
                  final item = unlockedAchievements[index];
                  return _buildAchievementItemCard(item, isUnlockedView: true);
                },
              ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.heavyImpact();
              _showAddAchievementItemDialog();
            },
            icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white),
            label: const Text(
              'Tambah Barang Pencapaian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEAB308),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: const Color(0xFFEAB308).withOpacity(0.4),
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItemCard(AchievementItem item, {bool isUnlockedView = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFEAB308).withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: isUnlockedView ? Colors.white54 : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: isUnlockedView ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                ),
                if (!isUnlockedView)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAB308).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Color(0xFFEAB308), size: 16),
                        const SizedBox(width: 5),
                        Text(
                          '${item.goldCost} Gold',
                          style: const TextStyle(
                            color: Color(0xFFEAB308),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                        SizedBox(width: 5),
                        Text(
                          'Terbuka',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                item.description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: isUnlockedView ? FontStyle.italic : FontStyle.normal,
                  decoration: isUnlockedView ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (!isUnlockedView)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _buyAchievementItem(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAB308),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Beli',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📊 Statistik Pemain',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildStatItem('🎯 Level', '$_level', const Color(0xFF14B8A6)),
        _buildStatItem('⭐ Total EXP', '$_currentExp', const Color(0xFFA855F7)),
        _buildStatItem('🏆 Rank', _playerRank, const Color(0xFFDC2626)),
        _buildStatItem('💰 Gold', '$_currentGold', const Color(0xFFEAB308)),
        _buildStatItem('✅ Tugas Selesai', '${_tasks.where((t) => t.isCompleted).length}', const Color(0xFF3B82F6)),
        _buildStatItem('✨ Skill Dikuasai', '${_skills.where((s) => s.isMastered).length}', const Color(0xFF10B981)),
        _buildStatItem('⭐ Pencapaian Terbuka', '${_achievementItems.where((a) => a.isUnlocked).length}', const Color(0xFF3B82F6)),
        const SizedBox(height: 20),
        const Text(
          'Ini adalah ringkasan statistik Anda. Selesaikan lebih banyak tugas dan skill untuk meningkatkan level dan rank Anda!',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSettingsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚙️ Pengaturan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.volume_up, color: Color(0xFF14B8A6)),
          title: const Text('Efek Suara', style: TextStyle(color: Colors.white)),
          trailing: Switch(
            value: true,
            onChanged: (bool value) {
              // Handle sound settings
            },
            activeColor: const Color(0xFF14B8A6),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.notifications, color: Color(0xFF14B8A6)),
          title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
          trailing: Switch(
            value: false,
            onChanged: (bool value) {
              // Handle notification settings
            },
            activeColor: const Color(0xFF14B8A6),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () async {
              // Show confirmation dialog
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF1a1a1a),
                    title: const Text('Reset Data', style: TextStyle(color: Colors.white)),
                    content: const Text(
                      'Apakah Anda yakin ingin menghapus semua data? Tindakan ini tidak dapat dibatalkan.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Batal', style: TextStyle(color: Color(0xFF14B8A6))),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Reset', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                try {
                  await _databaseHelper.clearAllData();
                  setState(() {
                    _currentExp = 0;
                    _currentGold = 0;
                    _level = 1;
                    _playerRank = 'F';
                    _tasks.clear();
                    _skills.clear();
                    _achievementItems.clear();
                    _dbTasks.clear();
                    _dbSkills.clear();
                    _dbAchievements.clear();
                    _playerProgress = null;
                    _updateLevelAndProgress();
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua data berhasil dihapus!'),
                      backgroundColor: Color(0xFF14B8A6),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  print('Error resetting data: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal menghapus data. Silakan coba lagi.'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Reset Data',
              style: TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
