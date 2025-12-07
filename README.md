# Elsadeken (الصادقين) - Islamic Marriage Platform

<div align="center">

![Elsadeken App](https://img.shields.io/badge/Platform-Flutter-blue?style=for-the-badge&logo=flutter)
![Version](https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)

**A comprehensive Islamic marriage platform connecting sincere Muslim men and women seeking life partners based on Islamic values, respect, and compatibility.**

[Features](#-key-features) • [Installation](#-getting-started) • [Platform Setup](#-platform-setup) • [Architecture](#-project-structure)

</div>

---

## 🌟 App Attraction

**Elsadeken** (الصادقين - The Truthful Ones) is a modern, secure, and respectful Islamic marriage platform designed to help Muslim men and women find their life partners in accordance with Islamic principles. The app combines cutting-edge technology with traditional values, offering a safe and dignified environment for meaningful connections.

### What Makes Elsadeken Special?

- **🕌 Islamic Values First**: Built with Islamic principles at its core, ensuring all interactions respect religious guidelines and cultural sensitivities
- **🔒 Privacy & Security**: Advanced privacy controls, secure authentication, and encrypted messaging to protect user data
- **🌍 Global Reach**: Connect with members from various countries and nationalities while maintaining cultural respect
- **💬 Real-Time Communication**: Instant messaging powered by Pusher WebSocket technology for seamless conversations
- **🎯 Smart Matching**: Advanced search filters and compatibility features to find your ideal partner
- **📱 Modern Experience**: Beautiful, intuitive interface with bilingual support (Arabic/English)
- **✨ Success Stories**: Inspiring real-life success stories from couples who found their partners through the platform
- **📚 Educational Content**: Access to Islamic marriage blog articles and guidance

---

## 🎯 Key Features

### 1. **User Authentication & Security** 🔐
- **Secure Registration**: Free registration with comprehensive profile setup
- **Email Verification**: Email-based account verification for security
- **Password Management**: Secure password reset and recovery options
- **Oath Commitment**: Users take an Islamic oath committing to lawful marriage intentions
- **Session Management**: Secure token-based authentication with automatic session handling

### 2. **Comprehensive Profile Management** 👤
- **Personal Information**: Complete profile with name, age, nationality, country, and city
- **Physical Attributes**: Height, weight, body structure, and skin color preferences
- **Religious Information**: Religious commitment level, prayer status, hijab/beard preferences, smoking status
- **Marital Status**: Current marital status and marriage type preferences (polygamy options)
- **Education & Career**: Educational qualifications, job details, and financial status
- **Health Information**: Health status disclosure for transparency
- **Photo Management**: Upload and manage profile photos with privacy controls
- **About Me Section**: Personal description and life partner preferences
- **Profile Visibility**: Control who can view your profile and photos

### 3. **Real-Time Chat System** 💬
- **Instant Messaging**: Real-time chat powered by Pusher WebSocket technology
- **Message History**: Complete conversation history with pagination
- **Typing Indicators**: See when someone is typing in real-time
- **Read Receipts**: Know when your messages have been read
- **Chat Management**: 
  - Mark messages as read/unread
  - Delete individual chats or all conversations
  - Mute/unmute conversations
  - Report inappropriate users
  - Add/remove favorites
- **Message Settings**: Control who can send you messages (all members, specific countries, or no one)
- **Connection Status**: Show/hide online status

### 4. **Advanced Search & Discovery** 🔍
- **Quick Search**: Search by username for instant results
- **Advanced Filters**:
  - **Location**: Filter by nationality, country, and city
  - **Age Range**: Specify desired age range
  - **Physical Attributes**: Filter by height, weight, body structure, skin color
  - **Marital Status**: Search by current marital status
  - **Marriage Type**: Filter by marriage type preferences
  - **Education**: Search by educational qualifications
  - **Religious Criteria**: Filter by religious commitment, prayer, hijab/beard
- **Sorting Options**: Sort by newest, oldest, or most visited profiles
- **Search Results**: Paginated results with detailed member cards

### 5. **Member Discovery** 👥
- **Online Members**: View members currently online
- **New Members**: Discover recently registered members
- **Premium Members**: Browse distinguished premium members
- **Profile Visitors**: See who has visited your profile
- **Health Status Filter**: Filter members by health status
- **Country-Based Filtering**: Filter members by country of residence
- **Infinite Scroll**: Load more members as you scroll

### 6. **Interests & Connections** ❤️
- **Interests List**: Manage your list of members you're interested in
- **Who Interests Me**: See who has added you to their interests list
- **Ignoring List**: Block or ignore members you don't want to interact with
- **Favorites**: Mark important conversations as favorites
- **Profile Actions**: Express interest, ignore, or report members directly from profiles

### 7. **Blog & Success Stories** 📖
- **Islamic Blog**: Access educational articles about Islamic marriage
- **Success Stories**: Read inspiring real-life success stories from married couples
- **Story Statistics**: View total number of successful marriages through the platform
- **Expandable Content**: Read full blog posts and success stories with expand/collapse functionality

### 8. **Notifications System** 🔔
- **Push Notifications**: Firebase Cloud Messaging for real-time notifications
- **Notification Types**:
  - New messages
  - Profile visits
  - Added to interests list
  - Added to ignore list
  - New success stories
- **Notification Settings**: Customize which notifications you want to receive
- **Notification History**: View all your notifications in one place

### 9. **Excellence Package (Premium Features)** ⭐
- **Enhanced Profile Visibility**: Your profile appears at the top of all lists
- **Username Change**: Change your username anytime
- **Message Filtering**: Control which countries can message you
- **Invisible Mode**: Browse profiles without appearing online
- **Premium Members List**: Your profile featured on premium members page
- **Location Verification**: See actual residence country of members (IP-based)
- **Subscription Plans**: Flexible monthly subscription options

### 10. **Settings & Privacy** ⚙️
- **Account Management**: Update login credentials, email, and phone number
- **Privacy Controls**: Manage profile visibility and photo privacy
- **Language Settings**: Switch between Arabic and English
- **Connection Status**: Control whether you appear online or offline
- **Account Deletion**: Permanently delete your account if needed
- **Terms & Conditions**: Access platform terms and privacy policy

### 11. **Multi-Language Support** 🌐
- **Bilingual Interface**: Full support for Arabic and English
- **RTL Support**: Proper right-to-left layout for Arabic
- **Localized Content**: All UI elements and content translated
- **Language Switching**: Easy language switching from settings

### 12. **Onboarding Experience** 🚀
- **Welcome Screen**: Beautiful introduction to the platform
- **Registration Flow**: Step-by-step guided registration process
- **Oath Commitment**: Islamic oath during registration
- **Profile Completion**: Helpful prompts to complete your profile

### 13. **Additional Features** ✨
- **Share App**: Share the app with friends and family
- **Contact Us**: Direct communication with support team
- **About Us**: Learn more about the platform
- **Technical Support**: Get help with technical issues
- **Profile Photos Gallery**: View and manage multiple profile photos
- **Member Photos**: Browse photos of other members (with privacy controls)

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Latest stable version (3.10.1+)
- **Dart SDK**: Included with Flutter
- **Development Tools**:
  - Android Studio / VS Code with Flutter extensions
  - Xcode (for iOS development on macOS)
  - Android SDK (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd elsadeken
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 📱 Platform Setup

### iOS Setup

#### Camera Permissions
The app requires these permissions in `Info.plist`:
- **Camera** (`NSCameraUsageDescription`): "This app requires camera access to take photos for profile pictures and document scanning."
- **Photo Library** (`NSPhotoLibraryUsageDescription`): "This app requires access to your photo library to select existing photos for profile pictures and document uploads."
- **Photo Library Add** (`NSPhotoLibraryAddUsageDescription`): "This app requires permission to save photos to your photo library."
- **Microphone** (`NSMicrophoneUsageDescription`): "This app requires microphone access for video recording functionality."

#### Notification Permissions
- **Push Notifications**: Add capability in Xcode
- **Background Modes**: Enable "Remote notifications" and "Background processing"

### Android Setup

#### Camera Permissions
- Camera access is handled automatically by Flutter
- Photo library access is managed by the system
- No additional configuration required

#### Notification Permissions
- Ensure notification channel is configured with high importance
- Check device notification settings

---

## 🔧 Debug Steps

### iOS Debug
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild iOS
cd ios && pod install && cd ..

# Run with verbose logging
flutter run --verbose
```

### Android Debug
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## 🏗️ Project Structure

```
lib/
├── core/                    # Core utilities and shared code
│   ├── di/                  # Dependency injection
│   ├── errors/              # Error handling
│   ├── helper/              # Helper functions
│   ├── networking/          # API services and networking
│   ├── routes/              # App routing and navigation
│   ├── services/            # Core services (Firebase, localization)
│   ├── shared/              # Shared preferences and storage
│   ├── theme/               # App theming and styling
│   └── widgets/             # Reusable widgets
│
├── features/                # Feature-specific modules
│   ├── auth/               # Authentication (login, signup, password reset)
│   ├── chat/               # Real-time chat functionality
│   ├── home/               # Home screen with member discovery
│   ├── members/            # Member listing and filtering
│   ├── on_boarding/        # Onboarding screens
│   ├── profile/            # Profile management
│   │   ├── blog/           # Blog feature
│   │   ├── manage_profile/ # Profile editing
│   │   ├── members_profile/# Viewing other members' profiles
│   │   └── success_stories/ # Success stories feature
│   ├── results/            # Search results
│   ├── search/             # Advanced search functionality
│   └── splash/             # Splash screen
│
├── l10n/                   # Localization files (Arabic & English)
└── main.dart               # App entry point
```

---

## 🔐 Environment Setup

### Firebase Configuration
- Ensure `google-services.json` is in `android/app/`
- Verify Firebase configuration in `lib/firebase_options.dart`
- Configure Firebase Cloud Messaging for push notifications

### API Configuration
- Check API endpoints in `lib/core/networking/api_constants.dart`
- Verify authentication tokens and headers
- Configure Pusher credentials for real-time chat

### Pusher Configuration
- Pusher WebSocket service configured for real-time messaging
- EU cluster with encrypted connections
- Private channel authentication for secure messaging

---

## 🧪 Testing

### iOS Testing
- Test on physical iOS device for full camera functionality
- Grant camera and photo library permissions
- Verify notification permissions
- Test push notifications in background and foreground

### Android Testing
- Camera permissions are handled automatically
- Test notification functionality
- Verify profile image upload
- Test real-time chat connectivity

---

## 🚨 Common Issues

### iOS Issues
- **Camera crashes**: Ensure permissions are granted in iOS Settings
- **Notifications not working**: Check Xcode capabilities and entitlements
- **Build errors**: Run `cd ios && pod install && cd ..`
- **Pusher connection issues**: Verify network connectivity and firewall settings

### Android Issues
- **Foreground notifications**: Check notification channel importance
- **Permission issues**: Verify device notification settings
- **Chat connection problems**: Check internet connectivity and Pusher configuration

---

## 📞 Support

For issues or questions:
1. Check this README for troubleshooting steps
2. Verify all permissions are properly configured
3. Test on physical devices for full functionality
4. Check Flutter and platform logs for error details
5. Contact technical support through the app's "Contact Us" feature

---

## 🛠️ Technology Stack

- **Framework**: Flutter 3.10.1+
- **State Management**: Flutter BLoC (Cubit pattern)
- **Networking**: Dio for HTTP requests
- **Real-Time Chat**: Pusher Channels (WebSocket)
- **Push Notifications**: Firebase Cloud Messaging
- **Local Storage**: Flutter Secure Storage, Shared Preferences
- **Image Handling**: Cached Network Image, Image Picker
- **Localization**: Flutter Intl (ARB files)
- **Dependency Injection**: GetIt
- **Architecture**: Clean Architecture with Feature-based structure

---

## 📄 License

This project is private and proprietary. All rights reserved.

---

## 🙏 Acknowledgments

Built with respect for Islamic values and designed to help Muslim men and women find their life partners in a dignified and secure environment.

---

**Note**: This app requires camera, photo library, and notification access to function properly. Ensure all permissions are granted during testing to avoid crashes. The app is designed for portrait orientation only.
