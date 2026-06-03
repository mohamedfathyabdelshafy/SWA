import 'language.dart';

class ArabicTextSanitizer {
  static String dialogMessage(
    String text, {
    String arabicFallback = 'حدث خطأ غير متوقع، برجاء المحاولة مرة أخرى',
  }) {
    if (LanguageClass.isEnglish || !_looksCorrupted(text)) {
      return text;
    }

    return arabicFallback;
  }

  static String snackBarMessage(String text) {
    if (LanguageClass.isEnglish || !_looksCorrupted(text)) {
      return text;
    }

    return 'حدث خطأ غير متوقع، برجاء المحاولة مرة أخرى';
  }

  static bool _looksCorrupted(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    final questionMarks = RegExp(r'\?').allMatches(trimmed).length;
    final replacementChars = RegExp('\uFFFD').allMatches(trimmed).length;
    final hasMojibakeMarkers = RegExp(r'[ØÙ]').hasMatch(trimmed);

    if (hasMojibakeMarkers || replacementChars > 0) {
      return true;
    }

    if (questionMarks < 3) return false;

    final visibleChars = trimmed.replaceAll(RegExp(r'\s'), '').length;
    if (visibleChars == 0) return false;

    return questionMarks / visibleChars >= 0.45;
  }
}
