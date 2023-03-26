import 'package:dio/dio.dart';
import 'package:flutter_download_example/download_helper.dart';
import 'package:flutter_download_example/download_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadController extends StateNotifier<List<DownloadModel>> {
  DownloadController() : super([]);

  void addDownload({
    required String url,
  }) {
    state.add(
      DownloadModel(
        downloading: false,
        progress: 0.0,
        received: '',
        cancelToken: CancelToken(),
      ),
    );
    state = [...state];
    final index = state.length - 1;
    DownloadHelper.downloadFile(
        url: url,
        fileName: 'Test Download',
        extension: 'bin',
        cancelToken: state[index].cancelToken,
        onProgress: (progress, receivedSize) {
          state[index] = state[index].copyWith(
            downloading: true,
            received: receivedSize,
            progress: progress,
          );
          state = [...state];
        },
        onFinished: () {
          state[index] = state[index].copyWith(
            downloading: false,
            progress: 1,
          );
          state = [...state];
        });
  }

  void cancelDownload({required int index}) {
    state[index].cancelToken.cancel();
    state.removeAt(index);
    state = [...state];
  }
}

final downloadControllerProvider = StateNotifierProvider<DownloadController, List<DownloadModel>>((ref) {
  return DownloadController();
});
