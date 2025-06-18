import 'dart:io';
import 'package:f_tube/main.dart';
import 'package:dio/dio.dart';
import 'package:f_tube/utils/global.dart';

import 'package:path_provider/path_provider.dart';

class FileDownload {
  final Dio dio = getIt<Dio>();

  void startDownloading(
    String url,
    final Function onReceiveProgress,
    final Function(Response<dynamic>) onSuccess,
  ) async {
    String fileName = "Sample";
    String path = await _getFilePath(fileName);

    try {
      await dio.download(
        url,
        path,
        onReceiveProgress: (recivedBytes, totalBytes) {
          onReceiveProgress(recivedBytes, totalBytes);
        },
        deleteOnError: true,
      ).then(onSuccess);
    } catch (e) {
      print("Exception$e");
    }
  }

  Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/'); // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}$filename";
  }
}
