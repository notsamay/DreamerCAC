import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

TextStyle headers = GoogleFonts.dosis(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

class ShapesLesson extends StatefulWidget {
  const ShapesLesson({Key? key}) : super(key: key);

  @override
  State<ShapesLesson> createState() => _ShapesLessonState();
}

class _ShapesLessonState extends State<ShapesLesson> {
  int _currentIndex = 0;
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green
  ];
  final List<String> _texts = [' RED ', ' BLUE ', ' YELLOW ', ' GREEN '];
  final List<String> _color = ['RED', 'BLUE', 'YELLOW', 'GREEN'];
  bool _buttonDisabled = false;
  Color _buttonColor = const Color.fromARGB(255, 123, 28, 255);
  Color _highlightColor = Colors.white.withOpacity(0.5); // Highlight color
  double _boxSize = 2000; // Initial size of the orange box, covering the whole screen
    final player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _disableButton();
    _highlightText();
    _changeColor();
    player.play(AssetSource('RED.mp3'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _changeColor() {
    setState(() {
      if (_currentIndex < _colors.length - 1) {
        _disableButton();
        _highlightText(); // Highlight text when changing color
        // Animate the box size to 300 by 300

      }
    });
  }

  void _disableButton() {
    setState(() {
      _buttonDisabled = true;
      _buttonColor = const Color.fromARGB(200, 123, 28, 255);
    });

    // Reset the box size to 2000 instantly
    _animateBoxSize(2000);

    // Delay the animation to 300 after 1250 milliseconds
    Future.delayed(const Duration(milliseconds: 1250), () {
      setState(() {
        _buttonColor = const Color.fromARGB(255, 123, 28, 255);
        _buttonDisabled = false;
        _animateBoxSize(300.0);
      });
    });
  }

  void _highlightText() {
    setState(() {
      
      _highlightColor = _colors[_currentIndex].withOpacity(0.5);

    });

    // Timer to reset highlight color after 0.25 seconds
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _highlightColor = Colors.transparent; // Reset highlight color
      });
    });
  }

  void _animateBoxSize(double targetSize) {
    setState(() {
      _boxSize = targetSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 245, 255),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top), // To respect top safe area
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        iconSize: 45,
                        color: Colors.black,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 27.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[300],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            width: MediaQuery.of(context).size.width * 0.8 * (_currentIndex / 4),
                            height: 27.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(255, 123, 28, 255),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 550), // Spacer with 300 height
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 750),
                    opacity: _buttonDisabled ? 0.5 : 1.0,
                    child: IgnorePointer(
                      ignoring: _buttonDisabled,
                      child: Container(
                        width: 325,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                        decoration: BoxDecoration(
                          color: _buttonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: _buttonDisabled
                              ? null
                              : () {
                                  HapticFeedback.heavyImpact();
                                  if (_currentIndex < _colors.length - 1) {
                                                  Future.delayed(Duration(seconds: 2), () async {
                                  _changeColor();
                                                                     _currentIndex++;
                                  final highlightedWord = _color[_currentIndex];

                                  await player.play(AssetSource('$highlightedWord.mp3'));
                                 
                              });

                                  
                                  } else {
                                             
                                                                                      Future.delayed(Duration(seconds: 2), () async {
                                 Navigator.pop(context);
                              });
                                  
                                  }
                                },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 60, // Adjust position under the bar
            left: 16.0,
            right: 16.0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: _highlightColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _texts[_currentIndex],
                    style: headers,
                  ),
                ),
              ),
            ),
          ),
GestureDetector(
  onTap: () {
    bool buttonDisabled = false; // Local variable to track tapping status
    if (!buttonDisabled) {
      HapticFeedback.mediumImpact();
      setState(() {
         buttonDisabled = true;
        _animateBoxSize(1000); // Increase the size of the square
      });
      // Disable tapping
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _animateBoxSize(300); // Return to the original size after a short delay
          buttonDisabled = false; // Enable tapping after the delay
        });
      });
      _highlightText(); // Highlight text
    }
  },


            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                width: _boxSize,
                height: _boxSize,
                decoration: BoxDecoration(
                  color: _colors[_currentIndex].withOpacity(1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
