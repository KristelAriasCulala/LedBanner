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
      home: const HomeScreen(),
    );
  }
}

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
  final List<String> _fonts = ["Arial", "Courier", "Times New Roman", "Verdana"];
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

  Widget _buildLEDText() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _isBlinking ? 1.0 : 0.2,
        child: Text(
          _textController.text,
          style: TextStyle(
            fontSize: 40,
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (20 / widget.speed).round()),
    )..repeat(reverse: false);

    _animation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(-1, 0),
    ).animate(_animationController);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
          child: Text(
            widget.text.isEmpty ? "Welcome!" : widget.text,
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
    );
  }
}