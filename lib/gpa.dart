import 'package:flutter/material.dart';
import 'package:uni_quitter/topbar.dart';

class GPAData {
  double? cumulativeGPA;
  double? creditsObtained;
  int numCourses = 6;
  List<String>? courseName;
  List<double> credits = [];
  List<double> grades = [];
  double semesterGPA = 0.0;
  double newcGPA = 0.0;

  double get semGPA {
    double totalGrades = 0.0, totalCredits = 0.0;
    for (int i = 0; i < credits.length; i++) {
      totalGrades += grades[i] * credits[i];
      totalCredits += credits[i];
    }
    return totalGrades / totalCredits;
  }

  double get cGPA {
    if (cumulativeGPA == null || creditsObtained == null) {
      return semGPA;
    }

    double semTotalCredits = 0.0;
    for (int i = 0; i < credits.length; i++) {
      semTotalCredits += credits[i];
    }

    return (cumulativeGPA! * creditsObtained! + semGPA * semTotalCredits) /
        (creditsObtained! + semTotalCredits);
  }
}

class GPACalculator extends StatefulWidget {
  const GPACalculator({super.key});

  @override
  State<GPACalculator> createState() => _GPACalculatorState();
}

class _GPACalculatorState extends State<GPACalculator> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  final GPAData _data = GPAData();
  bool hasSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(130.0),
        child: TopBar(title: 'GPA Calculator'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FirstFormInput(
                    // Cumulative GPA
                    formKey: _formKey1,
                    labelText: 'Cumulative GPA',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _data.cumulativeGPA = null;
                        return null;
                      }
                      try {
                        _data.cumulativeGPA = double.parse(value);
                      } catch (e) {
                        return 'Invalid input';
                      }
                      return null;
                    },
                  ),
                  FirstFormInput(
                    // Credits Obtained
                    formKey: _formKey2,
                    labelText: 'Credits already obtained',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _data.creditsObtained = null;
                        return null;
                      }
                      try {
                        _data.creditsObtained = double.parse(value);
                      } catch (e) {
                        return 'Invalid input';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9.5),
                          child: Form(
                            key: _formKey3,
                            child: TextFormField(
                              key: UniqueKey(),
                              keyboardType: TextInputType.number,
                              initialValue: _data.numCourses.toString(),
                              style: const TextStyle(fontSize: 16.0),
                              decoration: const InputDecoration(
                                labelText: '*Number of courses taken',
                                labelStyle: TextStyle(fontSize: 16.0),
                                errorStyle: TextStyle(height: 0.5),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  _data.numCourses = 0;
                                  return 'Required field';
                                }
                                try {
                                  setState(() {
                                    _data.numCourses = int.parse(value);
                                  });
                                } catch (e) {
                                  return 'Invalid input';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formKey3.currentState?.validate();
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color(0xffBBBBEB)),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)))),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_data.numCourses > 1) {
                                          _data.numCourses--;
                                        }
                                      });
                                    },
                                    child: const Text('-',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color(0xff123252)),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _data.numCourses++;
                                      });
                                    },
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
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        children: [
                          Expanded(child: Center(child: Text('Course Name'))),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: Center(child: Text('*Credit'))),
                                Expanded(child: Center(child: Text('*Grade'))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SecondFormInput(formKey: _formKey4, data: _data),
                  OutputTable(
                    hasSubmitted: hasSubmitted,
                    data: _data,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xffBBBBEB)),
                minimumSize: MaterialStatePropertyAll(Size(135, 51)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    side: BorderSide(style: BorderStyle.solid),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration.zero,
                    pageBuilder: (_, __, ___) => widget,
                  ),
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFF123262)),
                minimumSize: MaterialStatePropertyAll(Size(135, 51)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    side: BorderSide(style: BorderStyle.solid),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  if (_formKey4.currentState!.validate()) {
                    hasSubmitted = true;
                  }
                });
              },
              child: const Text(
                'Calculate',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FirstFormInput extends StatefulWidget {
  const FirstFormInput(
      {super.key,
      required this.formKey,
      this.labelText,
      required this.validator});

  final GlobalKey<FormState> formKey;
  final String? labelText;
  final Function(String? value) validator;

  @override
  State<FirstFormInput> createState() => _FirstFormInputState();
}

class _FirstFormInputState extends State<FirstFormInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.5),
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 16.0),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(fontSize: 16.0),
            errorStyle: const TextStyle(height: 0.5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
          ),
          validator: (value) => widget.validator(value),
          onChanged: (value) {
            widget.formKey.currentState?.validate();
          },
        ),
      ),
    );
  }
}

class SecondFormInput extends StatefulWidget {
  const SecondFormInput({super.key, required this.formKey, required this.data});
  final GlobalKey<FormState> formKey;
  final GPAData data;

  @override
  State<SecondFormInput> createState() => _SecondFormInputState();
}

class _SecondFormInputState extends State<SecondFormInput> {
  static const Map<String, double?> gradelabel = {
    'A+': 4.30,
    'A': 4.00,
    'A-': 3.70,
    'B+': 3.30,
    'B': 3.00,
    'B-': 2.70,
    'C+': 2.30,
    'C': 2.00,
    'C-': 1.70,
    'D+': 1.30,
    'D': 1.00,
    'F': 0.00,
  };
  final List<double> _creditValues = [];
  final List<double> _dropdownValues = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var i = 0; i < widget.data.numCourses; i++) {
      _dropdownValues.add(4.30);
      _creditValues.add(0);
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 16.0),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      // Credit
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                        child: TextFormField(
                          initialValue: _creditValues[i].truncate().toString(),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: const TextStyle(fontSize: 16.0),
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            errorStyle: TextStyle(height: 0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            try {
                              _creditValues[i] = double.parse(value);
                              widget.data.credits = _creditValues;
                            } catch (e) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      // Grades
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffCCCCCC)),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Center(
                          child: DropdownButton(
                            underline: Container(), // disable underline
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            value: _dropdownValues[i],
                            items: gradelabel
                                .map((letter, value) {
                                  return MapEntry(
                                    letter,
                                    DropdownMenuItem(
                                      value: value,
                                      child: Text(letter),
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _dropdownValues[i] = value;
                                widget.data.grades = _dropdownValues;
                              });
                            },
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
    return Form(key: widget.formKey, child: Column(children: children));
  }
}

class OutputTable extends StatefulWidget {
  const OutputTable(
      {super.key, required this.hasSubmitted, required this.data});

  final bool hasSubmitted;
  final GPAData data;

  @override
  State<OutputTable> createState() => _OutputTableState();
}

class _OutputTableState extends State<OutputTable> {
  @override
  Widget build(BuildContext context) {
    if (!widget.hasSubmitted) {
      return const SizedBox(
        height: 100,
      );
    }
    return const SizedBox(
      height: 100,
      child: Text('legit'),
    );
  }
}
