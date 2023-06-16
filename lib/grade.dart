import 'package:flutter/material.dart';
import 'package:gpa_calculator/topbar.dart';

class GradeCalculator extends StatefulWidget {
  const GradeCalculator({super.key});

  @override
  State<GradeCalculator> createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends State<GradeCalculator> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: PreferredSize(
      preferredSize: Size.fromHeight(200.0),
      child: TopBar(
        title: 'Grade Calculator',
      ),
    ));
  }
}
