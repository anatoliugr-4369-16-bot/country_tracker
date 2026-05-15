import 'package:flutter/material.dart';
import '../models/country.dart';
import '../core/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;
  const CountryCard({super.key, required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        country.flagUrl,
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.flag, size: 40),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            country.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${country.capital} • ${country.region}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.secondaryText),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Population: ${country.population}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(AppColors.accentGold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
