import 'package:flutter/material.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

class TimeFormatter {
  static String formatChatTime(DateTime? time, [BuildContext? context]) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.day}/${time.month}';
    } else if (difference.inHours > 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      if (context != null) {
        return '${time.minute}${AppLocalizations.of(context)!.minute}';
      }
      return '${time.minute}م';
    } else {
      if (context != null) {
        return AppLocalizations.of(context)!.now;
      }
      return 'الآن';
    }
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
