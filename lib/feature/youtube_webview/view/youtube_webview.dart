import 'package:f_tube/config/basic_exports.dart';
import 'package:f_tube/feature/youtube_webview/provider/youtube_webview_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWebview extends ConsumerStatefulWidget {
  const YoutubeWebview({super.key});

  @override
  ConsumerState<YoutubeWebview> createState() => _YoutubeWebviewState();
}

class _YoutubeWebviewState extends ConsumerState<YoutubeWebview> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(youtubeWebviewProvider.notifier).initializeWebView());
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(youtubeWebviewProvider);
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            if (await provider.controller?.canGoBack() ?? false) {
              provider.controller?.goBack();
              return; // don't pop the route
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: Scaffold(
          body: provider.controller != null
              ? WebViewWidget(
                  controller: provider.controller!,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
