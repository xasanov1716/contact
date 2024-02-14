import 'package:flutter/material.dart';
class GlobalButton extends StatelessWidget {
  const GlobalButton({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: Colors.orange,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: Text(title)),
      ),
    );
  }
}
