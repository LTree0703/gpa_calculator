import 'package:flutter/material.dart';
import 'package:uni_quitter/gpa.dart';
import 'package:uni_quitter/grade.dart';

void main() {
  runApp(const LaunchApp());
}

class LaunchApp extends StatelessWidget {
  const LaunchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uni Quitter',
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'JetBrainsMono',
        colorScheme: const ColorScheme(
            background: Colors.black12,
            onBackground: Colors.white,
            brightness: Brightness.dark,
            primary: Colors.cyan,
            onPrimary: Colors.white,
            secondary: Colors.blueGrey,
            onSecondary: Colors.white,
            error: Colors.redAccent,
            onError: Colors.white,
            surface: Colors.grey,
            onSurface: Colors.white),
      ),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF123262),
        fontFamily: 'JetBrainsMono',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 18, 50, 98),
                Color.fromARGB(150, 18, 50, 98),
                Color.fromARGB(120, 18, 50, 98),
                Color.fromARGB(190, 18, 50, 98),
                Color.fromARGB(220, 18, 50, 98),
                Color.fromARGB(255, 18, 50, 98),
              ]),
        ),
        child: Column(
          children: [
            const Flexible(child: SizedBox(height: 230)),
            const Text(
              'Uni\nQuitter',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                // decoration: TextDecoration.lineThrough,
                fontSize: 64,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: const Text(
                '\'People go through three stages: birth, get an F, perish.\' (a random uni fm, 2023)',
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),
            const Flexible(child: SizedBox(height: 177)),
            FilledButton.tonal(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xff3F5B85)),
                fixedSize: MaterialStatePropertyAll(Size(307, 76)),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(_transitionRoute(const GPACalculator()));
              },
              // <a href="https://www.flaticon.com/free-icons/education" title="education icons">Education icons created by Freepik - Flaticon</a>
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 26, 20, 26),
                    child: Image.asset('assets/gpa.png',
                        color: Colors.white, width: 24, height: 24),
                  ),
                  const Flexible(
                    child: Text(
                      'GPA Calculator',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Flexible(child: SizedBox(height: 42)),
            FilledButton.tonal(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xff3F5B85)),
                fixedSize: MaterialStatePropertyAll(Size(307, 76)),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(_transitionRoute(const GradeCalculator()));
              },
              // <a href="https://www.flaticon.com/free-icons/grade" title="grade icons">Grade icons created by Freepik - Flaticon</a>
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 26, 20, 26),
                    child: Image.asset('assets/grade.png',
                        color: Colors.white, width: 24, height: 24),
                  ),
                  const Flexible(
                    child: Text(
                      'Grade Calculator',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 42),
            // <a href="https://www.flaticon.com/free-icons/settings" title="settings icons">Settings icons created by Freepik - Flaticon</a>
            // <a href="https://www.flaticon.com/free-icons/about" title="about icons">About icons created by Tempo_doloe - Flaticon</a>
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xff3F5B85)),
                      shape: MaterialStatePropertyAll(CircleBorder(
                          side: BorderSide(style: BorderStyle.none))),
                      fixedSize: MaterialStatePropertyAll(Size(30, 30))),
                  onPressed: () {},
                  child: Image.asset('assets/setting.png',
                      color: Colors.white, width: 24, height: 24),
                ),
                const SizedBox(width: 52),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xff3F5B85)),
                      shape: MaterialStatePropertyAll(CircleBorder(
                          side: BorderSide(style: BorderStyle.none))),
                      fixedSize: MaterialStatePropertyAll(Size(30, 30))),
                  onPressed: () {},
                  child: Image.asset('assets/info.png',
                      color: Colors.white, width: 24, height: 24),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Route _transitionRoute(route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      var curve = const Cubic(0.20, 1.25, 1, 1);
      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
