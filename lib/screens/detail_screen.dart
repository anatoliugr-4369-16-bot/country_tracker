import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    final provider = context.read<CountryProvider>();
    isFav = provider.isFavorite(widget.country.cca2);
    final fav = provider.getFavorite(widget.country.cca2);
    note = fav?['note'];
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

  void _editNote() async {
    final TextEditingController controller = TextEditingController(
      text: note ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write your personal note about this country',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() => note = result);
      if (isFav) {
        await context.read<CountryProvider>().updateNote(
          widget.country.cca2,
          result,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.name),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: const Color(AppColors.accentGold),
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.country.flagUrl,
                  height: 150,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _infoTile(Icons.location_city, 'Capital', widget.country.capital),
            _infoTile(
              Icons.people,
              'Population',
              widget.country.population.toString(),
            ),
            _infoTile(Icons.public, 'Region', widget.country.region),
            _infoTile(
              Icons.language,
              'Languages',
              widget.country.languages.join(', '),
            ),
            _infoTile(
              Icons.access_time,
              'Timezones',
              widget.country.timezones.join(', '),
            ),
            if (widget.country.area != null)
              _infoTile(
                Icons.square_foot,
                'Area (km²)',
                widget.country.area!.toString(),
              ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.note,
                          color: Color(AppColors.accentGold),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Personal Note',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _editNote,
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note?.isEmpty ?? true
                          ? 'No note added yet. Tap Edit to write something.'
                          : note!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(AppColors.primaryBrown)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(AppColors.secondaryText),
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
