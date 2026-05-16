class Country {
  final String name;
  final String officialName;
  final String capital;
  final int population;
  final String region;
  final String flagUrl;
  final String? subregion;
  final double? area;
  final List<String> languages;
  final List<String> timezones;
  final String cca2;
  final String? currency; // Add currency

  Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.population,
    required this.region,
    required this.flagUrl,
    this.subregion,
    this.area,
    required this.languages,
    required this.timezones,
    required this.cca2,
    this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    String? currency;
    if (json['currencies'] != null) {
      final currencies = json['currencies'] as Map<String, dynamic>;
      if (currencies.isNotEmpty) {
        currency = currencies.values.first['name'];
      }
    }

    return Country(
      name: json['name']['common'] ?? 'Unknown',
      officialName: json['name']['official'] ?? 'Unknown',
      capital: (json['capital'] != null && json['capital'].isNotEmpty)
          ? json['capital'][0]
          : 'No capital',
      population: json['population'] ?? 0,
      region: json['region'] ?? 'Unknown',
      flagUrl: json['flags']?['png'] ?? '',
      subregion: json['subregion'],
      area: json['area']?.toDouble(),
      languages: json['languages'] != null
          ? List<String>.from(json['languages'].values)
          : [],
      timezones: json['timezones'] != null
          ? List<String>.from(json['timezones'])
          : [],
      cca2: json['cca2'] ?? '',
      currency: currency,
    );
  }

  // Generate interesting facts about the country
  List<String> get interestingFacts {
    List<String> facts = [];
    if (area != null) {
      facts.add('Area: ${area!.toStringAsFixed(0)} km²');
    }
    if (population > 0) {
      facts.add(
        'Population density: ${(population / (area ?? 1)).toStringAsFixed(1)} per km²',
      );
    }
    if (languages.isNotEmpty) {
      facts.add('Official languages: ${languages.join(', ')}');
    }
    if (region == 'Asia') {
      facts.add('🌏 Largest continent by population');
    }
    if (region == 'Europe') {
      facts.add('🏰 Home to many historic landmarks');
    }
    if (region == 'Africa') {
      facts.add('🦁 Known for diverse wildlife');
    }
    if (region == 'Americas') {
      facts.add('🌎 Stretches from north to south');
    }
    if (name == 'Japan') {
      facts.add('🇯🇵 Consists of 6,852 islands');
      facts.add('🚄 Has the fastest bullet train (Shinkansen)');
      facts.add('🗻 Mount Fuji is an active volcano');
      facts.add('🍣 Sushi originated in Japan');
    }
    if (name == 'France') facts.add('🥖 Famous for baguettes and wine');
    if (name == 'Egypt') facts.add('🐪 Home to the Great Pyramids');
    // Add more custom facts if needed
    if (facts.isEmpty) {
      facts.add('Explore this beautiful country!');
    }
    return facts;
  }

  String get callingCode => '+${cca2.isNotEmpty ? cca2 : '1'}'; // placeholder
  String get drivingSide => 'Right'; // API doesn't provide, default
  String get government => 'Varies by country'; // placeholder
}
