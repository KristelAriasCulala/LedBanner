import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LED Banner',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const SplashScreen(), // Start with the splash screen
    );
  }
}

/// Splash Screen with Fade-in Animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation controller for fade-in effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Navigate to HomeScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lightbulb, size: 80, color: Colors.red), // App icon
              const SizedBox(height: 10),
              const Text(
                'Neonora',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: 1.0,
              child: Text(
                'Neonora',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'HighSpeedFont',
                  shadows: [
                    Shadow(
                      blurRadius: 15,
                      color: Colors.lightBlueAccent.withOpacity(0.8),
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '🎇 Turn your phone into a vibrant LED banner with Neonora! 🌈',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LEDBannerScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                elevation: 4,
              ),
              child: const Text(
                'Create Your Banners',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// LED Banner Screen
class LEDBannerScreen extends StatefulWidget {
  const LEDBannerScreen({super.key});

  @override
  State<LEDBannerScreen> createState() => _LEDBannerScreenState();
}

class _LEDBannerScreenState extends State<LEDBannerScreen> {
  final TextEditingController _textController = TextEditingController(text: "Welcome!");
  Color _selectedColor = Colors.red;
  bool _isBlinking = true;
  double _position = 0;
  double _speed = 2;
  double _fontSize = 40;
  final List<String> _fonts = ["Arial", "Courier", "Times New Roman", "Verdana", "HighSpeedFont"];
  String _selectedFont = "Arial";
  final List<String> _directions = ["Left", "Right", "Up", "Down"];
  String _selectedDirection = "Left"; // Default direction

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _isBlinking = !_isBlinking;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LED Banner", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildTextField(),
            const SizedBox(height: 15),
            _buildFontDropdown(),
            const SizedBox(height: 15),
            _buildColorSelection(),
            const SizedBox(height: 10),
            _buildSpeedSlider(),
            const SizedBox(height: 10),
            _buildFontSizeSlider(),
            const SizedBox(height: 10),
            _buildDirectionDropdown(), // Add direction dropdown
            const Text("Your Display Text:",
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildLEDText(),
            const SizedBox(height: 10),
            _buildDisplayButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textController,
      decoration: InputDecoration(
        labelText: "Enter your text",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildFontDropdown() {
    return DropdownButton<String>(
      dropdownColor: Colors.black,
      value: _selectedFont,
      items: _fonts.map((font) {
        return DropdownMenuItem(
          value: font,
          child: Text(font, style: TextStyle(fontFamily: font, color: Colors.white)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedFont = value!;
        });
      },
    );
  }

  Widget _buildDirectionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Direction", // Text label for the direction dropdown
          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8), // Add some spacing
        DropdownButton<String>(
          dropdownColor: Colors.black,
          value: _selectedDirection,
          isExpanded: true, // Ensures the dropdown takes full width
          items: _directions.map((direction) {
            return DropdownMenuItem(
              value: direction,
              child: Container(
                alignment: Alignment.center, // Centers the text
                child: Text(
                  direction,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center, // Ensures text is centered
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDirection = value!;
            });
          },
        ),
      ],
    );
  }


  Widget _buildColorSelection() {
    return Wrap(
      spacing: 10,
      children: [
        buildColorButton(Colors.red),
        buildColorButton(Colors.green),
        buildColorButton(Colors.blue),
        buildColorButton(Colors.yellow),
        buildColorButton(Colors.purple),
      ],
    );
  }

  Widget _buildSpeedSlider() {
    return Column(
      children: [
        const Text("Adjust Speed", style: TextStyle(color: Colors.white70)),
        Slider(
          value: _speed,
          min: 1,
          max: 10,
          divisions: 9,
          label: _speed.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _speed = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFontSizeSlider() {
    return Column(
      children: [
        const Text("Adjust Font Size", style: TextStyle(color: Colors.white70)),
        Slider(
          value: _fontSize,
          min: 20,
          max: 100,
          divisions: 8,
          label: _fontSize.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildLEDText() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _isBlinking ? 1.0 : 0.2,
        child: Text(
          _textController.text,
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.bold,
            color: _selectedColor,
            fontFamily: _selectedFont,
            shadows: [
              Shadow(
                blurRadius: 15,
                color: _selectedColor.withOpacity(0.8),
                offset: const Offset(3, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white38, width: 2),
        ),
      ),
    );
  }

  Widget _buildDisplayButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayScreen(
              text: _textController.text,
              color: _selectedColor,
              font: _selectedFont,
              speed: _speed,
              fontSize: _fontSize,
              direction: _selectedDirection, // Pass the direction here
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        elevation: 4,
      ),
      child: const Text(
        "Display",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }
}

class DisplayScreen extends StatefulWidget {
  final String text;
  final Color color;
  final String font;
  final double speed;
  final double fontSize;
  final String direction; // Add direction parameter

  const DisplayScreen({
    super.key,
    required this.text,
    required this.color,
    required this.font,
    required this.speed,
    required this.fontSize,
    required this.direction, // Add direction parameter
  });

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Timer _blinkTimer;
  bool _isBlinking = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (20 / widget.speed).round()),
    )..repeat(reverse: false);

    // Set animation direction based on the selected direction
    switch (widget.direction) {
      case "Left":
        _animation = Tween<Offset>(
            begin: const Offset(1, 0), end: const Offset(-1, 0)).animate(_animationController);
        break;
      case "Right":
        _animation = Tween<Offset>(
            begin: const Offset(-1, 0), end: const Offset(1, 0)).animate(_animationController);
        break;
      case "Up":
        _animation = Tween<Offset>(
            begin: const Offset(0, 1), end: const Offset(0, -1)).animate(_animationController);
        break;
      case "Down":
        _animation = Tween<Offset>(
            begin: const Offset(0, -1), end: const Offset(0, 1)).animate(_animationController);
        break;
      default:
        _animation = Tween<Offset>(
            begin: const Offset(1, 0), end: const Offset(-1, 0)).animate(_animationController);
    }

    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _isBlinking = !_isBlinking;
        });
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _blinkTimer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SlideTransition(
          position: _animation,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _isBlinking ? 1.0 : 0.2,
            child: Text(
              widget.text.isEmpty ? "Welcome!!" : widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: widget.color,
                fontFamily: widget.font,
              ),
            ),
          ),
        ),
      ),
    );
  }
}