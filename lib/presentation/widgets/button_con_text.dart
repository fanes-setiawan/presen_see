import 'package:flutter/material.dart';
import 'package:presen_see/core/constant/app_color.dart';

class ButtonConText extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  const ButtonConText({
    required this.label,
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210.0,
      height: 56.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.accent : AppColors.accent.withOpacity(0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
