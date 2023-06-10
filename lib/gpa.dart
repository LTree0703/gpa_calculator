import 'package:flutter/material.dart';

class GPAForm extends StatefulWidget {
  const GPAForm({super.key});

  @override
  State<GPAForm> createState() => _GPAFormState();
}

class _GPAFormState extends State<GPAForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  int courseNum = 0;
  Map<int, List<dynamic>> courses = {};

  double getGPA(List<double> credits, List<double> grades) {
    double gradeTotal = 0.0, creditTotal = 0.0;
    for (int i = 0; i < credits.length; i++) {
      gradeTotal += grades[i] * credits[i];
      creditTotal += credits[i];
    }
    return (gradeTotal / creditTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            '\nHello, world',
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.start,
          ),
          const Course(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));
                    //getGPA(credits, grades);
                  }
                },
                child: const Text('Evaluate'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum Grades { ap, a, am, bp, b, bm, cp, c, cm, dp, d, dm, f, p, np }

class Course extends StatelessWidget {
  // final String? courseName;
  // final double credit;
  // final double grade;
  const Course({
    super.key,
    /*this.courseName, required this.credit, required this.grade*/
  });

  String? inputValiation(String? value) {
    if (value == null || value.isEmpty) {
      return 'This block cannot be empty.';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid value.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                hintText: 'Course Name',
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: 'Credit',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: 'Grade',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
