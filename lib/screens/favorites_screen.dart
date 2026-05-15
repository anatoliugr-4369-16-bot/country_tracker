import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../widgets/empty_state.dart';
import '../core/constants.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CountryProvider>();
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorite Countries')),
      body: favorites.isEmpty
          ? const EmptyStateWidget(
              message: 'No favorites yet.\nAdd some from country details!',
              icon: Icons.favorite_border,
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (ctx, index) {
                final fav = favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fav['flagUrl'],
                        width: 50,
                        height: 35,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.flag),
                      ),
                    ),
                    title: Text(fav['name']),
                    subtitle: Text(
                      fav['note'].isEmpty ? 'No note' : fav['note'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                        await provider.removeFromFavorites(fav['countryCode']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from favorites'),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      // Find the full country object from all countries to show detail
                      final country = provider.countries.firstWhere(
                        (c) => c.cca2 == fav['countryCode'],
                        orElse: () => throw Exception('Country not found'),
                      );
                      Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: country,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
