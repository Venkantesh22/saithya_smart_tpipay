
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lekra/services/theme.dart';

class KeyCell extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const KeyCell({required this.label, required this.onTap});

  @override
  State<KeyCell> createState() => KeyCellState();
}

class KeyCellState extends State<KeyCell> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 80),
          scale: _down ? 0.96 : 1.0,
          child: Container(
            width: 102,
            height: 50,
            decoration: BoxDecoration(
              color: greyNumberBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
