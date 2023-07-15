import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_quitter/backend/settings.dart';

class OverlayPage extends StatefulWidget {
  const OverlayPage({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  State<OverlayPage> createState() => _OverlayPageState();
}

class _OverlayPageState extends State<OverlayPage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.15,
        child: Material(
          color: const Color(0xff4F6B96),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                  ),
                ),
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int defaultCourses = 6;
  void loadPage() async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    setState(() {
      defaultCourses = config.defaultCourses;
    });
  }

  @override
  void initState() {
    loadPage();
    super.initState();
  }

  void minusByOne(int target) async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    config.alter('defaultCourses', target - 1);
    setState(() {
      target--;
    });
  }

  void addByOne(int target) async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    config.alter('defaultCourses', defaultCourses + 1);
    setState(() {
      defaultCourses++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text('Default number of courses (GPA)'),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => addByOne(defaultCourses),
                  child: Text(defaultCourses.toString()),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [],
    );
  }
}