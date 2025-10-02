/// Utility class for text processing and formatting
class TextUtils {
  /// Remove HTML tags from string and decode HTML entities
  static String removeHtmlTags(String htmlString) {
    if (htmlString.isEmpty) return htmlString;

    // Remove HTML tags
    RegExp htmlTagRegex =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    String cleaned = htmlString.replaceAll(htmlTagRegex, '');

    // Decode common HTML entities
    cleaned = cleaned
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('<br />', '\n');

    return cleaned.trim();
  }

  /// Clean and format Quranic text for display
  static String formatQuranText(String text) {
    String cleaned = removeHtmlTags(text);

    // Remove extra whitespaces and clean up
    cleaned = cleaned
        .replaceAll(
            RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .replaceAll(RegExp(r'\n\s*\n'), '\n') // Remove empty lines
        .trim();

    return cleaned;
  }

  /// Format text for copying to clipboard
  static String formatForClipboard(String arabicText, String latinText,
      String indonesianText, int surahNumber, int ayahNumber) {
    return '''${formatQuranText(arabicText)}

${formatQuranText(latinText)}

${formatQuranText(indonesianText)}

QS. $surahNumber:$ayahNumber''';
  }
}
