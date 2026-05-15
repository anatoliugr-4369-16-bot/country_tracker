class Country {
  final String name;
  final String capital;
  final int population;
  final String region;
  final String flagUrl;
  final String? subregion;
  final double? area;
  final List<String> languages;
  final List<String> timezones;
  final String cca2;

  Country({
    required this.name,
    required this.capital,
    required this.population,
    required this.region,
    required this.flagUrl,
    this.subregion,
    this.area,
    required this.languages,
    required this.timezones,
    required this.cca2,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'Unknown',
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
    );
  }
}
