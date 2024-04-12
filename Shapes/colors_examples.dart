import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

TextStyle headers = GoogleFonts.dosis(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

class ColorsExamples extends StatefulWidget {
  const ColorsExamples({Key? key}) : super(key: key);

  @override
  State<ColorsExamples> createState() => _ColorsExamplesState();
}

class _ColorsExamplesState extends State<ColorsExamples>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final player = AudioPlayer();
  int _currentIndex = 0;
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green
  ];
  final List<String> _imagePaths = [
    'assets/ExamplePage/hat.png',
    'assets/ExamplePage/water.png',
    'assets/ExamplePage/bus.png',
    'assets/ExamplePage/tree.png',
  ];
  final List<String> _texts = [
    'THE HAT IS RED',
    'THE WATER IS BLUE',
    'THE BUS IS YELLOW',
    'THE TREE IS GREEN'
  ];
  Timer? _timer;
  int _highlightedIndex = 0;
  bool _highlightLastWord = false;
  bool _buttonDisabled = false;
  Color _buttonColor = const Color.fromARGB(255, 123, 28, 255);
  bool confetti = false;
  final cC = ConfettiController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
    _startHighlighting();
    _disableButton();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    cC.dispose(); // Dispose confetti controller
    super.dispose();
  }

  void _disableButton() {
    setState(() {
      _buttonDisabled = true;
      _buttonColor = const Color.fromARGB(200, 123, 28, 255);
    });

    Future.delayed(const Duration(milliseconds: 3250), () {
      setState(() {
        _buttonColor = const Color.fromARGB(255, 123, 28, 255);
        _buttonDisabled = false;
      });
    });
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

void _changeColor() {
  setState(() {
    player.setVolume(1.0);
    _disableButton();
    if (_currentIndex < _colors.length - 1) {
 // Play word audio when changing color
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _currentIndex++;
          _highlightedIndex = 0;
          _highlightLastWord = false;
          _startHighlighting();
          _animationController.forward(from: 0);
        });
      });
    } else {
 // Play word audio for the final sentence


      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
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
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOut,
                        width: MediaQuery.of(context).size.width * 0.8 * (_currentIndex / 4),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                      final isLastWord =
                          index == _texts[_currentIndex].split(" ").length - 1;
                      return TextSpan(
                        children: [
                          WidgetSpan(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _highlightLastWord && isLastWord
                                    ? _colors[_currentIndex].withOpacity(0.5)
                                    : _highlightedIndex == index
                                        ? _colors[_currentIndex].withOpacity(0.5)
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0), // Add padding to move the button and image up
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: .25, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.bounceOut, // Use bounceInOut curve
                        ),
                      ),
                      child: Image(
                        key: Key(_imagePaths[_currentIndex]),
                        image: AssetImage(_imagePaths[_currentIndex]),
                        width: 325,
                        height: 275,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _buttonDisabled ? 0.5 : 1.0,
                child: IgnorePointer(
                  ignoring: _buttonDisabled,
                  child: Container(
                    width: 325,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 100),
                    decoration: BoxDecoration(
                      color: _buttonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: _buttonDisabled ? null : () {
                        HapticFeedback.heavyImpact();
                        _changeColor();
                        _playWordAudio(_texts[_currentIndex]);
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
    );
  }
}

