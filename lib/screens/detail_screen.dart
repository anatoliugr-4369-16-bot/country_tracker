import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/country.dart';
import '../providers/country_provider.dart';
import '../core/constants.dart';

class DetailScreen extends StatefulWidget {
  final Country country;
  const DetailScreen({super.key, required this.country});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFav;
  String? note;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<CountryProvider>();
    isFav = provider.isFavorite(widget.country.cca2);
    final fav = provider.getFavorite(widget.country.cca2);
    note = fav?['note'];
    _noteController.text = note ?? '';
  }

  void _toggleFavorite() async {
    final provider = context.read<CountryProvider>();
    if (isFav) {
      await provider.removeFromFavorites(widget.country.cca2);
      setState(() => isFav = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removed from favorites')));
    } else {
      await provider.addToFavorites(widget.country, note: note ?? '');
      setState(() => isFav = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to favorites')));
    }
  }

  void _saveNote() async {
    final newNote = _noteController.text;
    setState(() => note = newNote);
    if (isFav) {
      await context.read<CountryProvider>().updateNote(
        widget.country.cca2,
        newNote,
      );
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note saved')));
  }

  void _deleteNote() {
    setState(() {
      _noteController.clear();
      note = '';
    });
    if (isFav) {
      context.read<CountryProvider>().updateNote(widget.country.cca2, '');
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note deleted')));
  }

  void _share() => Share.share(
    '${widget.country.name}\nCapital: ${widget.country.capital}\nPopulation: ${widget.country.population}\nCurrency: ${widget.country.currency ?? "N/A"}',
  );

  void _viewOnMap() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.country.name}',
    );
    if (await canLaunchUrl(url))
      await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.creamBackground),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: _share,
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Flag
            Hero(
              tag: 'flag_${widget.country.cca2}',
              child: Stack(
                children: [
                  Image.network(
                    widget.country.flagUrl,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 320, color: Colors.grey.shade300),
                  ),
                  Container(
                    height: 320,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.country.name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 8)],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.country.officialName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(AppColors.accentGold),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.country.region,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          Icons.location_city,
                          'Capital',
                          widget.country.capital,
                        ),
                      ),
                      Expanded(
                        child: _statCard(
                          Icons.people,
                          'Population',
                          '${(widget.country.population / 1000000).toStringAsFixed(1)}M',
                        ),
                      ),
                      Expanded(
                        child: _statCard(
                          Icons.square_foot,
                          'Area',
                          widget.country.area?.toStringAsFixed(0) ?? 'N/A',
                        ),
                      ),
                      Expanded(
                        child: _statCard(
                          Icons.monetization_on,
                          'Currency',
                          widget.country.currency?.split(' ').first ?? 'N/A',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // About Section
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.country.name} is located in ${widget.country.region}. The capital city is ${widget.country.capital}. '
                    'Official languages include ${widget.country.languages.join(", ")}.',
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Interesting Facts Card
                  const Text(
                    'Interesting Facts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: widget.country.interestingFacts
                            .map(
                              (fact) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 18,
                                      color: Color(AppColors.accentGold),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(fact)),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Special: Famous Food, Greeting, Nickname (mock data for demo)
                  const SizedBox(height: 24),

                  // Details Grid
                  const Text(
                    'Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _detailRow('Languages', widget.country.languages.join(', ')),
                  _detailRow('Timezone', widget.country.timezones.first),
                  _detailRow('Region', widget.country.region),
                  _detailRow('Driving Side', 'Right'), // Placeholder
                  _detailRow('Calling Code', widget.country.callingCode),
                  const SizedBox(height: 24),

                  // Editable Note Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Journal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Write your travel notes...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: _deleteNote,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Delete'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: _saveNote,
                                icon: const Icon(Icons.save),
                                label: const Text('Save'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _viewOnMap,
                          icon: const Icon(Icons.map),
                          label: const Text('View on Map'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _share,
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value) => Card(
    elevation: 2,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(icon, color: const Color(AppColors.accentGold)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    ),
  );

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );

  Widget _highlightRow(IconData icon, String label, String value) => Row(
    children: [
      Icon(icon, size: 20, color: const Color(AppColors.accentGold)),
      const SizedBox(width: 12),
      Expanded(
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
      Text(value),
    ],
  );

  // Mock data for demo – replace with real API if available
  String _getFood(String name) {
    if (name == 'Japan') return 'Sushi';
    if (name == 'Italy') return 'Pizza';
    if (name == 'Ethiopia') return 'Injera';
    return 'Local cuisine';
  }

  String _getGreeting(String name) {
    if (name == 'Japan') return 'Konnichiwa (こんにちは)';
    if (name == 'France') return 'Bonjour';
    if (name == 'Ethiopia') return 'Selam (ሰላም)';
    return 'Hello';
  }

  String _getNickname(String name) {
    if (name == 'Japan') return 'Land of the Rising Sun';
    if (name == 'Canada') return 'The Great White North';
    if (name == 'Ethiopia') return 'Land of Origins';
    return 'Beautiful Country';
  }
}
