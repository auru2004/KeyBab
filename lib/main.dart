import 'package:flutter/material.dart';

class TekMasterIdCard extends StatefulWidget {
  const TekMasterIdCard({Key? key}) : super(key: key);

  @override
  State<TekMasterIdCard> createState() => _TekMasterIdCardState();
}

class _TekMasterIdCardState extends State<TekMasterIdCard> {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;
  final FocusNode _focusNode = FocusNode();
  
  // Profile image options
  final List<String> _profileImages = [
    'https://res.cloudinary.com/jerrick/image/upload/d_642250b563292b35f27461a7.png,f_jpg,q_auto,w_720/67347bab768161001d967d28.png',
    'https://pbs.twimg.com/media/GSbiP3-XwAAwTz_.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNytxh56jwPUhoM9CfIoAaqx8sp4UGPkBpXw&s',
  ];
  
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController.text = "isi nama";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _focusNode.requestFocus();
      }
    });
  }

  void _saveEdit() {
    setState(() {
      _isEditing = false;
    });
    _focusNode.unfocus();
  }

  void _showProfileSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0f1a1a),
          title: const Text(
            'Pilih Profil',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'RobotoSlab',
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: _profileImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedImageIndex == index
                            ? const Color(0xFF14B8A6)
                            : Colors.grey.withOpacity(0.3),
                        width: _selectedImageIndex == index ? 3 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        _profileImages[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF14B8A6),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.withOpacity(0.3),
                            child: const Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFF14B8A6),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          playerName: _nameController.text,
          profileImageUrl: _profileImages[_selectedImageIndex],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF0f1a1a),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Image with Profile Selector
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_profileImages[_selectedImageIndex]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: _showProfileSelector,
                          icon: const Icon(
                            Icons.photo_camera,
                            color: Color(0xFF14B8A6),
                            size: 20,
                          ),
                          tooltip: 'Pilih Profil',
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Card Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Editable Name Section
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
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'RobotoSlab',
                              ),
                              decoration: InputDecoration(
                                border: _isEditing
                                    ? const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      )
                                    : InputBorder.none,
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF14B8A6)),
                                ),
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (_) => _saveEdit(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _isEditing ? _saveEdit : _toggleEdit,
                            child: Icon(
                              _isEditing ? Icons.check : Icons.edit,
                              color: const Color(0xFF14B8A6),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Level
                      const Text(
                        'Level 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'RobotoSlab',
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Progress Bar
                      Row(
                        children: [
                          const Text(
                            '0%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'RobotoSlab',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F766E),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: 0.0, // 0% progress
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF14B8A6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Stats
                      const Text(
                        '0/500',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'RobotoSlab',
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      const Text(
                        'Rank F',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'RobotoSlab',
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Total EXP
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'RobotoSlab',
                          ),
                          children: [
                            TextSpan(text: 'Total : '),
                            TextSpan(
                              text: '0 EXP',
                              style: TextStyle(
                                color: Color(0xFFA855F7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Tabungan
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'RobotoSlab',
                          ),
                          children: [
                            TextSpan(text: 'Tabungan : '),
                            TextSpan(
                              text: '0 Gold',
                              style: TextStyle(
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Start Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _startGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'MULAI',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab',
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
        ),
      ),
    );
  }
}

// Halaman Game yang menampilkan foto profil di ujung
class GamePage extends StatelessWidget {
  final String playerName;
  final String profileImageUrl;

  const GamePage({
    Key? key,
    required this.playerName,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f1a1a),
        title: Text(
          'Guild Master',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoSlab',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Profile picture di ujung kanan
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF14B8A6),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(profileImageUrl),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error if image fails to load
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF14B8A6),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome message
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0f1a1a),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      playerName,
                      style: const TextStyle(
                        color: Color(0xFF14B8A6),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Siap Untuk Upgrade Skill Kamu',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Game content placeholder
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF0f1a1a),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF14B8A6).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Game Content\nAkan Dimuat Di Sini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontFamily: 'RobotoSlab',
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

// Untuk menggunakan widget ini dalam aplikasi Flutter
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEKMASTER ID Card',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const TekMasterIdCard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(const MyApp());
}