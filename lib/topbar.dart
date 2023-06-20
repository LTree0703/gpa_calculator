import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title;
  final appBarHeight = 200.0;

  const TopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 18, 50, 98),
              Color.fromARGB(185, 18, 50, 98),
              Color.fromARGB(0, 18, 50, 98),
            ],
          ),
        ),
        child: AppBar(
          elevation: 0,
          toolbarHeight: appBarHeight - 50,
          leadingWidth: 75,
          backgroundColor: const Color.fromARGB(0, 18, 50, 98),
          title: Text(title),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 30),
            child: ElevatedButton(
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(CircleBorder()),
                backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                shadowColor: MaterialStatePropertyAll(Colors.transparent),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '<',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
