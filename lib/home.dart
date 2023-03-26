import 'package:flutter/material.dart';
import 'package:flutter_download_example/download_controller.dart';
import 'package:flutter_download_example/download_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'download_helper.dart';

class _DownloadLink {
  final String name;
  final String link;
  const _DownloadLink({
    required this.name,
    required this.link,
  });
}

const _segments = <ButtonSegment<_DownloadLink>>[
  ButtonSegment(
    value: _DownloadLink(
      name: '100 MB',
      link: 'https://speed.hetzner.de/100MB.bin',
    ),
    label: Text('100 MB'),
  ),
  ButtonSegment(
    value: _DownloadLink(
      name: '1 GB',
      link: 'https://speed.hetzner.de/1GB.bin',
    ),
    label: Text('1 GB'),
  ),
];

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  _DownloadLink selected = _segments.first.value;

  @override
  Widget build(BuildContext context) {
    final donwloadList = ref.watch(downloadControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                SegmentedButton<_DownloadLink>(
                  showSelectedIcon: false,
                  segments: _segments,
                  selected: {selected},
                  onSelectionChanged: (value) {
                    selected = value.first;
                    setState(() {});
                  },
                ),
                const SizedBox(width: 10),
                StreamBuilder<bool>(
                    initialData: true,
                    stream: didCheckingExistedFileForDownloadFinished.stream,
                    builder: (context, value) {
                      return ElevatedButton(
                        onPressed: value.data!
                            ? () async {
                                await ref.watch(downloadControllerProvider.notifier).addDownload(url: selected.link);
                              }
                            : null,
                        child: const Text('Download'),
                      );
                    }),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (_, index) {
                  final item = donwloadList[index];
                  return DownloadItem(
                    index: index,
                    donwloadItem: 'item',
                    progress: item.progress,
                    receivedSize: item.received,
                    cancelDownload: () {
                      ref.read(downloadControllerProvider.notifier).cancelDownload(index: index);
                    },
                  );
                },
                itemCount: donwloadList.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
