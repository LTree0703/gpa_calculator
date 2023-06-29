import 'package:flutter/material.dart';
import 'package:uni_quitter/topbar.dart';

class GPAData {
  double? cumulativeGPA;
  double? creditsObtained;
  int numCourses = 6;
  List<String> courseName = [];
  List<double> credits = [];
  List<double> grades = [];

  double get totalGrades {
    double totalGrades = 0.0;
    for (int i = 0; i < grades.length; i++) {
      totalGrades += grades[i] * credits[i];
    }
    return totalGrades;
  }

  double get totalCredits {
    double totalCredits = 0.0;
    for (int i = 0; i < credits.length; i++) {
      totalCredits += credits[i];
    }
    return totalCredits;
  }

  double get semGPA {
    return (totalGrades / totalCredits);
  }

  double get cGPA {
    if (cumulativeGPA == null || creditsObtained == null) {
      return semGPA;
    }
    return (cumulativeGPA! * creditsObtained! + semGPA * totalCredits) /
        (creditsObtained! + totalCredits);
  }

  GPAData() {
    for (int i = 0; i < numCourses; i++) {
      addEmptyCourse();
    }
  }

  void addEmptyCourse() {
    courseName.add('');
    credits.add(0.0);
    grades.add(4.3);
  }

  void deleteCourse() {
    courseName.removeLast();
    credits.removeLast();
    grades.removeLast();
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

  late ScrollController _controller;

  GPAData _data = GPAData();
  bool hasSubmitted = false;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scroll(double offset) {
    _controller.animateTo(offset,
        duration: const Duration(seconds: 1),
        curve: Curves.fastEaseInToSlowEaseOut);
  }

  void _reset() {
    _formKey1.currentState?.reset();
    _formKey2.currentState?.reset();
    _formKey3.currentState?.reset();
    _formKey4.currentState?.reset();
    setState(() {
      _data = GPAData();
      hasSubmitted = false;
    });
  }

  bool _callCalculation() {
    if (_formKey4.currentState!.validate()) {
      setState(() {
        hasSubmitted = true;
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(130.0),
        child: TopBar(title: 'GPA Calculator'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          controller: _controller,
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
                                setState(() {
                                  hasSubmitted = false;
                                });
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
                                          hasSubmitted = false;
                                          _data.numCourses--;
                                          _data.deleteCourse();
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
                                        hasSubmitted = false;
                                        _data.numCourses++;
                                        _data.addEmptyCourse();
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
                  Form(
                    key: _formKey4,
                    child: Builder(
                      // key: UniqueKey(),
                      builder: (context) {
                        List<Widget> children = [];
                        for (var id = 0; id < _data.numCourses; id++) {
                          children.add(
                            SecondFormInput(
                              id: id,
                              formKey: _formKey4,
                              courseNameOnChange: (value) {
                                if (value == null || value.isEmpty) {
                                  _data.courseName[id] = '';
                                  return;
                                }
                                _data.courseName[id] = value;
                              },
                              creditValues: _data.credits,
                              creditInputValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                try {
                                  _data.credits[id] = double.parse(value);
                                } catch (e) {
                                  return '';
                                }
                                return null;
                              },
                              gradeValues: _data.grades,
                              gradeInputOnChange: (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  hasSubmitted = false;
                                  _data.grades[id] = value;
                                });
                              },
                            ),
                          );
                        }
                        return Column(children: children);
                      },
                    ),
                  ),
                  const Divider(
                    height: 100.0,
                  ),
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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
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
                FocusManager.instance.primaryFocus?.unfocus();
                _reset();
                _scroll(_controller.initialScrollOffset);
              },
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 50),
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
                if (_callCalculation()) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _scroll(_controller.position.maxScrollExtent));
                  FocusManager.instance.primaryFocus?.unfocus();
                }
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
  const SecondFormInput(
      {super.key,
      required this.id,
      required this.formKey,
      required this.courseNameOnChange,
      required this.creditValues,
      required this.creditInputValidator,
      required this.gradeValues,
      required this.gradeInputOnChange});

  final int id;
  final GlobalKey<FormState> formKey;
  final void Function(String?) courseNameOnChange;
  final List<double> creditValues;
  final String? Function(String?) creditInputValidator;
  final List<double> gradeValues;
  final void Function(double?) gradeInputOnChange;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            // Course Name
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextFormField(
                maxLines: 1,
                style: const TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  hintText: 'Course ${widget.id + 1}',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
                onChanged: widget.courseNameOnChange,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  // Credit
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 16.0),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        errorStyle: TextStyle(height: 0),
                      ),
                      validator: widget.creditInputValidator,
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
                        value: widget.gradeValues[widget.id],
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
                        onChanged: widget.gradeInputOnChange,
                      ),
                    ),
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

class OutputTable extends StatefulWidget {
  const OutputTable(
      {super.key, required this.hasSubmitted, required this.data});

  final bool hasSubmitted;
  final GPAData data;

  @override
  State<OutputTable> createState() => _OutputTableState();
}

class _OutputTableState extends State<OutputTable> {
  List<TableRow> courseData() {
    List<TableRow> children = [];
    for (var id = 0; id < widget.data.numCourses; id++) {
      children.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(7.5),
          child: Text(widget.data.courseName[id] == ''
              ? 'Course ${id + 1}'
              : widget.data.courseName[id]),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: const EdgeInsets.all(7.5),
              child: Text(
                widget.data.credits[id].toString(),
              )),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(7.5),
            child: Text(widget.data.grades[id].toString()),
          ),
        ),
      ]));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasSubmitted) {
      return const SizedBox(
        height: 100,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 350.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid, color: const Color(0xff888888)),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
              child: Text('RESULT',
                  style: TextStyle(
                    fontSize: 24.0,
                  )),
            ),
            Table(
              border: TableBorder.all(
                  style: BorderStyle.solid, color: const Color(0xff888888)),
              children: courseData(),
            ),
            Table(
              children: [
                TableRow(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
                      child: Text('Semester GPA'),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7.5, vertical: 5.0),
                      child: Text(widget.data.semGPA.toStringAsFixed(3)),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.5),
                      child: Text('Cumulative GPA'),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7.5),
                      child: Text(widget.data.cGPA.toStringAsFixed(3)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            )
          ],
        ),
      ),
    );
  }
}
