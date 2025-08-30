# Signup Shared Preferences Implementation

This implementation allows users to save their signup progress and resume from where they left off, even if they close the app or encounter errors.

## Features

- **Automatic Data Saving**: All form data is automatically saved when users move between steps
- **Progress Persistence**: Current step and form data are saved to secure storage
- **Resume Functionality**: Users can resume their signup process from the last step they were on
- **Data Expiration**: Saved data expires after 24 hours for security
- **Automatic Cleanup**: Data is automatically cleared after successful registration

## How It Works

### 1. Data Model
The `SignupFormDataModel` stores all form fields from all 13 signup steps:
- Personal Info (name, email, phone, etc.)
- Passwords
- National information
- Country and city selection
- Social status
- General information
- Body shape details
- Religious information
- Additional preferences
- Education details
- Job information
- Personal descriptions

### 2. Shared Preferences Integration
The `SharedPreferencesHelper` class provides methods to:
- Save form data as JSON
- Load saved form data
- Save/load current step
- Save/load gender selection
- Check data freshness (24-hour expiration)
- Clear all signup data

### 3. SignupCubit Enhancements
The `SignupCubit` now includes:
- `initialize()`: Loads saved data and sets up the cubit
- `saveFormData()`: Saves current form state to shared preferences
- `loadSavedFormData()`: Restores form data from shared preferences
- `clearSignupData()`: Removes all saved signup data
- `hasRecentSignupData()`: Checks if valid saved data exists
- `getCurrentStep()` / `saveCurrentStep()`: Manages current step

### 4. UI Integration
- `SignupScreen`: Automatically detects and loads saved data
- `SignupBody`: Saves data on step changes
- `SignupPageView`: Saves data when navigating between pages
- Automatic data clearing after successful registration

## Usage Examples

### Basic Usage
```dart
// The signup screen automatically handles saved data
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SignupScreen(gender: 'male'),
  ),
);
```

### Manual Data Management
```dart
final cubit = SignupCubit.get(context);

// Check if there's saved data
if (await cubit.hasRecentSignupData()) {
  // Load saved data
  await cubit.loadSavedFormData();
  
  // Get saved step
  final savedStep = await cubit.getCurrentStep();
  
  // Resume from saved step
  // ... navigate to signup screen with saved step
}

// Save current form data
await cubit.saveFormData();

// Clear saved data (e.g., after successful registration)
await cubit.clearSignupData();
```

### Resume Dialog
```dart
// Show resume dialog when user has saved data
if (await cubit.hasRecentSignupData()) {
  showDialog(
    context: context,
    builder: (context) => SignupResumeDialog(
      onResume: () {
        // Navigate to signup with saved data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupScreen(gender: 'male'),
          ),
        );
      },
      onStartNew: () {
        // Clear saved data and start fresh
        cubit.clearSignupData();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupScreen(gender: 'male'),
          ),
        );
      },
    ),
  );
}
```

## Data Security

- All data is stored using `FlutterSecureStorage` for encryption
- Data automatically expires after 24 hours
- Data is automatically cleared after successful registration
- No sensitive data is logged or exposed

## Error Handling

- Graceful handling of corrupted or invalid saved data
- Automatic fallback to fresh signup if data loading fails
- Comprehensive error logging for debugging

## Benefits

1. **User Experience**: Users don't lose progress if they close the app
2. **Error Recovery**: Users can resume after encountering errors
3. **Mobile-Friendly**: Handles app lifecycle events gracefully
4. **Secure**: Uses encrypted storage with automatic expiration
5. **Automatic**: No manual intervention required from users

## Implementation Notes

- Data is saved automatically on every step change
- The system checks for saved data on app startup
- All form controllers are automatically populated with saved data
- The current step is restored when resuming
- Data is cleared after successful registration to prevent conflicts
