import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchNews({
  String? query,
  List<String>? categories,
  List<String>? countries,
  List<String>? languages,
  List<String>? excludeLanguages,
}) async {
  final apiKey = 'Your API';
  String urlStr = 'https://newsdata.io/api/1/latest?apikey=$apiKey&removeduplicate=1';
  if (countries != null && countries.isNotEmpty) {
    final codes = countries.map((e) => _countryCode(e)).where((e) => e != null).join(',');
    if (codes.isNotEmpty) urlStr += '&country=$codes';
  }
  if (categories != null && categories.isNotEmpty) {
    final cats = categories.map((e) => e.toLowerCase()).join(',');
    if (cats.isNotEmpty) urlStr += '&category=$cats';
  }
  if (languages != null && languages.isNotEmpty) {
    final langs = languages.map((e) => _languageCode(e)).where((e) => e != null).join(',');
    if (langs.isNotEmpty) urlStr += '&language=$langs';
  }
  if (excludeLanguages != null && excludeLanguages.isNotEmpty) {
    final exlangs = excludeLanguages.map((e) => _languageCode(e)).where((e) => e != null).join(',');
    if (exlangs.isNotEmpty) urlStr += '&excludelanguage=$exlangs';
  }
  if (query != null && query.isNotEmpty) {
    urlStr += '&q=$query';
  }
  final url = Uri.parse(urlStr);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results'] ?? <dynamic>[];
  } else {
    return <dynamic>[];
  }
}

// Helper to map country name to code
String? _countryCode(String country) {
  const codes = {
    'United States': 'us',
    'United Kingdom': 'gb',
    'India': 'in',
    'Canada': 'ca',
    'Australia': 'au',
    'Germany': 'de',
    'France': 'fr',
    'Japan': 'jp',
    'China': 'cn',
    'Brazil': 'br',
    'South Africa': 'za',
  };
  return codes[country];
}

// Helper to map language name to code
String? _languageCode(String lang) {
  const codes = {
    'English': 'en',
    'Afrikaans': 'af',
    'Albanian': 'sq',
    'Amharic': 'am',
    'Arabic': 'ar',
    'Bengali': 'bn',
    'Chinese': 'zh',
    'French': 'fr',
    'German': 'de',
    'Hindi': 'hi',
    'Japanese': 'ja',
    'Portuguese': 'pt',
    'Spanish': 'es',
  };
  return codes[lang];
}