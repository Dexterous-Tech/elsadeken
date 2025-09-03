# iOS Testing Guide - Elsadeken App

## 🚨 Critical: Preventing Camera Crashes on iOS

This guide provides step-by-step instructions to prevent crashes when testing camera functionality on iOS devices.

## 📱 Prerequisites

- **Physical iOS Device** (recommended for camera testing)
- **iOS Simulator** (limited camera functionality)
- **Xcode** installed and updated
- **Flutter SDK** latest stable version

## 🔧 Setup Steps

### 1. Build and Install
```bash
# Clean previous builds
flutter clean
flutter pub get

# Build for iOS
flutter build ios --debug

# Or run directly
flutter run
```

### 2. Permission Configuration
The app includes these permissions in `Info.plist`:
- ✅ `NSCameraUsageDescription` - Camera access
- ✅ `NSPhotoLibraryUsageDescription` - Photo library access
- ✅ `NSPhotoLibraryAddUsageDescription` - Save photos
- ✅ `NSMicrophoneUsageDescription` - Microphone access

## 🧪 Testing Steps

### Step 1: Initial App Launch
1. Launch the app on iOS device
2. Navigate to any screen that uses camera (e.g., Profile → My Image)
3. **DO NOT** tap camera button yet

### Step 2: Grant Camera Permissions
1. Go to **Settings** → **Privacy & Security**
2. Find **Camera** and enable for **Elsadeken**
3. Find **Photos** and enable for **Elsadeken**
4. Return to the app

### Step 3: Grant Notification Permissions
1. **IMPORTANT**: When the app launches, you should see a notification permission prompt
2. Tap **"Allow"** when prompted for notifications
3. If no prompt appears, go to **Settings** → **Notifications** → **Elsadeken**
4. Enable **Allow Notifications**
5. Set **Alert Style** to **"Banners"** or **"Alerts"**
6. Enable **Badges**, **Sounds**, and **Lock Screen**

### Step 4: Test Camera Functionality
1. Tap the camera/profile image area
2. Select **"التقاط صورة من الكاميرا"** (Take photo from camera)
3. Grant camera permission when prompted
4. Take a photo and confirm
5. Verify image appears in the app

### Step 5: Test Photo Library
1. Tap camera/profile image area again
2. Select **"اختيار من المعرض"** (Choose from gallery)
3. Grant photo library access when prompted
4. Select an existing photo
5. Verify image appears in the app

### Step 6: Test Photo Upload Functionality
1. After selecting an image (from camera or gallery)
2. Verify the image displays correctly in the app
3. Test the upload process (if applicable)
4. Check that the image is properly uploaded to the server
5. Verify no crashes occur during the upload process

## 🔔 Notification Testing Steps

### Step 7: Verify Notification Setup
1. **Check Console Logs**: Look for these messages when app starts:
   ```
   📱 Notification settings: authorized
   🔑 FCM Token: [your-token-here]
   ⚙️ Local notifications enabled: true
   ```

2. **Verify FCM Token**: The app should generate a Firebase Cloud Messaging token
3. **Check Permission Status**: Ensure notifications are authorized

### Step 8: Test Foreground Notifications
1. Keep the app open and in foreground
2. Send a test notification from Firebase Console
3. **Expected**: Should see notification banner at top of screen
4. **If not working**: Check console logs for errors

### Step 9: Test Background Notifications
1. Put app in background (swipe up, don't close completely)
2. Send test notification from Firebase Console
3. **Expected**: Should see notification banner on lock screen
4. **If not working**: Check Background Modes in Xcode

### Step 10: Test Closed App Notifications
1. **Force close** the app completely (swipe up and swipe away)
2. Send test notification from Firebase Console
3. **Expected**: Should see notification banner on lock screen
4. **If not working**: Check entitlements and capabilities in Xcode

## 🚨 Troubleshooting

### Issue: App Crashes on Camera Access
**Solution:**
1. Check iOS Settings → Privacy & Security → Camera
2. Ensure Elsadeken has camera permission
3. Restart the app completely
4. Try camera access again

### Issue: Camera Permission Denied
**Solution:**
1. Go to iOS Settings → Privacy & Security → Camera
2. Toggle Elsadeken permission OFF and ON
3. Restart the app
4. Test camera functionality

### Issue: Photo Library Access Denied
**Solution:**
1. Go to iOS Settings → Privacy & Security → Photos
2. Ensure Elsadeken has access
3. Choose "All Photos" or "Selected Photos"
4. Restart the app

### Issue: Camera Not Opening
**Solution:**
1. Check if another app is using the camera
2. Close all background apps
3. Restart the device
4. Test camera in native Camera app first

### Issue: No Notifications Received
**Solution:**
1. Check **Settings** → **Notifications** → **Elsadeken** → **Allow Notifications** = ON
2. Verify **Alert Style** is set to "Banners" or "Alerts"
3. Check **Settings** → **Focus** → **Do Not Disturb** = OFF
4. Ensure app has notification permissions

### Issue: Background Notifications Not Working
**Solution:**
1. Verify Xcode capabilities include "Background Modes" with "Remote notifications"
2. Check "Push Notifications" capability is added
3. Ensure `Runner.entitlements` file is properly configured
4. Verify bundle identifier matches Firebase configuration

### Issue: FCM Token Not Generated
**Solution:**
1. Check console logs for Firebase initialization errors
2. Verify notification permissions are granted
3. Check Firebase configuration in `firebase_options.dart`
4. Ensure internet connection is available

## 🔍 Debug Information

### Check Permission Status
```bash
# Run with verbose logging
flutter run --verbose

# Check iOS logs in Xcode
# Window → Devices and Simulators → View Device Logs
```

### Check Notification Status
```bash
# Run with verbose logging to see notification debug info
flutter run --verbose

# Look for these specific log messages:
# 📱 Notification settings: authorized
# 🔑 FCM Token: [token-here]
# ⚙️ Local notifications enabled: true
```

### Common Error Messages
- **"Camera permission denied"** → Grant camera permission in Settings
- **"Photo library access denied"** → Grant photo permission in Settings
- **"Camera unavailable"** → Check if camera is in use by another app

### Notification Error Messages
- **"Firebase messaging not initialized"** → Check Firebase configuration
- **"Notification settings: denied"** → Grant notification permissions in Settings
- **"FCM Token: null"** → Check internet connection and Firebase setup
- **"Background notification IGNORED"** → Check local notification settings

## 📋 Testing Checklist

### Camera Functionality
- [ ] App launches without crashes
- [ ] Camera permission prompt appears
- [ ] Camera opens successfully
- [ ] Photo capture works
- [ ] Image displays in app
- [ ] No permission-related crashes

### Photo Library
- [ ] Photo library permission prompt appears
- [ ] Gallery opens successfully
- [ ] Photo selection works
- [ ] Selected image displays in app
- [ ] No access-related crashes

### Notification Functionality
- [ ] Notification permission prompt appears on first launch
- [ ] FCM token is generated successfully
- [ ] Foreground notifications display correctly
- [ ] Background notifications work when app is minimized
- [ ] Closed app notifications appear on lock screen
- [ ] Console logs show proper notification status

### Error Handling
- [ ] Permission denied messages are clear
- [ ] App doesn't crash on permission denial
- [ ] Error messages guide user to Settings
- [ ] App recovers after permission grant
- [ ] Notification errors are logged properly

## 🎯 Best Practices

### For Testers
1. **Always test on physical device** for camera functionality
2. **Grant permissions before testing** camera features
3. **Test permission denial scenarios** to ensure no crashes
4. **Verify error messages** are user-friendly
5. **Test on different iOS versions** if possible
6. **Test notifications in all app states** (foreground, background, closed)
7. **Verify FCM token generation** in console logs
8. **Test notification permissions** before sending test notifications

### For Developers
1. **Handle permission errors gracefully**
2. **Provide clear user guidance** for permission issues
3. **Test edge cases** (permission denied, camera unavailable)
4. **Implement proper error logging** for debugging
5. **Verify Firebase configuration** before testing notifications
6. **Check Xcode capabilities** are properly configured
7. **Test notification flow** in all app lifecycle states

## 🚀 Quick Test Commands

```bash
# Clean build
flutter clean && flutter pub get

# Run on iOS device
flutter run

# Run with verbose logging
flutter run --verbose

# Build release version
flutter build ios --release

# Test notification permissions (add to your code)
await FirebaseNotificationService.instance.checkNotificationPermissions();

# Get FCM token
String? token = await FirebaseNotificationService.instance.getFCMToken();
print('FCM Token: $token');
```

## 📞 Support

If you encounter persistent issues:
1. Check this guide first
2. Verify all permissions are granted
3. Test on physical iOS device
4. Check Flutter and iOS logs
5. Contact development team with error details

### Notification-Specific Support
If notifications still don't work:
1. **Check Xcode capabilities** - Ensure Push Notifications and Background Modes are added
2. **Verify entitlements** - Check `Runner.entitlements` file configuration
3. **Check Firebase Console** - Ensure app is registered and APNs certificate is valid
4. **Verify bundle identifier** - Must match exactly between Xcode and Firebase
5. **Check device settings** - Ensure notifications are enabled in iOS Settings

---

**Remember**: 
- **Camera testing** requires a physical iOS device. iOS Simulator has limited camera functionality and may not accurately represent real-world usage.
- **Notification testing** requires a physical iOS device. iOS Simulator doesn't support push notifications.
- **Always test on real devices** for both camera and notification functionality.
