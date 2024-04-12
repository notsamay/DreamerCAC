import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

TextStyle headers = GoogleFonts.dosis(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontSize: 26,
  fontWeight: FontWeight.bold,
);
TextStyle header2 = GoogleFonts.dosis(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontSize: 26,
  fontWeight: FontWeight.w700,
);

class ColorsQuiz extends StatefulWidget {
  const ColorsQuiz({Key? key}) : super(key: key);

  @override
  State<ColorsQuiz> createState() => _ColorsQuiz();
}

class _ColorsQuiz extends State<ColorsQuiz> with SingleTickerProviderStateMixin {
  late AnimationController _opacityController;
  int _selectedAnswerIndex = -1; // Default value to indicate no answer selected

  int _currentIndex = 0;
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.red,
    Colors.green,
    Colors.yellow,
  ];

  int blueIndex = 0;
  int redIndex = 0;
  int greenIndex = 0;
  int yellowIndex = 0;

  final List<String> Labels = [
    ' RED ',
    ' BLUE ',
    'YELLOW',
    ' GREEN ',
  ];

  final List<String> _questionImages = [
    'assets/ExamplePage/water.png',
    'assets/ExamplePage/clover.png',
    'assets/ExamplePage/bus.png',
    'assets/ExamplePage/hat.png',
    'assets/ExamplePage/duck.png',
  ];
  final List<String> _redImages = [
    'assets/ExamplePage/hat.png',
    'assets/ExamplePage/apple.png',
  ];
  final List<String> _blueImages = [
    'assets/ExamplePage/water.png',
    'assets/ExamplePage/water.png',
  ];
  final List<String> _greenImages = [
    'assets/ExamplePage/tree.png',
    'assets/ExamplePage/clover.png',
  ];
  final List<String> _yellowImages = [
    'assets/ExamplePage/bus.png',
    'assets/ExamplePage/duck.png',
  ];
  final List<String> _texts = [
    'WHICH OBJECT IS RED',
    'WHAT COLOR IS THE WATER',
    'WHICH OBJECT IS YELLOW',
    'WHAT COLOR IS THE CLOVER',
    'WHICH OBJECT IS BLUE',
    'WHAT COLOR IS THE BUS',
    'WHICH OBJECT IS GREEN',
    'WHAT COLOR IS THE HAT',
    'WHICH OBJECT IS GREEN',
    'WHAT COLOR IS THE DUCK',
  ];
  final List<int> _answers = [
    0, 1, 2, 3, 1, 2, 3, 0, 3, 2,
  ];
  final List<Color> highlight = [
  Colors.red,
  Colors.blue,
  Colors.yellow,
  Colors.green
  ];
  Timer? _timer;
  int _highlightedIndex = 0;
  bool _highlightLastWord = false;
  bool _buttonDisabled = false;
  Color _buttonColor = const Color.fromARGB(255, 123, 28, 255);
   final player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _startHighlighting();
    _disableButton();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
  }

  @override
  void dispose() {
    _timer?.cancel();
    _opacityController.dispose();
    player.dispose();
    super.dispose();
  }

  void _disableButton() {
    setState(() {
      _buttonDisabled = true;
      _buttonColor = const Color.fromARGB(200, 123, 28, 255);
      blueIndex = getRandomIndex(_blueImages);
      redIndex = getRandomIndex(_redImages);
      greenIndex = getRandomIndex(_greenImages);
      yellowIndex = getRandomIndex(_yellowImages);
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
    _buttonDisabled = true; // Disable the button while waiting for the delay
  });

  // Delay for 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    setState(() {
      if (_currentIndex < _colors.length - 1) {
        _currentIndex++;
        _highlightedIndex = 0; // Reset highlighted index when changing the color
        _highlightLastWord = false; // Reset highlight flag
        _startHighlighting(); // Restart highlighting for the new sentence
        _disableButton(); // Disable button and change color
      } else {
        // Navigate to another page
        Navigator.pop(context);
      }
    });
  });
}


Widget _buildColorBox(int index, String image) {
  final isWhichQuestion = _texts[_currentIndex].startsWith('WHICH');
  final isWhatQuestion = _texts[_currentIndex].startsWith('WHAT');
  final bool isCorrectAnswer = index == _answers[_currentIndex];
  double targetOpacity = _selectedAnswerIndex == -1 ? 1.0 : (_buttonDisabled ? 1.0 : (isCorrectAnswer ? 1.0 : 0.5)); // Adjusted to consider button state

  if (isWhichQuestion || isWhatQuestion) {
    return InkWell(
      onTap: () {
        targetOpacity = isCorrectAnswer ? 1.0 : 0.5;
        if (index == _answers[_currentIndex]) {
          setState(() {
            _selectedAnswerIndex = index;
            _buttonColor = const Color.fromARGB(255, 123, 28, 255);
             HapticFeedback.mediumImpact();
             // Update targetOpacity when a new answer is selected
            _buttonDisabled = false;
          });
        }else{
           HapticFeedback.vibrate();
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: targetOpacity,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          width: 160,
          height: isWhichQuestion? 210:135,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isWhichQuestion ? 10 : 10),
            color: const Color.fromARGB(75, 191, 191, 191),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isWhichQuestion)
                Image.asset(
                  image,
                  width: 115,
                  height: 115,
                ),
              if (isWhatQuestion)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: highlight[index].withOpacity(0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    Labels[index],
                    style: header2,
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  } else {
    return Container();
  }
}



  int getRandomIndex(List<String> imageList) {
    return Random().nextInt(imageList.length);
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
                        width: MediaQuery.of(context).size.width * 0.8 *
                            (_currentIndex / 10), // 10 indices
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
            Center(
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
                                  ? _colors[_currentIndex % _colors.length]
                                      .withOpacity(0.5)
                                  : _highlightedIndex == index
                                      ? _colors[_currentIndex % _colors.length]
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
            SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentIndex < _texts.length)
                    _buildConditionalWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorBox(0, _redImages[redIndex]),
                      _buildColorBox(1, _blueImages[blueIndex]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorBox(2, _yellowImages[yellowIndex]),
                      _buildColorBox(3, _greenImages[greenIndex]),
                    ],
                  ),
                  //const SizedBox(height: isWhatQuestion? 20: 0), // Added spacing
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50,top: 10),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 750),
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
          ],
        ),
      ),
    );
  }

  Widget _buildConditionalWidget() {
    final isWhichQuestion = _texts[_currentIndex].startsWith('WHICH');
    final isWhatQuestion = _texts[_currentIndex].startsWith('WHAT');

    if (isWhichQuestion) {
      return Container(
        //  margin: const EdgeInsets.symmetric(vertical: 20),
        width: 0,
        height: 0,
        decoration: BoxDecoration(
          color: _colors[_currentIndex],
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else if (isWhatQuestion) {
      final adjustedIndex = _currentIndex ~/ 2; // Use adjusted index for alternating images
      final imageIndex = adjustedIndex % _questionImages.length;
      return Container(
        height: 150,
        width: 150,
        child: Image.asset(_questionImages[imageIndex]),
        padding: EdgeInsets.only(bottom: 20),

      );
    } else {
      return Container();
    }
  }

}
