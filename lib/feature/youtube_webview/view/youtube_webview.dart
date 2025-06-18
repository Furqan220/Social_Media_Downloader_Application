import 'package:f_tube/config/basic_exports.dart';
import 'package:f_tube/data/response/api_response.dart';
import 'package:f_tube/data/response/download_api_response.dart';
import 'package:f_tube/feature/youtube_webview/provider/youtube_webview_provider.dart';
import 'package:f_tube/model/youtube_video_info_model.dart';
import 'package:f_tube/utils/global.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWebview extends ConsumerStatefulWidget {
  const YoutubeWebview({super.key});

  @override
  ConsumerState<YoutubeWebview> createState() => _YoutubeWebviewState();
}

class _YoutubeWebviewState extends ConsumerState<YoutubeWebview> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(youtubeWebviewProvider.notifier).initializeWebView());
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(youtubeWebviewProvider);
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            if (await provider.controller?.canGoBack() ?? false) {
              provider.controller?.goBack();
              return; // don't pop the route
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              provider.controller != null
                  ? WebViewWidget(
                      controller: provider.controller!,
                    )
                  : SizedBox(),
              downloadProgressBar(),
            ],
          ),
          floatingActionButton: downloadButton(
            context,
            provider.videoInfoApi?.status,
          ),
        ),
      ),
    );
  }

  downloadProgressBar() {
    final provider = ref.watch(youtubeWebviewProvider);
    final notifier = ref.read(youtubeWebviewProvider.notifier);

    return switch (provider.downloadApiResponse?.status) {
      null => SizedBox(),
      DownloadStatus.error => Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.error_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    "Download error has occured",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () => notifier.downloadVideo(context),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      DownloadStatus.downloaded => Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your File Downloaded",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              LinearProgressIndicator(
                value: 10,
                backgroundColor: Colors.grey,
                color: Colors.green,
                minHeight: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      DownloadStatus.downloading => Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Downloading",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              LinearProgressIndicator(
                value: provider.downloadApiResponse?.progress ?? 0.0,
                backgroundColor: Colors.grey,
                color: Colors.green,
                minHeight: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "${((provider.downloadApiResponse?.progress ?? 0.0) * 100).toInt().toString()} %",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
    };
  }

  downloadButton(__, Status? status) {
    return switch (status) {
      Status.loading => Container(
          height: 50,
          padding: EdgeInsets.all(
            10,
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      Status.error => GestureDetector(
          onTap: () => ref.read(youtubeWebviewProvider.notifier).getVideoInfo(),
          child: Container(
            height: 50,
            padding: EdgeInsets.all(
              10,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ),
      Status.success => GestureDetector(
          onTap: () => showDownloadOptions(__),
          child: Container(
            margin: EdgeInsets.only(
              bottom: 40,
              right: 10,
            ),
            padding: EdgeInsets.all(
              10,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "Download",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      null => SizedBox(),
    };
  }

  showDownloadOptions(__) {
    final provider = ref.watch(youtubeWebviewProvider);
    final notifier = ref.read(youtubeWebviewProvider.notifier);
    final dataFormats = provider.videoInfoApi?.data?.dataFormats;
    return showModalBottomSheet(
      context: __,
      builder: (___) => SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 10,
          ),
          child: Column(
            children: [
              Text(
                'Formats',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      dataFormats?.length ?? 0,
                      (index) {
                        final DataFormats? dateFormat = dataFormats?[index];
                        G.Log("dateFormat ${dateFormat.toString()}");
                        return formatTile(
                          format: dateFormat,
                          i: index,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  notifier.downloadVideo(context);
                },
                child: Text("Downloads"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  formatTile({
    required int i,
    DataFormats? format,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            format?.isAudio == true
                ? Icons.music_note_rounded
                : Icons.video_collection_sharp,
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 50,
            child: Text(
              format?.ext.toString() ?? '',
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 150,
            child: Text(
              format?.format.toString() ?? '',
              style: TextStyle(
                fontSize: 11,
              ),
            ),
          ),
          Spacer(),
          Text(
            format?.filesize.toString() ?? '',
          ),
          SizedBox(
            width: 10,
          ),
          Consumer(builder: (_, ref, c) {
            final provider = ref.watch(youtubeWebviewProvider);
            final notifier = ref.read(youtubeWebviewProvider.notifier);

            final isSelected = provider.selectedFormatIndex == i;
            return GestureDetector(
              onTap: () => notifier.setSelectedFormatIndex(i),
              child: Container(
                height: 20,
                width: 20,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.red : Colors.grey,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: isSelected ? Colors.red : Colors.transparent,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
