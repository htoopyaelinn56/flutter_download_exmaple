import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadHelper {
  static Future<void> downloadFile({
    required String url,
    required String fileName,
    required String extension,
    CancelToken? cancelToken,
    void Function(double, String)? onProgress, // progress and size downloaded
    void Function()? onFinished,
  }) async {
    final path = await getDownloadsDirectory();
    final dio = Dio();
    var savePath = _savePath(
      downloadPath: path!.path,
      file: fileName,
      extension: extension,
    );

    for (int i = 1; await File(savePath).exists(); i++) {
      savePath = _savePath(
        downloadPath: path.path,
        file: '$fileName($i)',
        extension: extension,
      );
    }
    bool finishedOnce = false; //flag to check only one finish event is invoked, if not there will be multiple finished events

    dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100);
          final receivedSize = _getFileSizeString(bytes: received);
          onProgress?.call(progress, receivedSize);
        } else {
          if (!finishedOnce) {
            onFinished?.call();
            finishedOnce = true;
          }
        }
      },
    );
  }

  static String _savePath({
    required String downloadPath,
    required String file,
    required String extension,
  }) {
    var savePath = () {
      if (Platform.isWindows) {
        return '$downloadPath\\$file.$extension';
      } else if (Platform.isAndroid) {
        return '/storage/emulated/0/Download/$file.$extension';
      } else {
        return '$downloadPath/$file.$extension'; //macos, iOS
      }
    }();
    return savePath;
  }

  static String _getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
}
