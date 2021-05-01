import 'package:car_next_door_demo/src/generated/album.pbgrpc.dart';
import 'package:grpc/grpc.dart';

main(List<String> args) async {
  final client = ClientChannel(
    'localhost',
    port: 5000,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );

  final stub = AlbumServiceClient(client);

  var response = await stub.getAlbum(AlbumRequest());
  print(response.writeToJson());

  response = await stub.getAlbum(AlbumRequest()..id = 1);
  print(response.writeToJson());

  response = await stub.getAlbumWithPhoto(AlbumRequest());
  print(response.writeToJson());

  response = await stub.getAlbumWithPhoto(AlbumRequest()..id = 1);
  print(response.writeToJson());

  var photoStream = stub.photoStream(AlbumRequest());
  await for (var item in photoStream) {
    print(item.url);
  }

  photoStream = stub.photoStream(AlbumRequest()..id = 1);
  await for (var item in photoStream) {
    print(item.url);
  }

  client.shutdown();
}
