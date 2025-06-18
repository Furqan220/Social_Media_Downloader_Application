class YoutubeVideoInfo {
  String? status;
  String? ownerUrl;
  String? ownerId;
  String? channelUrl;
  String? uploader;
  int? totalViews;
  String? urlId;
  String? thumbnail;
  String? description;
  int? duration;
  String? title;
  List<String>? categories;
  List<DataFormats>? dataFormats;

  YoutubeVideoInfo({
    this.status,
    this.ownerUrl,
    this.ownerId,
    this.channelUrl,
    this.uploader,
    this.totalViews,
    this.urlId,
    this.thumbnail,
    this.description,
    this.duration,
    this.title,
    this.categories,
    this.dataFormats,
  });

  YoutubeVideoInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    ownerUrl = json['ownerUrl'] ?? '';
    ownerId = json['ownerId'] ?? '';
    channelUrl = json['channelUrl'] ?? '';
    uploader = json['uploader'] ?? '';
    totalViews = json['totalViews'];
    urlId = json['urlId'] ?? '';
    thumbnail = json['thumbnail'] ?? '';
    description = json['description'] ?? '';
    duration = json['duration'];
    title = json['title'] ?? '';
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(v);
      });
    }
    if (json['dataFormats'] != null) {
      dataFormats = <DataFormats>[];
      json['dataFormats'].forEach((v) {
        dataFormats!.add(DataFormats.fromJson(v));
      });
    }
  }
}

class DataFormats {
  String? dataDownload;
  String? format;
  String? resolution;
  num? quality;
  String? filesize;
  String? filesizeApprox;
  String? ext;

  DataFormats({
    this.dataDownload,
    this.format,
    this.ext,
    this.filesize,
  });

  bool get isAudio =>
      resolution?.contains('audio only') ??
      format?.contains('audio only') ??
      false;

  DataFormats.fromJson(Map<String, dynamic> json) {
    dataDownload = json['dataDownload'] ?? '';
    format = json['format'] ?? '';
    resolution = json['resolution'] ?? '';
    quality = json['quality'] ?? '';
    ext = json['ext'] ?? '';
    filesizeApprox = json['filesize_approx'] ?? '';
    filesize = json['filesize'] ?? 0;
  }

  @override
  String toString() {
    return "url: ${dataDownload?.substring(0, 10)}  \n format: $format \n ext:  $ext \n filesize: $filesize \n filesizeApprox: $filesizeApprox \n resolution: $resolution \n quality: $quality ";
  }
}
