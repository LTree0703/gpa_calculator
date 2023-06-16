import 'package:flutter/material.dart';
import 'package:gpa_calculator/topbar.dart';

class GPACalculator extends StatefulWidget {
  const GPACalculator({super.key});

  @override
  State<GPACalculator> createState() => _GPACalculatorState();
}

class _GPACalculatorState extends State<GPACalculator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: TopBar(title: 'GPA Calculator'),
      ),
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
          builder: (context, scrollController) => const GPAForm(),
        ),
      ),
    );
  }
}

class GPAForm extends StatefulWidget {
  const GPAForm({super.key});

  @override
  State<GPAForm> createState() => _GPAFormState();
}

class _GPAFormState extends State<GPAForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    // TODO: complete the gpa form
  }
}
