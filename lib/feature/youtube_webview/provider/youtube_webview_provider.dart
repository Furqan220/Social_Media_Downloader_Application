import 'dart:developer';
import 'package:f_tube/config/basic_exports.dart';
import 'package:f_tube/data/network/file_downloader_services.dart';
import 'package:f_tube/data/response/api_response.dart';
import 'package:f_tube/data/response/download_api_response.dart';
import 'package:f_tube/feature/youtube_webview/state/youtube_webview_state.dart';
import 'package:f_tube/main.dart';
import 'package:f_tube/model/youtube_video_info_model.dart';
import 'package:f_tube/repositories/youtube_downloader_repository.dart';
import 'package:f_tube/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWebviewProvider extends StateNotifier<YoutubeWebviewState> {
  YoutubeWebviewProvider(super.state);
  final YoutubeDownloaderRepository repo = getIt<YoutubeDownloaderRepository>();
  final FileDownload fileDownload = getIt<FileDownload>();

  void setGetVideoInfoApi(ApiResponse<YoutubeVideoInfo>? videoInfoApi) {
    if (videoInfoApi?.status == Status.loading) {
      state = state.copyWith(
        videoInfoApi: videoInfoApi,
        downloadApiResponse: 'null',
        selectedFormatIndex: 'null',
      );
    } else {
      state = state.copyWith(videoInfoApi: videoInfoApi);
    }
  }

  void setSelectedFormatIndex(int? selectedIndex) {
    if (selectedIndex == state.selectedFormatIndex) {
      state = state.copyWith(selectedFormatIndex: 'null');
    } else {
      state = state.copyWith(selectedFormatIndex: selectedIndex);
    }
  }

  void setDownloadVideoApi(DownloadApiResponse? downloadApi) {
    downloadApi.toString();
    state = state.copyWith(downloadApiResponse: downloadApi);
  }

  String get downloadUrl =>
      state.videoInfoApi?.data?.dataFormats?[state.selectedFormatIndex ?? 0]
          .dataDownload ??
      '';

  void cancelOrRemoveVideoInfo() {
    state = state.copyWith(
      videoInfoApi: 'null',
      downloadApiResponse: 'null',
    );
  }

  static Future<bool> _permissionRequest() async {
    PermissionStatus result;
    result = await Permission.storage.request();
    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void setUrl(String? url) {
    if (state.url != url) {
      log('New Url : $url');
      if (url != state.url) {
        state = state.copyWith(
          url: url,
        );
        checkForVideoDownloadDetails();
      }
    }
  }

  Future checkForVideoDownloadDetails() async {
    if (state.url.startsWith('https://m.youtube.com/watch')) {
      getVideoInfo();
    } else if (state.url == 'https://m.youtube.com/' &&
        state.videoInfoApi != null) {
      cancelOrRemoveVideoInfo();
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

  // Api Functions
  void getVideoInfo() {
    setGetVideoInfoApi(ApiResponse.loading());
    repo
        .getVideoDetails(state.url)
        .then(
          (info) => setGetVideoInfoApi(
            ApiResponse.completed(
              info,
            ),
          ),
        )
        .onError(
      (e, _) {
        G.Log(e);
        setGetVideoInfoApi(
          ApiResponse.error(
            e.toString(),
          ),
        );
      },
    );
  }

  void downloadVideo(context) async {
    bool result = await _permissionRequest();
    if (result) {
      if (downloadUrl.isEmpty) return;
      setDownloadVideoApi(DownloadApiResponse.dowloading(0.0));
      fileDownload.startDownloading(
        downloadUrl,
        (recivedBytes, totalBytes) => setDownloadVideoApi(
          DownloadApiResponse.dowloading(
            recivedBytes / totalBytes,
          ),
        ),
        (_) {
          G.Log(_);
          setDownloadVideoApi(
            DownloadApiResponse.success(_.toString()),
          );
        },
      );
    } else {
      print("No permission to read and write.");
    }
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
