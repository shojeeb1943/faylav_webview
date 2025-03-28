# Faylav WebView

A simple Flutter WebView application that provides access to the Faylav website in a mobile app.

## Features

- **Full-Screen WebView**: Loads the Faylav website inside a WebView
- **Session Persistence**: Maintains login sessions and preserves cookies
- **Back Navigation Handling**: Properly handles back button navigation
- **External Links Handling**: Opens external links in the device's browser
- **Connectivity Monitoring**: Shows a friendly message when internet connection is lost
- **Clean UI**: Minimal interface focused on the web content

## Technical Details

### Core Dependencies

- **webview_flutter**: For embedding the web content
- **connectivity_plus**: For monitoring internet connectivity
- **url_launcher**: For opening external links in the device's browser

### Requirements

- Android SDK 20+
- Flutter 3.0+
- Dart 2.17+

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Connect a device or emulator
4. Run `flutter run` to start the app

## Building for Release

To build a release APK for testing:

```
flutter build apk --release
```

The APK will be created at:
`[project]/build/app/outputs/flutter-apk/app-release.apk`

To build a release app bundle for Google Play Store:

```
flutter build appbundle
```

The app bundle will be created at:
`[project]/build/app/outputs/bundle/release/app-release.aab`

## Play Store Publishing Checklist

Before publishing to the Play Store, make sure to:

1. **Create a Signing Key**:
   ```
   keytool -genkey -v -keystore faylav-keystore.jks -alias faylav -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Update the `android/key.properties` file** with your actual keystore information

3. **Generate and test a signed release build**:
   ```
   flutter build appbundle --release
   ```

4. **Prepare Play Store assets**:
   - App icon (512x512px PNG)
   - Feature graphic (1024x500px PNG)
   - Screenshots (at least 2)
   - Privacy policy URL
   - App description and contact information

5. **Complete content rating questionnaire** in the Play Console

6. **Set appropriate app pricing and distribution** options

7. **Submit for review**

## Privacy and Security

- Only requires INTERNET permission to function
- No user data is collected by the app itself
- All data handling follows the privacy policy of Faylav website
