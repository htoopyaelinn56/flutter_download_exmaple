// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart' show CancelToken;

class DownloadModel {
  final bool downloading;
  final double progress;
  final String received;
  final CancelToken cancelToken;
  const DownloadModel({
    required this.downloading,
    required this.progress,
    required this.received,
    required this.cancelToken,
  });

  DownloadModel copyWith({
    bool? downloading,
    double? progress,
    String? received,
    CancelToken? cancelToken,
  }) {
    return DownloadModel(
      downloading: downloading ?? this.downloading,
      progress: progress ?? this.progress,
      received: received ?? this.received,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }
}
