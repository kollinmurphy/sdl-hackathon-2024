import 'package:flutter/material.dart';

class ArcadeTextInput extends StatelessWidget {
  const ArcadeTextInput({
    super.key,
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      cursorColor: Colors.transparent,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
      ),
    );
  }
}
