class TranslationLanguages {
  static final selectLanguages = <String>[
    'Bengali',
    'Hindi',
    'Marathi',
    'Gujarati',
    'Malayalam',
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Russian',
    'Kannada',
    'Punjabi',
    'Tamil',
    'Japanese',
  ];

  static String getLanguageCode(String language) {
    switch (language) {
      case 'Bengali':
        return 'bn';
      case 'Hindi':
        return 'hi';
      case 'Marathi':
        return 'mr';
      case 'Gujarati':
        return 'gu';
      case 'Malayalam':
        return 'ml';
      case 'English':
        return 'en';
      case 'Spanish':
        return 'es';
      case 'French':
        return 'fr';
      case 'German':
        return 'de';
      case 'Italian':
        return 'it';
      case 'Russian':
        return 'ru';
      case 'Kannada':
        return 'kn';
      case 'Punjabi':
        return 'pa';
      case 'Tamil':
        return 'ta';
      case 'Japanese':
        return 'ja';
      default:
        return 'en';
    }
  }
}
