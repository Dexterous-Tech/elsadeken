# iOS Notification Setup Guide

## ✅ Code Changes Applied

The following code changes have been automatically applied to fix iOS notification issues:

1. **Info.plist** - Added background modes for remote notifications
2. **Runner.entitlements** - Created entitlements file for push notifications
3. **AppDelegate.swift** - Enhanced with Firebase and notification handling
4. **FirebaseNotificationService** - Added debugging methods

## 🔧 Manual Xcode Configuration Required

After the code changes, you MUST manually configure these settings in Xcode:

### Step 1: Open Project in Xcode
```bash
cd ios
open Runner.xcworkspace
```

### Step 2: Add Push Notifications Capability
1. Select your **Runner** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **Push Notifications**

### Step 3: Add Background Modes Capability
1. Click **+ Capability** again
2. Add **Background Modes**
3. Check these options:
   - ✅ **Remote notifications**
   - ✅ **Background processing**

### Step 4: Verify Bundle Identifier
1. In **Signing & Capabilities**
2. Ensure **Bundle Identifier** matches your Firebase configuration
3. Current: `com.example.elsadeken`
4. **Important**: Update this to match your actual bundle ID

### Step 5: Update Entitlements File
1. In **Signing & Capabilities**
2. Under **Entitlements**, ensure `Runner.entitlements` is selected
3. Verify these keys are present:
   - `aps-environment` = `development` (change to `production` for App Store)
   - `com.apple.developer.usernotifications.time-sensitive` = `true`

## 🧪 Testing Notifications

### Test 1: App in Foreground
1. Run app on real iOS device
2. Send test notification from Firebase Console
3. Should see notification banner

### Test 2: App in Background
1. Put app in background (don't close completely)
2. Send test notification
3. Should see notification banner

### Test 3: App Closed
1. Force close the app completely
2. Send test notification
3. Should see notification banner

### Test 4: Check Console Logs
Look for these log messages:
```
📱 Notification settings: authorized
🔑 FCM Token: [your-token-here]
⚙️ Local notifications enabled: true
```

## 🚨 Common Issues & Solutions

### Issue: "No notifications received"
**Solution**: Check device settings
- Settings → Notifications → Your App → Allow Notifications = ON
- Settings → Focus → Do Not Disturb = OFF

### Issue: "Background notifications not working"
**Solution**: Verify Xcode capabilities
- Background Modes must include "Remote notifications"
- Push Notifications capability must be added

### Issue: "Firebase token not generated"
**Solution**: Check permissions
- App must request notification permissions
- User must grant permissions

### Issue: "Notifications work in simulator but not device"
**Solution**: Use real device
- iOS Simulator doesn't support push notifications
- Always test on physical iOS device

## 📱 Device-Specific Settings

### iOS 15+ Focus Modes
- Check if Focus mode is blocking notifications
- Settings → Focus → [Mode Name] → Apps → Ensure your app is allowed

### Do Not Disturb
- Ensure Do Not Disturb is not active
- Check scheduled Do Not Disturb times

### Notification Style
- Settings → Notifications → Your App → Alert Style
- Should be set to "Banners" or "Alerts"

## 🔍 Debugging Commands

Add this to your Flutter code to debug:

```dart
// Check notification permissions
await FirebaseNotificationService.instance.checkNotificationPermissions();

// Get FCM token
String? token = await FirebaseNotificationService.instance.getFCMToken();
print('FCM Token: $token');

// Check if notifications are enabled locally
bool enabled = await FirebaseNotificationService.instance.isNotificationEnabled();
print('Local notifications enabled: $enabled');
```

## 📋 Checklist

- [ ] Code changes applied ✅
- [ ] Xcode project opened ✅
- [ ] Push Notifications capability added ✅
- [ ] Background Modes capability added ✅
- [ ] Bundle identifier verified ✅
- [ ] Entitlements file configured ✅
- [ ] App built and installed on device ✅
- [ ] Notification permissions granted ✅
- [ ] Test notification sent ✅
- [ ] Notifications working in all app states ✅

## 🆘 Still Having Issues?

If notifications still don't work after following this guide:

1. **Check Firebase Console** - Ensure your app is registered
2. **Verify APNs Certificate** - Check Firebase project settings
3. **Test with Simple Notification** - Use Firebase Console test message
4. **Check Device Logs** - Look for Firebase/notification errors
5. **Verify Bundle ID** - Must match exactly between Xcode and Firebase

## 📞 Support

For additional help:
- Check Firebase documentation
- Review iOS push notification guidelines
- Ensure you're testing on a real device, not simulator
