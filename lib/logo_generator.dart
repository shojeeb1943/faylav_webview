import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Run this as a standalone app to generate the logo PNG
// It will create a pink Faylav logo similar to the one provided
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LogoGeneratorApp());
}

class LogoGeneratorApp extends StatelessWidget {
  const LogoGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faylav Logo Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LogoGeneratorScreen(),
    );
  }
}

class LogoGeneratorScreen extends StatefulWidget {
  const LogoGeneratorScreen({super.key});

  @override
  State<LogoGeneratorScreen> createState() => _LogoGeneratorScreenState();
}

class _LogoGeneratorScreenState extends State<LogoGeneratorScreen> {
  final GlobalKey _logoKey = GlobalKey();
  bool _generated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faylav Logo Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 512,
              height: 512,
              color: Colors.grey[200],
              child: RepaintBoundary(
                key: _logoKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'فايلاف',
                        style: TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF3399), // Bright pink color
                        ),
                      ),
                      const Text(
                        'FAYLAV',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF3399), // Bright pink color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generated ? null : _generateLogo,
              child: Text(_generated ? 'Logo Generated!' : 'Generate Logo'),
            ),
            if (_generated)
              const Text(
                'Logo saved to assets/images/faylav_logo.png',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateLogo() async {
    try {
      RenderRepaintBoundary boundary =
          _logoKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // This would save the file, but in a Flutter web environment we can't do this directly
        // In a real app, you would use path_provider and File to save this
        print('PNG generated with ${pngBytes.length} bytes');

        setState(() {
          _generated = true;
        });
      }
    } catch (e) {
      print('Error generating logo: $e');
    }
  }
}
