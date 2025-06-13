import 'package:dio/dio.dart';
import 'package:f_tube/config/app_url.dart';
import 'package:f_tube/config/basic_exports.dart';
import 'package:f_tube/data/network/network_api_services.dart';
import 'package:f_tube/repositories/youtube_downloader_repository.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
void main() {
  serviceLocator();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: RouteName.home,
    );
  }
}

void serviceLocator() {
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppUrl.baseUrl, // Replace with correct server IP
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    ),
  );
  getIt.registerLazySingleton<NetworkApiService>(() => NetworkApiService());
  getIt.registerLazySingleton<YoutubeDownloaderRepository>(
      () => YoutubeDownloaderRepository());
  // getIt.registerLazySingleton<MoviesRepository>(() => MoviesApiRepository());
}
