// import 'package:laravel_echo/laravel_echo.dart';
// import 'package:pusher_client/pusher_client.dart' as PUSHER;
// import 'package:laravel_echo/src/channel/private_channel.dart';



// import 'package:wivoce_laravel_echo_client/wivoce_laravel_echo_client.dart';

class PusherService {
  // late Echo _echo;
  final String pusherAppKey = 'cf378b7d56a8a5a1b7ad';
  final String authEndpoint = 'https://cti.maypaseducation.com/api/broadcasting/auth';
  final String token;

  PusherService(this.token);

  void initializePusher(String token, String userId) {
    print("initializePusher>>>>:: $token");
    print("pusherAppKey>>>>:: $pusherAppKey");
    print("authEndpoint>>>>:: $authEndpoint");
    //
    // // Initialize Echo with PusherConnector
    // _echo = Echo(PusherConnector(
    //   pusherAppKey,
    //   authEndPoint: authEndpoint,
    //   authHeaders: {
    //     'Authorization': '$token',
    //     'Accept': 'application/json',
    //   },
    //   cluster: 'mt1',
    //   host: 'cti.maypaseducation.com',
    //   encrypted: true,
    //   autoConnect: false,
    // ));
    //
    // PUSHER.PusherClient pusherClient = _echo.connector.client;
    //
    // pusherClient.onConnected((_) {
    //   print('Pusher connected');
    //   subscribeToAdminChannel();
    // });
    //
    // pusherClient.onConnectionError((error) {
    //   print('Connection error: ${error?.message}');
    //   reconnectWithBackoff(1);
    // });
    //
    // try {
    //   pusherClient.connect();
    //   print(">>>> Connection initiated <<<<");
    // } catch (e, stackTrace) {
    //   print("Connection error: $e");
    //   print("Stack trace: $stackTrace");
    }
  }

  // void reconnectWithBackoff(int retryCount) async {
  //   int waitTime = retryCount < 6 ? (2 ^ retryCount) : 64;
  //   await Future.delayed(Duration(seconds: waitTime));
  //   try {
  //     _echo.connector.client.connect();
  //   } catch (e) {
  //     reconnectWithBackoff(retryCount + 1);
  //   }
  // }
  //
  // void subscribeToAdminChannel() {
  //   PrivateChannel privateChannel = _echo.private('admin.vehicle-location');
  //   privateChannel.listen('VehicleLocationUpdated', (data) {
  //     print('Private Channel Event Data: $data');
  //   });
  // }
  //
  // void disconnect() {
  //   _echo.disconnect();
  // }
// }
