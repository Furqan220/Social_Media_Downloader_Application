abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getPostApiResponse(String url, dynamic data);
  // Future<dynamic> getPatchApiResponse(String url, dynamic data,
  //     {withHeader = false});

  // Future<dynamic> getDeleteApiResponse(
  //   String url, {
  //   dynamic data,
  //   withHeader = false,
  // });

  // Future<dynamic> getPostMulitpartApiResponse(
  //   String url,
  //   Map<String, String> data, {
  //   List<File>? files,
  //   String key,
  //   withHeader = false,
  // });
}
