import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../models/country.dart';
import '../core/constants.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Country? countryA;
  Country? countryB;

  void _selectCountry(bool isFirst) async {
    final provider = context.read<CountryProvider>();
    final selected = await showModalBottomSheet<Country>(
      context: context,
      builder: (_) => SizedBox(
        height: 400,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Select Country', style: TextStyle(fontSize: 18)),
            ),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: provider.countries.length,
                      itemBuilder: (ctx, i) {
                        final c = provider.countries[i];
                        return ListTile(
                          leading: Image.network(
                            c.flagUrl,
                            width: 40,
                            height: 25,
                          ),
                          title: Text(c.name),
                          onTap: () => Navigator.pop(context, c),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() {
        if (isFirst)
          countryA = selected;
        else
          countryB = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Countries')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildCountrySelector('Country A', countryA, true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCountrySelector('Country B', countryB, false),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (countryA != null && countryB != null)
              Expanded(
                child: SingleChildScrollView(child: _buildComparisonTable()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountrySelector(String label, Country? country, bool isFirst) {
    return InkWell(
      onTap: () => _selectCountry(isFirst),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          height: 120,
          child: country == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: const Color(AppColors.accentGold),
                    ),
                    const SizedBox(height: 8),
                    Text('Select $label'),
                  ],
                )
              : Column(
                  children: [
                    Image.network(country.flagUrl, width: 60, height: 40),
                    const SizedBox(height: 8),
                    Text(
                      country.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(country.capital),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _compareRow(
              'Population',
              countryA!.population.toString(),
              countryB!.population.toString(),
            ),
            _compareRow(
              'Area (km²)',
              countryA!.area?.toString() ?? 'N/A',
              countryB!.area?.toString() ?? 'N/A',
            ),
            _compareRow('Region', countryA!.region, countryB!.region),
            _compareRow(
              'Languages',
              countryA!.languages.join(', '),
              countryB!.languages.join(', '),
            ),
            _compareRow(
              'Timezones',
              countryA!.timezones.first,
              countryB!.timezones.first,
            ),
          ],
        ),
      ),
    );
  }

  Widget _compareRow(String label, String valueA, String valueB) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(valueA, textAlign: TextAlign.center)),
          Expanded(child: Text(valueB, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
