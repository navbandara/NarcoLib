/// Utility definitions holding shared preference keys, assets, and validation patterns.
class AppConstants {
  // Shared Preferences Keys
  static const String keyOfficerToken = 'pref_officer_token';
  static const String keySavedOfficer = 'pref_saved_officer';
  static const String keyThemeMode = 'pref_theme_mode';

  // Assets
  static const String logoAssetPath = 'assets/logo.png';
  static const String appTitle = 'NarcoLib';

  // Validation Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String badgePattern = r'^[a-zA-Z0-9\-]{3,10}$';
}
