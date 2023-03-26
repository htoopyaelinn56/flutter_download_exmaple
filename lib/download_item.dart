import 'package:flutter/material.dart';

class DownloadItem extends StatelessWidget {
  const DownloadItem({
    super.key,
    required this.index,
    required this.donwloadItem,
    required this.progress,
    required this.receivedSize,
    required this.cancelDownload,
  });
  final String donwloadItem;
  final double progress;
  final int index;
  final String receivedSize;
  final void Function() cancelDownload;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text('${index + 1}.'),
          Text('Downloading $donwloadItem'),
          const Spacer(),
          Center(
            child: Text(
              '${progress.toStringAsFixed(2)}% $receivedSize',
            ),
          ),
          const SizedBox(width: 5),
          CircularProgressIndicator(
            value: progress / 100,
            strokeWidth: 5,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: cancelDownload,
            child: const Icon(Icons.cancel_outlined),
          ),
        ],
      ),
    );
  }
}
