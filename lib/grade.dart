import 'package:flutter/material.dart';
import 'package:uni_quitter/topbar.dart';
import 'package:uni_quitter/formfield.dart';
import 'package:uni_quitter/backend/gradedata.dart';
import 'package:uni_quitter/backend/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradeCalculator extends StatefulWidget {
  const GradeCalculator({super.key});

  @override
  State<GradeCalculator> createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends State<GradeCalculator> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  late ScrollController _controller;

  GradeData _data = GradeData();
  bool hasSubmitted = false;
  bool numAssignmentInputHasChanged = false;

  void loadPage() async {
    UserConfig config = UserConfig(await SharedPreferences.getInstance());
    alterNumAssignmentValue(config.defaultAssignments, false);
  }

  void alterNumAssignmentValue(int newValue, bool changedFromTextFormField) {
    int diff = newValue - _data.numAssignments;
    bool? hasIncreased = diff > 0 ? true : false;
    setState(() {
      for (int i = 0; i < diff.abs(); i++) {
        hasIncreased ? _data.addEmptyCourse() : _data.deleteCourse();
      }
      _data.numAssignments = newValue;
      numAssignmentInputHasChanged = changedFromTextFormField;
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
      _data = GradeData();
      hasSubmitted = false;
      numAssignmentInputHasChanged = false;
    });
  }

  bool _callCalculation() {
    if (_formKey4.currentState!.validate()) {
      setState(() {
        hasSubmitted = true;
        numAssignmentInputHasChanged = false;
      });
      return true;
    }
    return false;
  }

  bool gradeProcessSucessful(String? value, int id) {
    if (value == null || value.isEmpty) {
      return false;
    }
    value = value.toUpperCase();
    // Label case
    if (gradelabel[value] != null) {
      _data.componentGradesInput[id] = value;
      _data.componentGrades[id] = gradelabel[value]!;
      return true;
    }
    // Percentage case
    double score;
    try {
      score = double.parse(value);
    } catch (e) {
      return false;
    }
    if (score < 0) {
      return false;
    } else if (score >= 100) {
      _data.componentGradesInput[id] = value;
      _data.componentGrades[id] = 4.3;
      return true;
    }
    for (double key in percentagelabel.keys) {
      if (score < key) {
        _data.componentGradesInput[id] = value.toString();
        _data.componentGrades[id] = percentagelabel[key]!;
        break;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(130.0),
        child: TopBar(title: 'Grade Calculator'),
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
                              autofocus: numAssignmentInputHasChanged,
                              keyboardType: TextInputType.number,
                              initialValue: _data.numAssignments.toString(),
                              style: const TextStyle(fontSize: 16.0),
                              decoration: const InputDecoration(
                                labelText: '*Number of Assignments',
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
                                  alterNumAssignmentValue(
                                      int.parse(value), true);
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
                                      elevation: WidgetStatePropertyAll(0),
                                      backgroundColor: WidgetStatePropertyAll(
                                          Color(0xffBBBBEB)),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_data.numAssignments > 1) {
                                          hasSubmitted = false;
                                          numAssignmentInputHasChanged = false;
                                          _data.numAssignments--;
                                          _data.deleteCourse();
                                        }
                                      });
                                    },
                                    child: const Text(
                                      '-',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
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
                                      elevation: WidgetStatePropertyAll(0),
                                      backgroundColor: WidgetStatePropertyAll(
                                          Color(0xff123252)),
                                      shape: WidgetStatePropertyAll(
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
                                        numAssignmentInputHasChanged = false;
                                        _data.numAssignments++;
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
                          Expanded(child: Center(child: Text('Assignment'))),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: Center(child: Text('*Grade'))),
                                Expanded(child: Center(child: Text('*Weight'))),
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
                      builder: (context) {
                        List<Widget> children = [];
                        for (var id = 0; id < _data.numAssignments; id++) {
                          children.add(
                            CourseFormInput(
                              id: id,
                              formKey: _formKey4,
                              assignmentInputOnChanged: (value) {
                                if (value == null || value.isEmpty) {
                                  _data.assignments[id] = '';
                                  return;
                                }
                                _data.assignments[id] = value;
                              },
                              gradeValues: _data.componentGrades,
                              gradeInputValidator: (value) {
                                if (gradeProcessSucessful(value, id)) {
                                  return null;
                                }
                                return '';
                              },
                              weightValues: _data.weights,
                              weightInputValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                try {
                                  _data.weights[id] = double.parse(value);
                                } catch (e) {
                                  return '';
                                }
                                return null;
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
      required this.assignmentInputOnChanged,
      required this.gradeValues,
      required this.gradeInputValidator,
      required this.weightValues,
      required this.weightInputValidator});

  final int id;
  final GlobalKey<FormState> formKey;
  final void Function(String?) assignmentInputOnChanged;
  final List<double> gradeValues;
  final String? Function(String?) gradeInputValidator;
  final List<double> weightValues;
  final String? Function(String?) weightInputValidator;

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
            // Assignment
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextFormField(
                maxLines: 1,
                style: const TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  hintText: 'Task ${widget.id + 1}',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
                onChanged: widget.assignmentInputOnChanged,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  // Grade
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16.0),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        errorStyle: TextStyle(height: 0),
                      ),
                      validator: widget.gradeInputValidator,
                    ),
                  ),
                ),
                Expanded(
                  // Weights
                  child: TextFormField(
                    style: const TextStyle(fontSize: 16.0),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      label: Text('%'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      errorStyle: TextStyle(height: 0),
                    ),
                    validator: widget.weightInputValidator,
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
  final GradeData data;

  @override
  State<OutputTable> createState() => _OutputTableState();
}

class _OutputTableState extends State<OutputTable> {
  List<TableRow> courseData() {
    List<TableRow> children = [];
    for (var id = 0; id < widget.data.numAssignments; id++) {
      children.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: Text(widget.data.assignments[id] == ''
                  ? 'Task ${id + 1}'
                  : widget.data.assignments[id]),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(7.5),
                child: Text(
                  widget.data.componentGradesInput[id],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(7.5),
                child: Text('${widget.data.weights[id].toStringAsFixed(0)} %'),
              ),
            ),
          ],
        ),
      );
    }
    return children;
  }

  String getGradeLabel() {
    double averageGrade = widget.data.averageGrade;
    for (String label in gradelabel.keys) {
      if (averageGrade >= gradelabel[label]!) {
        return label;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasSubmitted) {
      return const SizedBox(
        height: 100,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 160.0),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                style: BorderStyle.solid,
                color: const Color(0xff888888),
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                  child: Text(
                    'RESULT',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.5, vertical: 7.5),
                          child: Text('Average Grade'),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7.5, vertical: 5.0),
                          child: Text(
                              '${getGradeLabel()} (${widget.data.averageGrade.toStringAsFixed(2)})'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Builder(
                key: UniqueKey(),
                builder: (context) {
                  double totalWeight = widget.data.totalWeights;
                  if (!widget.data.hasCompletedCourse) {
                    return RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text:
                                '*This result is based on the total weight of ',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                            ),
                          ),
                          TextSpan(
                            text: '${(totalWeight * 100).toStringAsFixed(0)}%.',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'JetBrainsMono',
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Text('');
                }),
          ),
        ],
      ),
    );
  }
}
