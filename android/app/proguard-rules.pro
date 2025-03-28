# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.plugin.editing.** { *; }

# WebView
-keep class android.webkit.** { *; }
-keep class androidx.webkit.** { *; }

# Keep external URLs and web view related classes
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Connectivity plugin
-keep class com.fluttercommunity.connectivity_plus.** { *; }

# URL Launcher plugin
-keep class io.flutter.plugins.urllauncher.** { *; }

# Additional rules to prevent common crashes
-keep class com.faylav.webview.** { *; }

# Keep JavaScript interface methods
-keepattributes JavascriptInterface
-keepattributes *Annotation*

# For enumeration classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
} 