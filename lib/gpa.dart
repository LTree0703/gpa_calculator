import 'package:flutter/material.dart';
import 'package:uni_quitter/backend/settings.dart';
import 'package:uni_quitter/topbar.dart';
import 'package:uni_quitter/formfield.dart';
import 'package:uni_quitter/backend/gpadata.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool numCourseInputHasChanged = false;

  void loadPage() async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    alterNumCourseValue(config.defaultCourses, false);
  }

  void alterNumCourseValue(int newValue, bool changedFromTextFormField) {
    int diff = newValue - _data.numCourses;
    bool? hasIncreased = diff > 0 ? true : false;
    setState(() {
      for (int i = 0; i < diff.abs(); i++) {
        hasIncreased ? _data.addEmptyCourse() : _data.deleteCourse();
      }
      _data.numCourses = newValue;
      numCourseInputHasChanged = changedFromTextFormField;
    });
  }

  @override
  void initState() {
    loadPage();
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

  void _closeKeyboard() => FocusManager.instance.primaryFocus!.unfocus();

  void _reset() {
    _formKey1.currentState?.reset();
    _formKey2.currentState?.reset();
    _formKey3.currentState?.reset();
    _formKey4.currentState?.reset();

    _closeKeyboard();
    _scroll(_controller.initialScrollOffset);

    setState(() {
      _data = GPAData();
      hasSubmitted = false;
    });
  }

  bool _callCalculation() {
    if (_formKey1.currentState!.validate() &&
        _formKey2.currentState!.validate() &&
        _formKey4.currentState!.validate() &&
        (_data.cumulativeGPA == null && _data.creditsObtained == null ||
            _data.cumulativeGPA != null && _data.creditsObtained != null)) {
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
        onTap: () => _closeKeyboard(),
        child: ListView(
          controller: _controller,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SimpleTextForm(
                    formKey: _formKey1,
                    labelText: 'Cumulative GPA',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _data.cumulativeGPA = null;
                        return null;
                      }
                      try {
                        var tmp = double.parse(value);
                        if (tmp > 4.3) {
                          return 'cGPA shouldn\'t be greater than 4.3';
                        }
                        _data.cumulativeGPA = double.parse(value);
                      } catch (e) {
                        return 'Invalid input';
                      }
                      return null;
                    },
                  ),
                  SimpleTextForm(
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
                              autofocus: numCourseInputHasChanged,
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
                                  return 'Required field';
                                }
                                try {
                                  int.parse(value);
                                } catch (e) {
                                  return 'Invalid input';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (_formKey3.currentState!.validate()) {
                                  alterNumCourseValue(int.parse(value), true);
                                }
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
                                          numCourseInputHasChanged = false;
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
                                        numCourseInputHasChanged = false;
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
                            CourseFormInput(
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
            child: FormButton(
              backgroundColor: const Color(0xffBBBBEB),
              onPressed: () => _reset(),
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 50),
            child: FormButton(
              backgroundColor: const Color(0xFF123262),
              onPressed: () {
                if (_callCalculation()) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _scroll(_controller.position.maxScrollExtent));
                  _closeKeyboard();
                } else {
                  _scroll(_controller.initialScrollOffset);
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

class CourseFormInput extends StatefulWidget {
  const CourseFormInput(
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
  State<CourseFormInput> createState() => _CourseFormInputState();
}

class _CourseFormInputState extends State<CourseFormInput> {
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
      children.add(
        TableRow(
          children: [
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
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(7.5),
                child: Text(widget.data.grades[id].toString()),
              ),
            ),
          ],
        ),
      );
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
      padding: const EdgeInsets.only(bottom: 150.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 7.5),
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
