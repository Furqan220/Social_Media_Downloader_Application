import 'dart:developer';
import 'package:f_tube/config/basic_exports.dart';
import 'package:f_tube/feature/youtube_webview/state/youtube_webview_state.dart';
import 'package:f_tube/main.dart';
import 'package:f_tube/repositories/youtube_downloader_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWebviewProvider extends StateNotifier<YoutubeWebviewState> {
  YoutubeWebviewProvider(super.state);
  final YoutubeDownloaderRepository repo = getIt<YoutubeDownloaderRepository>();

  void setUrl(String? url) {
    if (state.url != url) {
      log('New Url : $url');
      state = state.copyWith(
        url: url,
      );
      checkForVideoDownloadDetails();
    }
  }

  Future checkForVideoDownloadDetails() async {
    if (state.url.startsWith('https://m.youtube.com/watch')) {
      repo.getVideoDetails(state.url);
    }
  }

  initializeWebView() {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("onProgress ==>$progress");
          },
          onPageStarted: (String url) {
            print("onPageStarted ==>$url");
            setUrl(url);
          },
          onUrlChange: (change) => setUrl(change.url),
          onPageFinished: (String url) => print("onPageFinished ==>$url"),
          onHttpError: (HttpResponseError error) =>
              print("onHttpError ==>$error"),
          onWebResourceError: (WebResourceError error) =>
              print("onWebResourceError ==>$error"),

          // onNavigationRequest: (NavigationRequest request) {
          //   print("onNavigationRequest ==>${request.url}");
          // if (request.url.startsWith('https://www.youtube.com/')) {
          //   return NavigationDecision.prevent;
          // }
          //   return NavigationDecision.navigate;
          // },
        ),
      );

    state = state.copyWith(controller: controller);
    state.controller?.loadRequest(
      Uri.parse(
        'https://www.youtube.com',
      ),
    );
  }
}

final StateNotifierProvider<YoutubeWebviewProvider, YoutubeWebviewState>
    youtubeWebviewProvider =
    StateNotifierProvider<YoutubeWebviewProvider, YoutubeWebviewState>(
  (ref) => YoutubeWebviewProvider(
    YoutubeWebviewState(
      url: 'https://www.youtube.com',
    ),
  ),
);
