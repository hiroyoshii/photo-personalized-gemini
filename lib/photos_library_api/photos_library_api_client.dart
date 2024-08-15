/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:photos_personalized_gemini/photos_library_api/album.dart';
import 'package:http/http.dart' as http;
import 'package:photos_personalized_gemini/photos_library_api/get_album_request.dart';
import 'package:photos_personalized_gemini/photos_library_api/list_albums_response.dart';
import 'package:photos_personalized_gemini/photos_library_api/search_media_items_request.dart';
import 'package:photos_personalized_gemini/photos_library_api/search_media_items_response.dart';
import 'package:path/path.dart' as path;

class PhotosLibraryApiClient {
  PhotosLibraryApiClient(this._authHeaders);

  final Map<String, String> _authHeaders;

  Future<Album> getAlbum(GetAlbumRequest request) async {
    final response = await http.get(
        Uri.parse(
            'https://photoslibrary.googleapis.com/v1/albums/${request.albumId}'),
        headers: await _authHeaders);

    printError(response);

    return Album.fromJson(jsonDecode(response.body));
  }

  Future<ListAlbumsResponse> listAlbums() async {
    final response = await http.get(
        Uri.parse('https://photoslibrary.googleapis.com/v1/albums?'
            'pageSize=50'),
        headers: await _authHeaders);

    printError(response);

    print("body ${response.body}");

    return ListAlbumsResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchMediaItemsResponse> searchMediaItems(
      SearchMediaItemsRequest request) async {
    final response = await http.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:search'),
      body: jsonEncode(request),
      headers: await _authHeaders,
    );

    printError(response);

    return SearchMediaItemsResponse.fromJson(jsonDecode(response.body));
  }

  Future<Uint8List> downloadMediaItem(String baseUrl) async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
      print(response.body);
    }
    return response.bodyBytes;
  }

  static void printError(final Response response) {
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
      print(response.body);
    }
  }
}
