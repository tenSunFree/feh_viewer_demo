class Const {
  static const String CHROME_USER_AGENT =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36';
  static const String CHROME_ACCEPT =
      'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
  static const String CHROME_ACCEPT_LANGUAGE = 'en-US,en;q=0.5';
  static const String BASE_URL = 'https://jsonplaceholder.typicode.com/';

  static String getBaseSite([bool isEx = false]) => BASE_URL;

  /// iso936语言对应缩写
  static const Map<String, String> iso936 = <String, String>{
    'japanese': 'JP',
    'english': 'EN',
    'chinese': 'ZH',
    'dutch': 'NL',
    'french': 'FR',
    'german': 'DE',
    'hungarian': 'HU',
    'italian': 'IT',
    'korean': 'KR',
    'polish': 'PL',
    'portuguese': 'PT',
    'russian': 'RU',
    'spanish': 'ES',
    'thai': 'TH',
    'vietnamese': 'VI',
  };
}
