import 'package:equatable/equatable.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class YoutubeWebviewState extends Equatable {
  final String url;
  WebViewController? controller;

  YoutubeWebviewState({
    required this.url,
    this.controller,
  });

  YoutubeWebviewState copyWith({
    String? url,
    WebViewController? controller,
  }) {
    return YoutubeWebviewState(
      url: url ?? this.url,
      controller: controller ?? this.controller,
    );
  }

  @override
  List<Object?> get props => [
        url,
        controller,
      ];
}
