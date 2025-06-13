import 'package:f_tube/config/app_url.dart';
import 'package:f_tube/data/network/base_api_services.dart';
import 'package:f_tube/data/network/network_api_services.dart';
import 'package:f_tube/main.dart';
import 'package:f_tube/utils/global.dart';

class YoutubeDownloaderRepository {
  final BaseApiServices apiServices = getIt<NetworkApiService>();

  Future<dynamic> getVideoDetails(url) async {
    try {
      final response = await apiServices
          .getPostApiResponse(AppUrl.youtubeVideoDetails, {'url': url});
      return response['data'];
    } on Exception catch (e) {
      G.Log(e);
      rethrow;
    }
  }
}
