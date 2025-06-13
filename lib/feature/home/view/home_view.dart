import 'package:f_tube/config/basic_exports.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteName.youtubeWebview),
            icon: Icon(
              Icons.play_circle,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
