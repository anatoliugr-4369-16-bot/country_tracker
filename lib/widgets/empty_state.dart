import 'package:flutter/material.dart';
import '../core/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.visibility_off,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: const Color(AppColors.secondaryText)),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Color(AppColors.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}
