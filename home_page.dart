import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle name = GoogleFonts.dosis(
  color: const Color.fromARGB(255, 106, 0, 255),
  fontSize: 32,
  fontWeight: FontWeight.bold,
);
TextStyle headers = GoogleFonts.dosis(
  color: const Color.fromARGB(255, 106, 0, 255),
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
TextStyle normal = GoogleFonts.jetBrainsMono(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontSize: 15,
  fontWeight: FontWeight.normal,
);
TextStyle small = GoogleFonts.jetBrainsMono(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontSize: 11,
  fontWeight: FontWeight.normal,
);
TextStyle header2 = GoogleFonts.dosis(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

final List<String> _imagePaths = [
  'assets/Homepage/book.png',
  'assets/Homepage/example.png',
  'assets/Homepage/pencils.png',
  'assets/Homepage/puzzle.png',
  'assets/Homepage/icon.png',
];
 final List<String> routes = [
    '/lesson',
    '/examples',
    '/drawing',
    '/quiz',
    '/profile',
  ];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

 Widget _buildColorBox(BuildContext context, int index) {
  List<String> nextItems = [
    'Lesson',
    'Examples',
    'Drawing',
    'Quiz',
  ];
  List<String> nextExp = [
    'Simple Introduction',
    'Real World Examples',
    'Simple Drawing Game',
    'Testing Understanding',
  ];


  return InkWell(
    onTap: () {
      HapticFeedback.mediumImpact();
      Navigator.pushNamed(context, routes[index]);
    },
    borderRadius: BorderRadius.circular(8),
    child: Container(
      margin: const EdgeInsets.all(8),
      width: 170,
      height: 230,
      decoration: BoxDecoration(
        color: const Color.fromARGB(75, 191, 191, 191),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.9,
            child: Image(
              width: 100,
              height: 100,
              image: AssetImage(_imagePaths[index]),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            nextItems[index],
            style: header2,
          ),
          const SizedBox(height: 10),
          Text(
            nextExp[index],
            style: small,
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 245, 255),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0), // Add left padding
                        child: Text(
                          "Welcome,",
                          style: normal,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0), // Add left padding
                        child: Text(
                          "TESTING!",
                          style: name,
                        ),
                      ),
                    ],
                  ),
                ),
                // Circle Widget with right padding
Padding(
  padding: const EdgeInsets.only(right: 16.0),
  child: Center(
    child: InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.pushNamed(context, routes[4]);
      },
      child: Container(
        width: 63,
        height: 63,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 106, 0, 255),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Image.asset(
          'assets/Homepage/icon.png',
          fit: BoxFit.cover,
        ),
      ),
    ),
  ),
),

              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 25), // Adjusted vertical margin
              padding: const EdgeInsets.symmetric(vertical: 17.5, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(75, 191, 191, 191),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("COLORS:", style: headers),
                      Text("100%", style: headers),
                    ],
                  ),
                  const SizedBox(height: 8), // Add space between the title/percentage and progress bar
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(8, 49, 49, 49),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOut,
                        width: MediaQuery.of(context).size.width * 0.9 * (4 / 4),
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 106, 0, 255),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorBox(context, 0),
                      _buildColorBox(context, 1),
                    ],
                  ),
                  const SizedBox(height: 10), // Add some vertical spacing between the rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorBox(context, 2),
                      _buildColorBox(context, 3),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
