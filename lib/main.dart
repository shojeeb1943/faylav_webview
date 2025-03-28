import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

import 'splash_screen.dart';
import 'privacy_policy.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FaylavWebViewApp());
}

class FaylavWebViewApp extends StatelessWidget {
  const FaylavWebViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faylav WebView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF3399), // Faylav pink color
          primary: const Color(0xFFFF3399),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasInternet = true;
  bool _webViewCreated = false;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();

    // Initialize WebView first before checking connectivity
    _initWebView();

    // Initialize connectivity after WebView
    _initConnectivity();

    // Subscribe to connectivity changes with try/catch for safety
    try {
      _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch (e) {
      debugPrint('Failed to initialize connectivity listener: $e');
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (!mounted) return;
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Failed to check connectivity: $e');
      // Set default state to assume internet is available to prevent crashes
      if (mounted) {
        setState(() {
          _hasInternet = true;
        });
      }
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (!mounted) return;

    setState(() {
      _hasInternet = result != ConnectivityResult.none;

      // If we now have internet and the WebView is created, reload it
      if (_hasInternet && _webViewCreated) {
        _controller.reload();
      }
    });
  }

  void _initWebView() {
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _isLoading = progress < 100;
                });
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _webViewCreated = true;
                });
              }
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (WebResourceError error) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
              debugPrint(
                  'WebView error: ${error.description} (${error.errorCode})');
              // Handle error - maybe show a dialog or retry
            },
            onNavigationRequest: (NavigationRequest request) {
              final url = request.url;
              debugPrint('Navigation request to: $url');

              // Allow navigation within the same domain
              if (url.contains('faylav.com')) {
                return NavigationDecision.navigate;
              }

              // Open external links in browser
              _launchExternalUrl(url);
              return NavigationDecision.prevent;
            },
          ),
        )
        ..setUserAgent('Mozilla/5.0 (Android) FaylavApp/1.0.0');

      // Load the URL separately with error handling
      _loadInitialUrl();
    } catch (e) {
      debugPrint('Error initializing WebView controller: $e');
    }
  }

  void _loadInitialUrl() {
    try {
      // Delay loading the initial URL slightly to ensure the controller is properly initialized
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        final Uri uri = Uri.parse('https://faylav.com/customer/auth/login');
        _controller.loadRequest(uri).then((_) {
          debugPrint('URL load request sent successfully');
        }).catchError((error) {
          debugPrint('Failed to load URL: $error');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            _showErrorDialog(
                "Failed to load the website. Please check your internet connection and try again.");
          }
        });
      });
    } catch (e) {
      debugPrint('Exception while loading URL: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(
            "An error occurred while loading the website. Please try again later.");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Connection Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadInitialUrl(); // Try again
              },
              child: const Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchExternalUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      final bool launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (!_hasInternet) {
          Navigator.of(context).pop();
          return;
        }

        final canGoBack = await _controller.canGoBack();
        if (canGoBack) {
          _controller.goBack();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              if (_hasInternet) WebViewWidget(controller: _controller),
              if (!_hasInternet) _buildNoInternetView(),
              if (_isLoading && _hasInternet)
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF3399), // Faylav pink color
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFF3399),
          foregroundColor: Colors.white,
          mini: true,
          child: const Icon(Icons.menu),
          onPressed: () {
            _showOptionsMenu(context);
          },
        ),
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.signal_wifi_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please check your connection and try again',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              await _initConnectivity();
              if (_hasInternet) {
                _controller.reload();
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.refresh, color: Color(0xFFFF3399)),
                title: const Text('Reload Page'),
                onTap: () {
                  Navigator.pop(context);
                  _controller.reload();
                },
              ),
              ListTile(
                leading: const Icon(Icons.policy, color: Color(0xFFFF3399)),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Color(0xFFFF3399)),
                title: const Text('Go to Home'),
                onTap: () {
                  Navigator.pop(context);
                  _controller.loadRequest(
                      Uri.parse('https://faylav.com/customer/auth/login'));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
