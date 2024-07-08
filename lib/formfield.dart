import 'package:flutter/material.dart';

Map<String, double> gradelabel = {
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
  'D-': 0.70,
  'F': 0.00,
};

Map<double, double> percentagelabel = {
  60.0: 0.00,
  63.0: 0.70,
  67.0: 1.00,
  70.0: 1.30,
  73.0: 1.70,
  77.0: 2.00,
  80.0: 2.30,
  83.0: 2.70,
  87.0: 3.00,
  90.0: 3.30,
  93.0: 3.70,
  97.0: 4.00,
  100.1: 4.30,
};

class SimpleTextForm extends StatefulWidget {
  const SimpleTextForm(
      {super.key,
      required this.formKey,
      this.labelText,
      required this.validator});

  final GlobalKey<FormState> formKey;
  final String? labelText;
  final Function(String? value) validator;

  @override
  State<SimpleTextForm> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextForm> {
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

class FormButton extends StatelessWidget {
  final Color backgroundColor;
  final Function() onPressed;
  final Widget child;
  const FormButton(
      {super.key,
      required this.backgroundColor,
      required this.onPressed,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        minimumSize: const WidgetStatePropertyAll(Size(135, 51)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            side: BorderSide(style: BorderStyle.solid),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}