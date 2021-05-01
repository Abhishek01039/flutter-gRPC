import 'package:car_next_door_demo/db.dart';
import 'package:car_next_door_demo/src/generated/album.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/service_api.dart';

class AlbumService extends AlbumServiceBase {
  @override
  Future<AlbumResponse> getAlbum(ServiceCall call, AlbumRequest request) async {
    if (request.id > 0) {
      final album = getAlbumById(request.id);
      return AlbumResponse()..albums.addAll(album);
    }
    final album = albums.map((e) => convertToJson(e)).toList();
    return AlbumResponse()..albums.addAll(album);
  }

  @override
  Future<AlbumResponse> getAlbumWithPhoto(
      ServiceCall call, AlbumRequest request) async {
    if (request.id > 0) {
      final album = getAlbumById(request.id)[0];
      final photo = findPhotos(album.id);
      return AlbumResponse()..albums.add(album..photo.addAll(photo));
    }
    return AlbumResponse()
      ..albums.addAll(albums.map((e) {
        final album = convertToJson(e);
        final photo = findPhotos(album.id);

        return album..photo.addAll(photo);
      }));
  }

  @override
  Stream<Photo> photoStream(ServiceCall call, AlbumRequest request) async* {
    var photoList = photos;
    if (request.id > 0) {
      photoList =
          photos.where((element) => element['albumId'] == request.id).toList();
    }
    for (var item in photoList) {
      yield Photo.fromJson('''{
        "1":"${item['albumId']}",
        "2":"${item['id']}",
        "3":"${item['title']}",
        "4":"${item['url']}"
      }''');
    }
  }
}

List<Album> getAlbumById(int id) {
  return albums
      .where((element) => element['id'] == id)
      .map((e) => convertToJson(e))
      .toList();
}

Album convertToJson(Map e) {
  return Album.fromJson('{"1":"${e['id']}","2":"${e['title']}"}');
}

List<Photo> findPhotos(int id) {
  return photos
      .where((element) => element['albumId'] == id)
      .map((e) => Photo.fromJson(
          '{"1":"${e['albumId']}","2":"${e['id']}","3":"${e['title']}","4":"${e['url']}"}'))
      .toList();
}

void main(List<String> args) async {
  final server = Server([AlbumService()]);
  await server.serve(port: 5000);

  print('server is running ${server.port}');
}
