import 'package:flutter/material.dart';
import '../core/constants.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> regions;
  final String? selectedRegion;
  final Function(String?) onSelected;
  const FilterChipsWidget({
    super.key,
    required this.regions,
    required this.selectedRegion,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: regions.map((region) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(region),
              selected: selectedRegion == region,
              onSelected: (_) => onSelected(region == 'All' ? null : region),
              backgroundColor: Colors.white,
              selectedColor: const Color(AppColors.accentGold),
              checkmarkColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}
