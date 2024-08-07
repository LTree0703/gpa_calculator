import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_quitter/gpa.dart';
import 'package:uni_quitter/grade.dart';
import 'package:uni_quitter/overlay.dart';

void main() {
  runApp(const LaunchApp());
}

class LaunchApp extends StatelessWidget {
  const LaunchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uni Quitter',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF123262),
        fontFamily: 'JetBrainsMono',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
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
              'Pass 3\nExceed 4',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 64,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: const Text(
                'academic planner\nat your fingertip😈',
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),
            const Flexible(child: SizedBox(height: 177)),
            FilledButton.tonal(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xff3F5B85)),
                fixedSize: WidgetStatePropertyAll(Size(307, 76)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: ((context) => const GPACalculator())));
              },
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
                backgroundColor: WidgetStatePropertyAll(Color(0xff3F5B85)),
                fixedSize: WidgetStatePropertyAll(Size(307, 76)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: ((context) => const GradeCalculator())));
              },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Color(0xff3F5B85)),
                    shape: WidgetStatePropertyAll(CircleBorder(
                        side: BorderSide(style: BorderStyle.none))),
                    fixedSize: WidgetStatePropertyAll(Size(30, 30)),
                  ),
                  onPressed: () => _openOverlay(
                      context,
                      const OverlayPage(
                        title: 'Settings',
                        child: SettingsPage(),
                      )),
                  child: Image.asset('assets/setting.png',
                      color: Colors.white, width: 24, height: 24),
                ),
                const SizedBox(width: 52),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xff3F5B85)),
                      shape: WidgetStatePropertyAll(CircleBorder(
                          side: BorderSide(style: BorderStyle.none))),
                      fixedSize: WidgetStatePropertyAll(Size(30, 30))),
                  onPressed: () => _openOverlay(
                      context,
                      const OverlayPage(
                        title: 'About',
                        child: InfoPage(),
                      )),
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

  Future<Object?> _openOverlay(BuildContext context, Widget route) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var curve = const Cubic(0.20, 0.75, 0.75, 1.0);
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
