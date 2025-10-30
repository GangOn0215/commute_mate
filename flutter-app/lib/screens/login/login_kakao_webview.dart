import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoLoginWebView extends StatefulWidget {
  final String loginUrl;

  const KakaoLoginWebView({super.key, required this.loginUrl});

  @override
  State<KakaoLoginWebView> createState() => _KakaoLoginWebViewState();
}

class _KakaoLoginWebViewState extends State<KakaoLoginWebView> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print('페이지 시작: $url');
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            print('페이지 완료: $url');
            setState(() => isLoading = false);
          },
          // ⭐ 이 부분을 추가!
          onNavigationRequest: (request) {
            print('네비게이션 요청: ${request.url}');

            // 콜백 URL이면 페이지 로드 차단하고 code만 추출
            if (request.url.contains('/api/kakao/callback')) {
              print('콜백 URL 감지, 가로채기!');
              _handleCallback(request.url);
              return NavigationDecision.prevent; // 페이지 로드 방지
            }

            return NavigationDecision.navigate; // 다른 URL은 정상 진행
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loginUrl));
  }

  void _handleCallback(String url) {
    // URL에서 code 파라미터 추출
    final uri = Uri.parse(url);
    final code = uri.queryParameters['code'];

    if (code != null) {
      // 인가 코드를 부모 화면으로 전달
      Navigator.of(context).pop(code);
    } else {
      // 에러 처리
      Navigator.of(context).pop(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카카오 로그인'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
