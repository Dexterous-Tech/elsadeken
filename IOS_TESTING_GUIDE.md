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

### Step 2: Grant Permissions
1. Go to **Settings** → **Privacy & Security**
2. Find **Camera** and enable for **Elsadeken**
3. Find **Photos** and enable for **Elsadeken**
4. Return to the app

### Step 3: Test Camera Functionality
1. Tap the camera/profile image area
2. Select **"التقاط صورة من الكاميرا"** (Take photo from camera)
3. Grant camera permission when prompted
4. Take a photo and confirm
5. Verify image appears in the app

### Step 4: Test Photo Library
1. Tap camera/profile image area again
2. Select **"اختيار من المعرض"** (Choose from gallery)
3. Grant photo library access when prompted
4. Select an existing photo
5. Verify image appears in the app

### Step 5: Test Photo Upload Functionality
1. After selecting an image (from camera or gallery)
2. Verify the image displays correctly in the app
3. Test the upload process (if applicable)
4. Check that the image is properly uploaded to the server
5. Verify no crashes occur during the upload process

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

## 🔍 Debug Information

### Check Permission Status
```bash
# Run with verbose logging
flutter run --verbose

# Check iOS logs in Xcode
# Window → Devices and Simulators → View Device Logs
```

### Common Error Messages
- **"Camera permission denied"** → Grant camera permission in Settings
- **"Photo library access denied"** → Grant photo permission in Settings
- **"Camera unavailable"** → Check if camera is in use by another app

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

### Error Handling
- [ ] Permission denied messages are clear
- [ ] App doesn't crash on permission denial
- [ ] Error messages guide user to Settings
- [ ] App recovers after permission grant

## 🎯 Best Practices

### For Testers
1. **Always test on physical device** for camera functionality
2. **Grant permissions before testing** camera features
3. **Test permission denial scenarios** to ensure no crashes
4. **Verify error messages** are user-friendly
5. **Test on different iOS versions** if possible

### For Developers
1. **Handle permission errors gracefully**
2. **Provide clear user guidance** for permission issues
3. **Test edge cases** (permission denied, camera unavailable)
4. **Implement proper error logging** for debugging

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
```

## 📞 Support

If you encounter persistent issues:
1. Check this guide first
2. Verify all permissions are granted
3. Test on physical iOS device
4. Check Flutter and iOS logs
5. Contact development team with error details

---

**Remember**: Camera testing requires a physical iOS device. iOS Simulator has limited camera functionality and may not accurately represent real-world usage.
