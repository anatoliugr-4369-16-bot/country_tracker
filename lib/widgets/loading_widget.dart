import 'package:flutter/material.dart';
import '../core/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(AppColors.accentGold)),
          SizedBox(height: 16),
          Text('Exploring countries...'),
        ],
      ),
    );
  }
}
