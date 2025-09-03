# Localization System Documentation

This document explains how to use the localization system implemented in the Elsadeken Flutter app.

## Overview

The app supports two languages:
- **Arabic (ar)** - Default language with RTL support
- **English (en)** - LTR support

## Key Components

### 1. LocalizationService
Located at `lib/core/services/localization_service.dart`

This service manages the current locale and provides methods to change languages.

```dart
// Get the service instance
final localizationService = LocalizationService.instance;

// Change language
await localizationService.changeLocale('en');

// Check current language
if (localizationService.isArabic) {
  // Handle Arabic-specific logic
}
```

### 2. LocalizationHelper
Located at `lib/core/helper/localization_helper.dart`

This helper provides easy access to localization utilities and RTL/LTR support.

```dart
// Get localized text
final text = LocalizationHelper.getLocalizedText('مرحبا', 'Hello');

// Check language
if (LocalizationHelper.isArabic) {
  // Arabic logic
}

// Get RTL/LTR alignments
final crossAxisAlignment = LocalizationHelper.startCrossAxisAlignment;
final mainAxisAlignment = LocalizationHelper.startMainAxisAlignment;
```

### 3. Language Toggle Widget
Located at `lib/core/widgets/language_toggle.dart`

A pre-built widget that allows users to switch between languages.

```dart
LanguageToggle()
```

## Usage Examples

### Basic Text Localization

```dart
Text(
  LocalizationHelper.getLocalizedText('مرحبا', 'Hello'),
  style: TextStyle(fontSize: 18),
)
```

### RTL/LTR Layout Support

```dart
Column(
  crossAxisAlignment: LocalizationHelper.startCrossAxisAlignment,
  children: [
    Text('Content'),
  ],
)
```

### Conditional Layout Based on Language

```dart
Row(
  mainAxisAlignment: LocalizationHelper.isArabic 
    ? MainAxisAlignment.end 
    : MainAxisAlignment.start,
  children: [
    Icon(Icons.arrow_back),
    Text('Back'),
  ],
)
```

### Using in Widgets

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocalizationService.instance,
      builder: (context, child) {
        return Container(
          child: Text(
            LocalizationHelper.getLocalizedText('العنوان', 'Title'),
          ),
        );
      },
    );
  }
}
```

## Adding New Translations

### 1. Update ARB Files

Add new keys to both language files:

**`lib/l10n/app_en.arb`:**
```json
{
  "newKey": "English Text"
}
```

**`lib/l10n/app_ar.arb`:**
```json
{
  "newKey": "النص العربي"
}
```

### 2. Use in Code

```dart
LocalizationHelper.getLocalizedText('النص العربي', 'English Text')
```

## RTL/LTR Layout Guidelines

### Text Direction
- Arabic: Right-to-Left (RTL)
- English: Left-to-Right (LTR)

### Alignment Helpers
- `startCrossAxisAlignment`: Aligns content to the start based on language
- `endCrossAxisAlignment`: Aligns content to the end based on language
- `startMainAxisAlignment`: Main axis alignment for start
- `endMainAxisAlignment`: Main axis alignment for end

### Padding and Margins
- `startPadding`: Padding for start side
- `endPadding`: Padding for end side
- `startMargin`: Margin for start side
- `endMargin`: Margin for end side

## API Integration

The localization system automatically updates the `lang` header in API requests when the language changes.

```dart
// Headers are automatically updated
// Arabic: 'lang': 'ar'
// English: 'lang': 'en'
```

## Best Practices

1. **Always use ListenableBuilder** when you need to rebuild UI on language changes
2. **Use LocalizationHelper** for consistent RTL/LTR support
3. **Test both languages** to ensure proper layout
4. **Use semantic names** for alignment properties (start/end instead of left/right)
5. **Keep translations organized** in the ARB files

## Troubleshooting

### Language Not Changing
- Ensure `ListenableBuilder` is used
- Check if `LocalizationService.instance` is properly initialized
- Verify the locale change method is called

### Layout Issues
- Use `LocalizationHelper` alignment properties
- Test both RTL and LTR layouts
- Check if `Directionality` widget is properly set

### API Headers Not Updated
- Ensure `DioFactory.updateLanguageHeader()` is called
- Check if the localization service is properly integrated

## Migration Guide

To migrate existing widgets to support localization:

1. Wrap the widget with `ListenableBuilder`
2. Replace hardcoded text with `LocalizationHelper.getLocalizedText()`
3. Update layout properties to use RTL/LTR helpers
4. Test both language orientations
