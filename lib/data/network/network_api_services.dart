import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:f_tube/data/exception/app_exception.dart';
import 'package:f_tube/data/network/base_api_services.dart';
import 'package:f_tube/main.dart';
import 'package:f_tube/utils/global.dart';

class NetworkApiService extends BaseApiServices {
  final Dio dio = getIt<Dio>();

  dynamic header({String? t}) => (t == null || t == "")
      ? {
          'Content-Type': 'application/json',
        }
      : {
          "Authorization": t,
          'Content-Type': 'application/json',
        };

  @override
  Future getGetApiResponse(String url, {bool withToken = false}) async {
    dynamic responseJson;
    G.Log("method:GET : Url $url");
    try {
      Response response = await dio.get(url);

      G.Log("response status code${response.statusCode}");
      G.Log("response body${response.data}");
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(" No Internet Connection");
    } on TimeoutException {
      throw RequestTimeoutException();
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    G.Log("method: POST : Url $url \n data : $data");
    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      G.Log("response status code${response.statusCode}");
      G.Log("response body${response.data}");
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(" No Internet Connection");
    } on TimeoutException {
      throw RequestTimeoutException();
    } on DioException {
      throw FetchDataException(" No Internet Connection");
    }
    return responseJson;
  }
  

  // @override
  // Future getPatchApiResponse(String url, dynamic data,
  //     {withHeader = false}) async {
  //   dynamic responseJson;
  //   G.Log(jsonEncode(data));
  //   try {
  //     if (withHeader) {
  //       G.Log("method:PATCH : Url $url");
  //       // G.Log("headers ${header(t: AppUrl.tempApiToken(UserAuth.token))}");

  //       http.Response response = await http
  //           .patch(
  //             Uri.parse(url),
  //             body: jsonEncode(data),
  //             headers: header(
  //               t: withHeader ? SessionController().user.accessToken : null,
  //             ),
  //           )
  //           .timeout(const Duration(seconds: 10));

  //       responseJson = returnResponse(response);
  //       G.Log("response statusCode ${response.statusCode}");
  //       // G.Log(response.statusCode);
  //     } else {
  //       G.Log("api Url $url");

  //       http.Response response = await http.post(Uri.parse(url),
  //           body: jsonEncode(data), headers: header());
  //       responseJson = returnResponse(response);
  //     }
  //   } on SocketException {
  //     throw FetchDataException(" No Internet Connection");
  //   } on TimeoutException {
  //     throw RequestTimeoutException();
  //   } on SessionExpiredException {
  //     handleSessionExpired();
  //   } on UnauthorizedException {
  //     handleSessionExpired();
  //   }

  //   return responseJson;
  // }

  // @override
  // Future getDeleteApiResponse(String url,
  //     {dynamic data, withHeader = false}) async {
  //   dynamic responseJson;

  //   try {
  //     if (withHeader) {
  //       http.Response response = await http
  //           .delete(
  //             Uri.parse(url),
  //             body: data != null ? jsonEncode(data) : null,
  //             headers: header(
  //               t: withHeader ? SessionController().user.accessToken : null,
  //             ),
  //           )
  //           .timeout(const Duration(seconds: 10));

  //       responseJson = returnResponse(response);
  //     } else {
  //       http.Response response = await http.post(Uri.parse(url), body: data);
  //       responseJson = returnResponse(response);
  //     }
  //   } on SocketException {
  //     throw FetchDataException("No Internet Connection");
  //   } on TimeoutException {
  //     throw RequestTimeoutException();
  //   } on SessionExpiredException {
  //     handleSessionExpired();
  //   } on UnauthorizedException {
  //     handleSessionExpired();
  //   }

  //   return responseJson;
  // }

  // @override
  // Future getPostMulitpartApiResponse(String url, Map<String, String> data,
  //     {List<File>? files, String key = 'profile', withHeader = false}) async {
  //   dynamic responseJson;
  //   var headers = header();
  //   // var headers =
  //   //     header(t: withHeader ? AppUrl.tempApiToken(UserAuth.token) : null);

  //   G.Log("api Url $url");
  //   G.Log("api headers $headers");

  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(url));

  //     if (data != {}) {
  //       request.fields.addAll(data);
  //     }

  //     if (files != null) {
  //       for (var element in files) {
  //         request.files
  //             .add(await http.MultipartFile.fromPath(key, element.path));
  //       }
  //     }
  //     request.headers.addAll(headers);

  //     http.StreamedResponse response =
  //         await request.send().timeout(const Duration(seconds: 10));

  //     G.Log("response statusCode ${response.statusCode}");
  //     responseJson = await returnStreamedResponse(response);
  //   } on SocketException {
  //     throw FetchDataException(" No Internet Connection");
  //   } on TimeoutException {
  //     throw RequestTimeoutException();
  //   } on SessionExpiredException {
  //     handleSessionExpired();
  //   } on UnauthorizedException {
  //     handleSessionExpired();
  //   }

  //   return responseJson;
  // }

  // dynamic returnStreamedResponse(http.StreamedResponse response) async {
  //   switch (response.statusCode) {
  //     case 200:
  //       return jsonDecode(await response.stream.bytesToString());
  //     case 201:
  //       return jsonDecode(await response.stream.bytesToString());
  //     case 400:
  //       throw BadRequestException(await response.stream.bytesToString());
  //     case 404:
  //       throw BadRequestException(await response.stream.bytesToString());
  //     case 401:
  //       throw UnauthorizedException(await response.stream.bytesToString());
  //     case 500:
  //       throw BadRequestException(await response.stream.bytesToString());
  //     default:
  //       throw FetchDataException(
  //           "Error occured while communicating with server with status code of ${response.statusCode}");
  //   }
  // }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case HttpStatus.ok:
        return response.data;
      case HttpStatus.created:
        return response.data;
      case HttpStatus.accepted:
        return response.data;
      case HttpStatus.badRequest:
        throw BadRequestException(getErrorMessage(response));
      case HttpStatus.unprocessableEntity:
        throw BadRequestException(getErrorMessage(response));
      case HttpStatus.notFound:
        throw UnExpectedError(getErrorMessage(response));
      case 440:
        throw SessionExpiredException(getErrorMessage(response));
      case HttpStatus.unauthorized:
        throw UnauthorizedException(getErrorMessage(response));
      case HttpStatus.internalServerError:
        throw BadRequestException(getErrorMessage(response));
      case HttpStatus.movedTemporarily:
        throw BadRequestException(getErrorMessage(response));
      default:
        throw FetchDataException(
            "Error occured while communicating with server with status code of ${response.statusCode}");
    }
  }

  String getErrorMessage(response) {
    try {
      G.Log(response.statusCode);
      final _body = jsonDecode(response.body.toString());
      G.Log(_body);
      return _body['message'] as String? ?? response.body.toString();
    } on Exception catch (e) {
      G.Log("error in getting error message $e");
      return '';
    }
  }
}
