# Building a Signed APK for Faylav WebView

This document outlines the process of building a properly signed APK for the Faylav WebView app.

## Step 1: Generate a Keystore

On Windows, run the included batch script to generate a keystore file:

```
generate_keystore.bat
```

This script will:
1. Create a keystore file (`faylav-keystore.jks`)
2. Move it to the `android/app/` directory
3. Create a `key.properties` file with the correct values

## Step 2: Build the APK

### Debug Build (for testing)

```
flutter build apk --debug
```

### Release Build (for Play Store)

```
flutter build apk --release
```

Or for App Bundle:

```
flutter build appbundle
```

## Step 3: Testing the APK

Install the generated APK on your device:

```
flutter install
```

Or directly install the APK file:

```
adb install build\app\outputs\flutter-apk\app-release.apk
```

## Common Issues and Solutions

### App Crashing on Launch

If the app crashes immediately upon opening:

1. **Check WebView Implementation**: 
   - Ensure the WebView is properly initialized
   - Make sure you have internet permissions in AndroidManifest.xml
   
2. **Check Connectivity Plugin**:
   - Verify connectivity_plus is initialized properly
   - Handle exceptions from connectivity checking

3. **Check ProGuard Rules**:
   - Make sure no important classes are being obfuscated

4. **Debug with Logcat**:
   - Run `adb logcat` while launching the app to see error messages

### Debugging Crashes

To get detailed crash reports:

```
adb logcat *:E
```

## Publishing to Play Store

After a successful build, you can upload the AAB file to the Play Store:

1. Go to Google Play Console
2. Create a new app or select your existing app
3. Navigate to Production > Create Release
4. Upload the AAB file from `build/app/outputs/bundle/release/app-release.aab`
5. Complete the listing information
6. Submit for review 