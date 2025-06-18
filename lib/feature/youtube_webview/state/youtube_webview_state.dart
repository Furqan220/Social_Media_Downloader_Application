import 'package:equatable/equatable.dart';
import 'package:f_tube/data/response/api_response.dart';
import 'package:f_tube/data/response/download_api_response.dart';
import 'package:f_tube/model/youtube_video_info_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class YoutubeWebviewState extends Equatable {
  final String url;
  WebViewController? controller;
  ApiResponse<YoutubeVideoInfo>? videoInfoApi;
  DownloadApiResponse? downloadApiResponse;
  int? selectedFormatIndex;

  YoutubeWebviewState({
    required this.url,
    this.controller,
    this.downloadApiResponse,
    this.videoInfoApi,
    this.selectedFormatIndex,
  });

  YoutubeWebviewState copyWith({
    String? url,
    WebViewController? controller,
    dynamic videoInfoApi,
    dynamic downloadApiResponse,
    dynamic selectedFormatIndex,
  }) {
    return YoutubeWebviewState(
      url: url ?? this.url,
      controller: controller ?? this.controller,
      selectedFormatIndex: selectedFormatIndex == 'null'
          ? null
          : selectedFormatIndex ?? this.selectedFormatIndex,
      videoInfoApi:
          videoInfoApi == 'null' ? null : videoInfoApi ?? this.videoInfoApi,
      downloadApiResponse: downloadApiResponse == 'null'
          ? null
          : downloadApiResponse ?? this.downloadApiResponse,
    );
  }

  @override
  List<Object?> get props => [
        url,
        controller,
      ];
}
