import 'package:car_next_door_demo/db.dart';
import 'package:car_next_door_demo/src/generated/album.pb.dart';

void main() {
  final album = Album()
    ..id = 1
    ..title = "hello";

  print(album);

  final Album album1 =
      Album.fromJson('{"1":${albums[0]['id']},"2":"${albums[0]['title']}"}');

  print(album1.clone());

  print(album1.writeToJson());
}
