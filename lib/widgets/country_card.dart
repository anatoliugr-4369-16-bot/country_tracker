import 'package:flutter/material.dart';
import '../models/country.dart';
import '../core/constants.dart';

class CountryCard extends StatefulWidget {
  final Country country;
  final VoidCallback onTap;
  const CountryCard({super.key, required this.country, required this.onTap});

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  double _elevation = 4;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.96;
      _elevation = 8;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
      _elevation = 4;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
      _elevation = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Card(
          elevation: _elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Compact flag size to reduce card height
              Hero(
                tag: 'flag_${widget.country.cca2}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    widget.country.flagUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.flag),
                    ),
                  ),
                ),
              ),
              // Text content with tighter padding
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.country.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.country.capital,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(AppColors.secondaryText),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people,
                          size: 14,
                          color: Color(AppColors.accentGold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(widget.country.population / 1000000).toStringAsFixed(1)}M',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
