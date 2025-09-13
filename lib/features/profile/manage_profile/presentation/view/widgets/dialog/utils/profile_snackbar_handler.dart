import 'package:elsadeken/core/services/localization_service.dart';
import 'package:flutter/material.dart';

/// Utility class for showing snackbars above dialogs
class ProfileSnackbarHandler {
  /// Show snackbar at the top of the screen using Overlay
  static void showSnackBarAboveDialog(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    // Show snackbar at the top of the screen using Overlay
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top +
            20, // Position below status bar
        left: 16,
        right: 16,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              textDirection: LocalizationService.instance.textDirection,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () {
                    overlayEntry?.remove();
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Insert the overlay
    Overlay.of(context).insert(overlayEntry);

    // Auto-remove after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }
}
