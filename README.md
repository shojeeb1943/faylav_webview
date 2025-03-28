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

To build a release APK for Google Play Store:

```
flutter build appbundle
```

The app bundle will be created at:
`[project]/build/app/outputs/bundle/release/app-release.aab`

## Privacy and Security

- Only requires INTERNET permission to function
- No user data is collected by the app itself
- All data handling follows the privacy policy of Faylav website
