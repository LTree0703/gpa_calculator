import 'package:flutter/material.dart';
import 'package:uni_quitter/topbar.dart';

class GradeData {
  int numCourses = 6;
  List<String>? assignments;
  List<String> grades = [];
  List<double> weight = [];
}

class GradeCalculator extends StatefulWidget {
  const GradeCalculator({super.key});

  @override
  State<GradeCalculator> createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends State<GradeCalculator> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _data = GradeData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(130.0),
        child: TopBar(title: 'Grade Calculator'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9.5),
                          child: Form(
                            key: _formKey1,
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
                                _formKey1.currentState?.validate();
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
                          Expanded(
                              child: Center(
                                  child: Text(
                            'Assignments/\nExams',
                          ))),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: Center(child: Text('Grade'))),
                                Expanded(child: Center(child: Text('Weight'))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SecondFormInput(formKey: _formKey2, data: _data),
                  const SizedBox(height: 100)
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
              onPressed: () {},
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
              onPressed: () {},
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

class SecondFormInput extends StatefulWidget {
  const SecondFormInput({super.key, required this.formKey, required this.data});
  final GlobalKey<FormState> formKey;
  final GradeData data;

  @override
  State<SecondFormInput> createState() => _SecondFormInputState();
}

class _SecondFormInputState extends State<SecondFormInput> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var i = 0; i < widget.data.numCourses; i++) {
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 16.0),
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 16.0),
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            label: Text('%'),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
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
