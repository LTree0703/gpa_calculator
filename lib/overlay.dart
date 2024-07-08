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
  int defaultAssignments = 5;
  void loadPage() async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    setState(() {
      defaultCourses = config.defaultCourses;
      defaultAssignments = config.defaultAssignments;
    });
  }

  @override
  void initState() {
    loadPage();
    super.initState();
  }

  void courseMinusByOne() async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    if (defaultCourses - 1 > 0) {
      config.alter('defaultCourses', defaultCourses - 1);
      setState(() {
        defaultCourses--;
      });
    }
  }

  void courseAddByOne() async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    config.alter('defaultCourses', defaultCourses + 1);
    setState(() {
      defaultCourses++;
    });
  }

  void asmMinusByOne() async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    if (defaultAssignments - 1 > 0) {
      config.alter('defaultAssignments', defaultAssignments - 1);
      setState(() {
        defaultAssignments--;
      });
    }
  }

  void asmAddByOne() async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    config.alter('defaultAssignments', defaultAssignments + 1);
    setState(() {
      defaultAssignments++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Padding(
            // Course
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text('Default number of courses (GPA)'),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                elevation: WidgetStatePropertyAll(0),
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xffAAAADA)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            bottomLeft:
                                                Radius.circular(20.0)))),
                              ),
                              onPressed: () => courseMinusByOne(),
                              child: const Text('-',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blueGrey),
                              shape: WidgetStatePropertyAll(
                                  BeveledRectangleBorder())),
                          onPressed: null,
                          child: Text(defaultCourses.toString()),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                elevation: WidgetStatePropertyAll(0),
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xff345374)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.0),
                                            bottomRight:
                                                Radius.circular(20.0)))),
                              ),
                              onPressed: () => courseAddByOne(),
                              child: const Text('+',
                                  style: TextStyle(fontSize: 20)),
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
          Padding(
            // ASM
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text('Default number of assignments'),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                elevation: WidgetStatePropertyAll(0),
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xffAAAADA)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            bottomLeft:
                                                Radius.circular(20.0)))),
                              ),
                              onPressed: () => asmMinusByOne(),
                              child: const Text('-',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blueGrey),
                              shape: WidgetStatePropertyAll(
                                  BeveledRectangleBorder())),
                          onPressed: null,
                          child: Text(defaultAssignments.toString()),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                elevation: WidgetStatePropertyAll(0),
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xff345374)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.0),
                                            bottomRight:
                                                Radius.circular(20.0)))),
                              ),
                              onPressed: () => asmAddByOne(),
                              child: const Text('+',
                                  style: TextStyle(fontSize: 20)),
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
        ],
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  final String text = 'This app is created by Livear Pang';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(child: Text(text)),
        ),
      ],
    );
  }
}
