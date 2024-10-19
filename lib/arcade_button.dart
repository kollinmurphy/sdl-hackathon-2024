import 'package:flutter/material.dart';

class ArcadeButton extends StatefulWidget {
  const ArcadeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  State<ArcadeButton> createState() => _ArcadeButtonState();
}

class _ArcadeButtonState extends State<ArcadeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: _isPressed ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white, width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
