import 'package:flutter_test/flutter_test.dart';
import 'package:swa/core/utils/arabic_text_sanitizer.dart';
import 'package:swa/core/utils/language.dart';

void main() {
  group('ArabicTextSanitizer', () {
    tearDown(() {
      LanguageClass.isEnglish = true;
    });

    test('replaces corrupted Arabic placeholder text', () {
      LanguageClass.isEnglish = false;

      final text = ArabicTextSanitizer.dialogMessage(
        '??? ????? ??? ?????? ???? ?? ????',
      );

      expect(text, 'حدث خطأ غير متوقع، برجاء المحاولة مرة أخرى');
    });

    test('keeps valid Arabic text unchanged', () {
      LanguageClass.isEnglish = false;

      final text = ArabicTextSanitizer.dialogMessage(
        'انتهى وقت الحجز، برجاء بدء الحجز مرة أخرى',
      );

      expect(text, 'انتهى وقت الحجز، برجاء بدء الحجز مرة أخرى');
    });

    test('keeps English text unchanged', () {
      LanguageClass.isEnglish = true;

      final text = ArabicTextSanitizer.dialogMessage(
        'Time for reservation has been finished start again',
      );

      expect(text, 'Time for reservation has been finished start again');
    });
  });
}
