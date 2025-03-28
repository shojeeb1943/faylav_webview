import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const FaylavWebViewApp());
}

class FaylavWebViewApp extends StatelessWidget {
  const FaylavWebViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faylav WebView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
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
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _initWebView();

    // Subscribe to connectivity changes
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (!mounted) return;
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Failed to check connectivity: $e');
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _hasInternet = result != ConnectivityResult.none;
    });
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

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
      ..loadRequest(Uri.parse('https://faylav.com/customer/auth/login'));
  }

  Future<void> _launchExternalUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
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
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
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
}
