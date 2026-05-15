import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/country_provider.dart';
import 'core/themes.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/compare_screen.dart';
import 'screens/detail_screen.dart';
import 'models/country.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CountryProvider())],
      child: MaterialApp(
        title: 'Country Tracker',
        theme: appTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/compare': (context) => const CompareScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final country = settings.arguments as Country;
            return MaterialPageRoute(
              builder: (context) => DetailScreen(country: country),
            );
          }
          return null;
        },
      ),
    );
  }
}
