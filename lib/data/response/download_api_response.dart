enum DownloadStatus { downloading, downloaded, error }

class DownloadApiResponse<T> {
  DownloadStatus? status;
  double? progress;
  String? message;

  DownloadApiResponse(this.status, this.progress, this.message);

  DownloadApiResponse.dowloading([this.progress])
      : status = DownloadStatus.downloading;
  DownloadApiResponse.success([this.message])
      : status = DownloadStatus.downloaded;
  DownloadApiResponse.error([this.message]) : status = DownloadStatus.error;

  @override
  String toString() {
    return "DownloadStatus : $status \n Message : $message  \n Progress : $progress";
  }
}
