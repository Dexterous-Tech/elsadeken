# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep Flutter specific classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep WebSocket related classes
-keep class org.java_websocket.** { *; }
-keep class org.java_websocket.client.** { *; }
-keep class org.java_websocket.server.** { *; }

# Keep SLF4J classes (fixes the StaticLoggerBinder issue)
-keep class org.slf4j.** { *; }
-keep class org.slf4j.impl.** { *; }
-keep class org.slf4j.helpers.** { *; }
-keep class org.slf4j.spi.** { *; }
-dontwarn org.slf4j.**
-dontwarn org.slf4j.impl.**
-dontwarn org.slf4j.helpers.**
-dontwarn org.slf4j.spi.**

# Specific fix for StaticLoggerBinder
-keep class org.slf4j.impl.StaticLoggerBinder { *; }
-keep class org.slf4j.impl.StaticMDCBinder { *; }
-keep class org.slf4j.impl.StaticMarkerBinder { *; }

# Keep logging framework classes
-keep class org.apache.logging.** { *; }
-keep class org.apache.logging.log4j.** { *; }
-keep class ch.qos.logback.** { *; }
-dontwarn org.apache.logging.**
-dontwarn org.apache.logging.log4j.**
-dontwarn ch.qos.logback.**

# Keep Java logging
-keep class java.util.logging.** { *; }
-keep class sun.util.logging.** { *; }

# Keep Pusher related classes
-keep class com.pusher.** { *; }
-keep class com.pusher.client.** { *; }
-dontwarn com.pusher.**

# Keep JSON related classes
-keep class com.google.gson.** { *; }
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.google.gson.**
-dontwarn com.fasterxml.jackson.**

# Keep HTTP client classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-dontwarn okhttp3.**
-dontwarn retrofit2.**

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Keep Google Play Core libraries (fixes missing classes for deferred components)
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**

# Specific fixes for the exact missing classes mentioned in R8 error
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallException { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManager { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManagerFactory { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest$Builder { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallSessionState { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener { *; }
-keep class com.google.android.play.core.tasks.OnFailureListener { *; }
-keep class com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class com.google.android.play.core.tasks.Task { *; }

# Keep Flutter deferred components and split compatibility
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }
-keep class io.flutter.embedding.android.FlutterApplication { *; }

# Keep WebSocket channel classes
-keep class io.flutter.plugins.web_socket_channel.** { *; }
-dontwarn io.flutter.plugins.web_socket_channel.**

# General keep rules for common libraries
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep R classes
-keep class **.R$* {
    public static <fields>;
}

# Keep custom application class
-keep class com.example.elsadeken.** { *; }

# Additional rules for common issues
-keep class androidx.** { *; }
-keep class android.support.** { *; }
-dontwarn androidx.**
-dontwarn android.support.**

# Keep reflection-accessed classes
-keepattributes Signature
-keepattributes *Annotation*

# Additional rules to prevent R8 from removing needed classes
-keep class * {
    @androidx.annotation.Keep *;
}

# Keep classes that might be accessed via reflection
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Keep all classes in the app package
-keep class com.example.elsadeken.** { *; }
-keepclassmembers class com.example.elsadeken.** { *; }

# Additional safety rules for R8
# If R8 generates missing_rules.txt, add those rules here
# This prevents future missing class issues
-keep class * implements android.content.ComponentCallbacks { *; }
-keep class * implements android.content.ComponentCallbacks2 { *; }

# Keep any classes that might be referenced by Flutter plugins
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
