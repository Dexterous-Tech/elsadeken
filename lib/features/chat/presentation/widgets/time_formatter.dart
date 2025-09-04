import 'package:flutter/material.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

class TimeFormatter {
  static String formatChatTime(DateTime? time, [BuildContext? context]) {
    if (time == null) return '';

    final now = DateTime.now();
    final difference = now.difference(time);

    // Determine locale (default to Arabic suffixes if no context)
    final isArabic = context != null && AppLocalizations.of(context)!.localeName.toLowerCase().startsWith('ar');

    if (difference.inDays >= 1) {
      final d = difference.inDays;
      final suffix = isArabic ? 'ي' : 'd';
      return '$d$suffix';
    }
    if (difference.inHours >= 1) {
      final h = difference.inHours;
      final suffix = isArabic ? 'س' : 'h';
      return '$h$suffix';
    }
    if (difference.inMinutes >= 1) {
      final m = difference.inMinutes;
      final suffix = isArabic ? 'د' : 'm';
      return '$m$suffix';
    }

    // Just now -> show localized "now"
    if (context != null) {
      return AppLocalizations.of(context)!.now;
    }
    return 'الآن';
  }

  static String formatMessageTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'pm' : 'am';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute$period';
  }

  static String formatRelativeTime(DateTime time, [BuildContext? context]) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      if (context != null) {
        return '${difference.inDays} ${AppLocalizations.of(context)!.day}';
      }
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      if (context != null) {
        return '${difference.inHours} ${AppLocalizations.of(context)!.hour}';
      }
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      if (context != null) {
        return '${difference.inMinutes} ${AppLocalizations.of(context)!.minute}';
      }
      return '${difference.inMinutes} دقيقة';
    } else {
      if (context != null) {
        return AppLocalizations.of(context)!.now;
      }
      return 'الآن';
    }
  }
}
