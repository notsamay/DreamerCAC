import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

TextStyle headers = GoogleFonts.dosis(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

class DrawingGame extends StatefulWidget {
  const DrawingGame({Key? key}) : super(key: key);

  @override
  State<DrawingGame> createState() => _ColorsExamplesState();
}
class _ColorsExamplesState extends State<DrawingGame> with TickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorTween;

  int _currentIndex = 0;
  int questionCount = 0;
  List<DrawingPoint?> drawingPoints = [];
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green
  ];
  final List<String> _texts = [
    'DRAW SOMETHING RED',
    'DRAW SOMETHING BLUE',
    'DRAW SOMETHING YELLOW',
    'DRAW SOMETHING GREEN'
  ];
  final List<String> _imagePaths = [
    'assets/ColoredPencils/red_pencil.png',
    'assets/ColoredPencils/blue_pencil.png',
    'assets/ColoredPencils/yellow_pencil.png',
    'assets/ColoredPencils/green_pencil.png',
  ];

  Timer? _timer;
  int _highlightedIndex = 0;
  int _drawingIndex = 0;
  double strokeWidth = 25;
  bool _highlightLastWord = false;
  bool _buttonDisabled = false;
  late Color _buttonColor = const Color.fromARGB(255, 196, 156, 252);

  final Set<int> _usedIndices = {};

  late AnimationController _shakeController; // Added for animation
 
  final player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _colorTween = ColorTween(
      begin: _colors[_currentIndex],
      end: _colors[_currentIndex],
    ).animate(_colorAnimationController);
    _startHighlighting();
    _disableButton();

    // Initialize shake animation controller and animations

  }

  @override
  void dispose() {
    _timer?.cancel();
    player.dispose();
    _colorAnimationController.dispose();
    _shakeController.dispose(); // Dispose of shake animation controller
    super.dispose();
  }

  void _disableButton() {
    // Initially disable the button
    bool disableButton = true;


    // Check if drawingPoints is not empty and if the drawn color matches the current index color
    if (drawingPoints.isNotEmpty && isDrawnColorMatchingCurrentIndex(_currentIndex)) {
      disableButton = false; // Enable the button
    }

    setState(() {
      _buttonDisabled = disableButton;
      // Set the button color based on whether it's disabled or enabled
    });
  }

void _changeColor(int index) {
  final random = Random();
  final availableIndices = List.generate(_colors.length, (index) => index)
      .where((i) => i != _currentIndex)
      .toList();

  if (availableIndices.isEmpty) {
    // If all colors have been used, reset used indices
    _currentIndex = random.nextInt(_colors.length);
    _usedIndices.clear();
  } else {
    final randomIndex = random.nextInt(availableIndices.length);
    setState(() {
      _currentIndex = availableIndices[randomIndex];
      _highlightedIndex = 0; // Reset highlighted index when changing the color
      _highlightLastWord = false; // Reset highlight flag
      _startHighlighting(); // Restart highlighting for the new sentence
      drawingPoints.clear();
    });

    // Introduce a 2-second delay before moving to the next question

  }
}


  void _playWordAudio(String word) {
    final audioFileName = '${word.toUpperCase()}.mp3'; // Assuming audio files are named as the uppercase word
    player.play(AssetSource(audioFileName)); // Assuming audio files are stored locally
  }

void _startHighlighting() {
  const highlightDuration = Duration(milliseconds: 1000);
  final words = _texts[_currentIndex].split(" ");
  int currentWordIndex = 0;

  _timer = Timer.periodic(highlightDuration, (timer) {
    setState(() {
      if (currentWordIndex >= words.length) {
        _timer?.cancel();
        _highlightedIndex = words.length - 1;
        _highlightLastWord = true;
      } else {
        final highlightedWord = words[currentWordIndex];
        _highlightedIndex = currentWordIndex;
        currentWordIndex++;
        _highlightLastWord = false;
        _playWordAudio(highlightedWord);
      }
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 245, 255),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    iconSize: 40,
                    color: Colors.black,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.725,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        width: MediaQuery.of(context).size.width *
                            0.8 *
                            (questionCount / 20),
                        height: 25,
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
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          drawingPoints.add(DrawingPoint(
                            details.localPosition,
                            Paint()
                              ..color = _colors[_drawingIndex]
                              ..isAntiAlias = true
                              ..strokeWidth = strokeWidth
                              ..strokeCap = StrokeCap.round,
                          ));
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          drawingPoints.add(DrawingPoint(
                            details.localPosition,
                            Paint()
                              ..color = _colors[_drawingIndex]
                              ..isAntiAlias = true
                              ..strokeWidth = strokeWidth
                              ..strokeCap = StrokeCap.round,
                          ));
                          if (isDrawnColorMatchingCurrentIndex(_currentIndex)) {
                            _buttonDisabled = false;
                          }
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          drawingPoints.add(null);
                          if (isDrawnColorMatchingCurrentIndex(_currentIndex)) {
                            _buttonDisabled = false;
                          } else {
                            HapticFeedback.vibrate();
                            // Clear drawing points if the drawing color index doesn't match the index of the color
                            drawingPoints.clear();
                          
                          }
                        });
                      },
                      child: CustomPaint(
                        painter: _DrawingPainter(drawingPoints),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 16.0,
                    right: 16.0,
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: headers,
                          children: _texts[_currentIndex]
                              .split(" ")
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final word = entry.value;
                            final isLastWord = index ==
                                _texts[_currentIndex].split(" ").length - 1;
                            return TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: _highlightLastWord && isLastWord
                                          ? _colors[_currentIndex]
                                              .withOpacity(0.5)
                                          : _highlightedIndex == index
                                              ? _colors[_currentIndex]
                                                  .withOpacity(0.5)
                                              : null,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      word,
                                      style: headers.copyWith(
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                                if (index <
                                    _texts[_currentIndex].split(" ").length - 1)
                                  const TextSpan(
                                    text: ' ',
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 0),
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * .875,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCircleButton(0),
                    _buildCircleButton(1),
                    _buildCircleButton(2),
                    _buildCircleButton(3),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 325, // Fixed width'[[[]==]]
                
                height: 100, // Fixed height
                decoration: BoxDecoration(
                  color: _buttonColor = _buttonDisabled
                      ? const Color.fromARGB(255, 196, 156, 252) // Disabled color
                      : const Color.fromARGB(255, 123, 28, 255), // Enabled color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: drawingPoints.isNotEmpty && !_buttonDisabled
                      ? () {
                        HapticFeedback.heavyImpact();
                          _disableButton();
    Future.delayed(Duration(seconds: 2), () {
  _changeColor(_currentIndex);

  questionCount++;
  if (questionCount == 20) {
    Navigator.pop(context);
  }
});

                        }
                      : null,
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(int index) {
    double height = _drawingIndex == index ? 140 : 130;
    double translateY = _drawingIndex == index ? 20 : 35;

    return GestureDetector(
      onTap: () {
        if (!isDrawnColorMatchingCurrentIndex(index)) {
          setState(() {
            _drawingIndex = index;
            HapticFeedback.mediumImpact();
          });
        }
      },
      child: AbsorbPointer(
        absorbing: isDrawnColorMatchingCurrentIndex(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 50,
          height: height,
          transform: Matrix4.translationValues(0, translateY, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Image.asset(
            _imagePaths[index],
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  bool isDrawnColorMatchingCurrentIndex(int index) {
    return _colors[_drawingIndex] == _colors[_currentIndex];
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  _DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          drawingPoints[i]!.paint,
        );
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        canvas.drawPoints(
          PointMode.points,
          [drawingPoints[i]!.offset],
          drawingPoints[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint(this.offset, this.paint);
}
