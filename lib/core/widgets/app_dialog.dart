import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/arabic_text_sanitizer.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/config/routes/app_routes.dart';

enum AppDialogType { warning, info, success, failed }

class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String message,
    AppDialogType type = AppDialogType.info,
    String? title,
    String confirmText = 'OK',
    bool barrierDismissible = true,
    Widget? body,
    VoidCallback? onConfirm,
  }) {
    final dialogTitle = title ?? _title(type);
    final dialogMessage = ArabicTextSanitizer.dialogMessage(message);

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final brandColor = _brandColor();
        final accentColor = _accentColor(type);

        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogIcon(type: type, color: accentColor),
                const SizedBox(height: 16),
                if (dialogTitle.isNotEmpty) ...[
                  Text(
                    dialogTitle,
                    textAlign: TextAlign.center,
                    style: fontStyle(
                      color: AppColors.blackColor,
                      fontSize: 18.sp,
                      fontFamily: FontFamily.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  dialogMessage,
                  textAlign: TextAlign.center,
                  style: fontStyle(
                    color: AppColors.blackColor,
                    fontSize: 13.sp,
                    fontFamily: FontFamily.medium,
                    height: 1.3,
                  ),
                ),
                if (body != null) ...[
                  const SizedBox(height: 14),
                  body,
                ],
                const SizedBox(height: 22),
                SizedBox(
                  height: 46,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: brandColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      onConfirm?.call();
                    },
                    child: Text(
                      confirmText,
                      style: fontStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontFamily: FontFamily.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _title(AppDialogType type) {
    switch (type) {
      case AppDialogType.warning:
        return LanguageClass.isEnglish ? 'Warning' : 'تنبيه';
      case AppDialogType.info:
        return LanguageClass.isEnglish ? 'Information' : 'معلومة';
      case AppDialogType.success:
        return LanguageClass.isEnglish ? 'Success' : 'تم بنجاح';
      case AppDialogType.failed:
        return LanguageClass.isEnglish ? 'Failed' : 'فشل';
    }
  }

  static Color _brandColor() {
    return Routes.isomra ? AppColors.umragold : AppColors.primaryColor;
  }

  static Color _accentColor(AppDialogType type) {
    switch (type) {
      case AppDialogType.warning:
        return Routes.isomra ? AppColors.umragold : AppColors.darkRed;
      case AppDialogType.info:
        return AppColors.grey;
      case AppDialogType.success:
        return _brandColor();
      case AppDialogType.failed:
        return AppColors.darkRed;
    }
  }

  static IconData _icon(AppDialogType type) {
    switch (type) {
      case AppDialogType.warning:
        return Icons.warning_amber_rounded;
      case AppDialogType.info:
        return Icons.info_outline_rounded;
      case AppDialogType.success:
        return Icons.check_circle_outline_rounded;
      case AppDialogType.failed:
        return Icons.error_outline_rounded;
    }
  }
}

class _DialogIcon extends StatelessWidget {
  const _DialogIcon({required this.type, required this.color});

  final AppDialogType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      width: 78,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        border: Border.all(
          color: color.withOpacity(0.22),
          width: 1.2,
        ),
      ),
      child: Center(
        child: Icon(
          AppDialog._icon(type),
          color: color,
          size: 44,
        ),
      ),
    );
  }
}
