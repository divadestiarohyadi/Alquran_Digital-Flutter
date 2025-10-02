import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Keys untuk SharedPreferences
  static const String _arabicTextOnlyKey = 'arabic_text_only';
  static const String _showTranslationKey = 'show_translation';
  static const String _nightModeKey = 'night_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  // Default values
  static const bool _defaultArabicTextOnly = false;
  static const bool _defaultShowTranslation = true;
  static const bool _defaultNightMode = false;
  static const double _defaultFontSize = 20.0;
  static const bool _defaultNotificationsEnabled = true;

  // Get SharedPreferences instance
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Arabic Text Only
  static Future<bool> getArabicTextOnly() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_arabicTextOnlyKey) ?? _defaultArabicTextOnly;
  }

  static Future<void> setArabicTextOnly(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_arabicTextOnlyKey, value);
  }

  // Show Translation
  static Future<bool> getShowTranslation() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_showTranslationKey) ?? _defaultShowTranslation;
  }

  static Future<void> setShowTranslation(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_showTranslationKey, value);
  }

  // Night Mode
  static Future<bool> getNightMode() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_nightModeKey) ?? _defaultNightMode;
  }

  static Future<void> setNightMode(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_nightModeKey, value);
  }

  // Font Size
  static Future<double> getFontSize() async {
    final prefs = await _getPrefs();
    return prefs.getDouble(_fontSizeKey) ?? _defaultFontSize;
  }

  static Future<void> setFontSize(double value) async {
    final prefs = await _getPrefs();
    await prefs.setDouble(_fontSizeKey, value);
  }

  // Notifications Enabled
  static Future<bool> getNotificationsEnabled() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_notificationsEnabledKey) ??
        _defaultNotificationsEnabled;
  }

  static Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_notificationsEnabledKey, value);
  }

  // Get all settings at once
  static Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'arabicTextOnly': await getArabicTextOnly(),
      'showTranslation': await getShowTranslation(),
      'nightMode': await getNightMode(),
      'fontSize': await getFontSize(),
      'notificationsEnabled': await getNotificationsEnabled(),
    };
  }

  // Reset all settings to default
  static Future<void> resetToDefaults() async {
    final prefs = await _getPrefs();
    await prefs.setBool(_arabicTextOnlyKey, _defaultArabicTextOnly);
    await prefs.setBool(_showTranslationKey, _defaultShowTranslation);
    await prefs.setBool(_nightModeKey, _defaultNightMode);
    await prefs.setDouble(_fontSizeKey, _defaultFontSize);
    await prefs.setBool(_notificationsEnabledKey, _defaultNotificationsEnabled);
  }

  // Clear all settings
  static Future<void> clearAllSettings() async {
    final prefs = await _getPrefs();
    await prefs.remove(_arabicTextOnlyKey);
    await prefs.remove(_showTranslationKey);
    await prefs.remove(_nightModeKey);
    await prefs.remove(_fontSizeKey);
    await prefs.remove(_notificationsEnabledKey);
  }
}
