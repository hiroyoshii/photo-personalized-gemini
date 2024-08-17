import 'dart:typed_data';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:photos_personalized_gemini/photos_library_api/album.dart';
import 'package:photos_personalized_gemini/photos_library_api/media_item.dart';
import 'package:photos_personalized_gemini/photos_library_api/photos_library_api_client.dart';
import 'package:photos_personalized_gemini/photos_library_api/search_media_items_request.dart';

class PhotoGemini extends StatefulWidget {
  const PhotoGemini({super.key, required this.client, required this.albums});

  final PhotosLibraryApiClient client;
  final List<Album> albums;

  @override
  State<PhotoGemini> createState() => _PhotoGeminiState();
}

class _PhotoGeminiState extends State<PhotoGemini> {
  final model =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-pro');

  final _controller = MultiSelectController<String>();
  List<String> _selected = [];
  String _inputText = "";
  bool _inputTextChange = false;
  bool _itemSynced = false;
  List<ContextImage> _mediaItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: MultiDropdown<String>(
            items: widget.albums
                .map((e) => DropdownItem(label: e.title!, value: e.id!))
                .toList(),
            searchEnabled: true,
            fieldDecoration: FieldDecoration(
              hintText: 'アルバムを選択してください',
              hintStyle: const TextStyle(color: Colors.black87),
              suffixIcon: IconButton(
                  onPressed: () => setState(() {
                        _selected = _controller.selectedItems
                            .map((e) => e.value)
                            .toList();
                        _itemSynced = true;
                      }),
                  icon: (_selected.isEmpty)
                      ? Icon(Icons.sync)
                      : Icon(Icons.sync, color: Colors.purpleAccent)),
              showClearIcon: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.black87,
                ),
              ),
            ),
            onSelectionChange: (selectedItems) {
              setState(() {
                _selected = selectedItems;
                _itemSynced = false;
              });
            },
            controller: _controller,
          ),
        ),
        (!_itemSynced)
            ? Container()
            : FutureBuilder(
                future: _loadPhotos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.check_circle,
                                color: Colors.purpleAccent),
                          ),
                          TextSpan(
                            text: '${_mediaItems.length}件取り込み完了',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gemini 1.5 Pro へのプロンプト入力',
                prefixIcon: Icon(Icons.smart_toy)),
            onSubmitted: (value) {
              setState(() {
                _inputText = value;
                _inputTextChange = true;
              });
            },
            onChanged: (value) {
              setState(() {
                _inputTextChange = false;
              });
            },
          ),
        ),
        (!_inputTextChange)
            ? const Text('')
            : FutureBuilder(
                future: _requestGemini(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 400,
                        child: Markdown(
                            data:
                                snapshot.data?.text ?? "エラーが発生しました。リトライしてください"),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
      ],
    );
  }

  Future<bool> _loadPhotos() async {
    if (kDebugMode) {
      print("load start");
    }
    try {
      final remaining = _mediaItems
          .where((element) => _selected.contains(element.albumId))
          .toList();
      for (var albumId in _selected) {
        if (_mediaItems
            .where((element) => element.albumId == albumId)
            .isNotEmpty) {
          continue;
        }
        if (kDebugMode) {
          print("load album: $albumId");
        }
        final items = await widget.client
            .searchMediaItems(SearchMediaItemsRequest(albumId, null, null));
        if (kDebugMode) {
          print("search: ${items.mediaItems?.length}");
        }
        List<Future<ContextImage>> futureList = [];
        for (var item in items.mediaItems!) {
          if (item != null) {
            futureList.add(_download(albumId, item));
          }
        }
        var futureWait = Future.wait(futureList);

        var result = await futureWait;
        for (var contextImage in result) {
          remaining.add(contextImage);
        }
      }
      _mediaItems = remaining;
    } catch (e) {
      print(e);
      return Future.value(false);
    }
    if (kDebugMode) {
      print("finish load media: ${_mediaItems.length}");
    }
    return Future.value(true);
  }

  Future<ContextImage> _download(String albumId, MediaItem item) async {
    var bodyBytes = await widget.client.downloadMediaItem(item.baseUrl!);
    return ContextImage(albumId, bodyBytes, item.mimeType!);
  }

  Future<GenerateContentResponse> _requestGemini() async {
    try {
      // Provide a prompt that contains text
      if (kDebugMode) {
        print("req gemini");
      }
      final prompt = [
        Content.multi([
          TextPart(
              'あなたは敏腕の旅行コンサルタントです。写真はすべて旅行した際にとったものになります。それを踏まえ、写真撮影者に最適化された提案をしてください。'),
          ..._mediaItems.map((e) => DataPart(e.mimeType, e.image)),
          TextPart(_inputText),
        ]),
      ];

      final response = await model.generateContent(prompt);
      _inputText = "";
      return Future.value(response);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}

class ContextImage {
  final String albumId;
  final Uint8List image;
  final String mimeType;

  ContextImage(this.albumId, this.image, this.mimeType);
}
