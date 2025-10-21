import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final String language;
  final String flagPath;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageButton({
    Key? key,
    required this.language,
    required this.flagPath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1F4F9) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Image.asset(flagPath, width: 32, height: 24),
            const SizedBox(width: 16),
            Text(
              language,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.circle,
              size: 16,
              color: isSelected ? const Color(0xFFE89812) : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}