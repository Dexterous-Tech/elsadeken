import Flutter
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure Firebase
    FirebaseApp.configure()
    
    // Set messaging delegate
    Messaging.messaging().delegate = self
    
    // Request authorization for notifications
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { granted, error in
        if let error = error {
          print("❌ Authorization error: \(error.localizedDescription)")
        } else {
          print("✅ Authorization granted: \(granted)")
        }
      }
    )
    
    // Register for remote notifications
    application.registerForRemoteNotifications()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle receiving remote notifications (background and terminated states)
  override func application(_ application: UIApplication,
                           didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                           fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Pass to Firebase to handle
    super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }
  
  // Handle APNs registration success - CRITICAL for iOS push notifications
  override func application(_ application: UIApplication,
                           didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("✅ APNs device token received")
    
    // Pass device token to Firebase
    Messaging.messaging().apnsToken = deviceToken
    
    // Convert device token to string for debugging
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("Device Token: \(token)")
  }
  
  // Handle APNs registration failure
  override func application(_ application: UIApplication,
                           didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
  }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("🔥 Firebase FCM Token: \(String(describing: fcmToken))")
    
    // Note: The FCM token is automatically sent to Firebase Cloud Messaging servers
    // You should log this token and potentially send it to your backend
    
    // Handle token refresh if needed
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Handle notifications when app is in foreground
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    print("📱 Received notification in foreground: \(userInfo)")
    
    // Allow notifications to show even when app is in foreground
    // The Flutter app will handle displaying the notification via flutter_local_notifications
    completionHandler([[.alert, .sound, .badge]])
  }
  
  // Handle notification tap (when user taps on notification)
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print("👆 User tapped notification: \(userInfo)")
    
    // Handle notification tap - Firebase will handle the navigation via onMessageOpenedApp
    completionHandler()
  }
}
