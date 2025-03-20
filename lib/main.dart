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
                'LED Banner Creator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
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
            const Text(
              'LED Banner Creator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
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
  double _fontSize = 40; // Add this line
  final List<String> _fonts = ["Arial", "Courier", "Times New Roman", "Verdana", "HighSpeedFont"];
  String _selectedFont = "Arial";

  @override
  void initState() {
    super.initState();
    _startBlinking();
    _startScrolling();
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

  void _startScrolling() {
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (mounted) {
        setState(() {
          _position -= _speed;
          if (_position < -300) {
            _position = MediaQuery.of(context).size.width;
          }
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
            _buildFontSizeSlider(), // Add this line
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

  Widget _buildFontSizeSlider() { // Add this method
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
            fontSize: _fontSize, // Update this line
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

  const DisplayScreen({
    super.key,
    required this.text,
    required this.color,
    required this.font,
    required this.speed,
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

    _animation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(-1, 0),
    ).animate(_animationController);

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
                fontSize: 60,
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