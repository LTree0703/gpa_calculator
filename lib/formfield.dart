import 'package:flutter/material.dart';

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
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
        minimumSize: const MaterialStatePropertyAll(Size(135, 51)),
        shape: const MaterialStatePropertyAll(
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
