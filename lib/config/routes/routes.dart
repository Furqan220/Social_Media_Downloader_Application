import 'package:f_tube/config/routes/route_name.dart';
import 'package:f_tube/feature/home/view/home_view.dart';
import 'package:f_tube/feature/youtube_webview/view/youtube_webview.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<MaterialPageRoute>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(
          builder: (context) => HomeView(),
        );
      case RouteName.youtubeWebview:
        return MaterialPageRoute(
          builder: (context) => YoutubeWebview(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text("No Route Defined"),
            ),
          ),
        );
    }
  }
}
