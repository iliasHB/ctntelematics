import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PusherService {
  final String token;
  final String userId, user_type;
  late WebSocket _socket;
  final _vehicleUpdatesController =
  StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;

  PusherService(this.token, this.userId, this.user_type) {
    initializePusher();
  }

  Stream<Map<String, dynamic>> get vehicleUpdates =>
      _vehicleUpdatesController.stream;

  initializePusher() async {
    try {
      // Connect to the Laravel Echo WebSocket server
      _socket = await WebSocket.connect(
          'wss://ws-mt1.pusher.com:443/app/cf378b7d56a8a5a1b7ad?protocol=7&client=js&version=8.2.0&flash=false');

      // Listen for incoming messages from the server
      _socket.listen(_handleMessage,
          onDone: _onDisconnected, onError: _onError);

      // Send the initial connection established message
      _isConnected = true;
    } catch (e) {
      print('Error connecting to Laravel Echo: $e');
      _isConnected = false;
      _attemptReconnect();
    }
  }

  Future<void> _attemptReconnect({int delaySeconds = 5, int maxAttempts = 5}) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      print('Attempting to reconnect... Attempt $attempt');
      await Future.delayed(Duration(seconds: delaySeconds));
      try {
        await initializePusher();
        if (_isConnected) break;
      } catch (e) {
        print('Reconnection attempt $attempt failed: $e');
      }
    }
  }

  Future<String> _getAuthToken(String channelName, String socketId) async {
    const int maxRetries = 5; // Maximum number of retries
    int attempt = 0;
    print("token::::::${token}");

    while (attempt < maxRetries) {
      try {
        // Make a request to your Laravel server for an auth token
        final response = await http.post(
          Uri.parse('https://cti.maypaseducation.com/api/broadcasting/auth'),
          headers: {
            'Authorization': token,
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'socket_id': socketId,
            'channel_name': channelName,
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['auth'];
        } else {
          print('Error: ${response.statusCode} - ${response.body}');
          throw Exception('Failed to authenticate with Laravel Echo');
        }
      } catch (e) {
        if (e is SocketException) {
          print('Network error: $e');
        } else {
          print('Error fetching auth token: $e');
        }
        attempt++;
        if (attempt < maxRetries) {
          print('Retrying... Attempt: $attempt');
          await Future.delayed(const Duration(seconds: 2)); // Wait before retrying
        } else {
          print('Max retries reached. Failing.');
          throw e; // Rethrow the last exception after max retries
        }
      }
    }
    throw Exception('Failed to authenticate after $maxRetries attempts');
  }

  void _handleMessage(dynamic message) async {
    final decodedMessage = jsonDecode(message);
    print('Decoded Message: $decodedMessage'); // For debugging
    final event = decodedMessage['event'];
    final data = decodedMessage['data'];
    print('event>>>>>>>>: $event');
    print('data>>>>>>>>: $data');

    if (event == 'pusher:connection_established') {
      print('Connected to Laravel Echo');

      // Decode the data to access its properties
      if (data is String) {
        final dataMap = jsonDecode(data); // Decode the string to a Map
        String socketId = dataMap['socket_id']; // Access the socket_id
        // print('Socket ID: $socketId');
        //
        // print("user_type-websocket::: ${user_type}");
        //
        // print("user_id-websocket::: ${userId}");

        // After establishing a connection, subscribe to channels
        if(user_type == "admin" || user_type == "system_admin") {
          await _subscribeToChannel('private-admin.vehicle-location', socketId);
        } else {
          await _subscribeToChannel('private-vehicle-owner.$userId', socketId);
        }
      } else {
        print('Unexpected data format: $data'); // Handle unexpected format
      }
    } else if (event.toString().contains("VehicleLocationUpdated") && data != null) {
      final decodedData = jsonDecode(data);
      print('decodedData Message: $decodedData'); // For debugging
      if (decodedData is Map<String, dynamic>) {
        _vehicleUpdatesController.add(decodedData);
      }
    }
  }

  Future<void> _subscribeToChannel(String channelName, String socketId) async {
    final authToken = await _getAuthToken(channelName, socketId);
    final message = {
      "event": "pusher:subscribe",
      "data": {
        "auth": authToken,
        "channel": channelName,
      },
    };

    _socket.add(jsonEncode(message));
  }

  void _onDisconnected() {
    print('Disconnected from Laravel Echo');
    _isConnected = false;
    _attemptReconnect();
  }

  void _onError(error) {
    print('Laravel Echo error: $error');
    _isConnected = false;
  }

  void dispose() {
    _vehicleUpdatesController.close();
    _socket.close();
  }
}




// class PusherService {
//   final String token;
//   final String userId;
//   late WebSocket _socket;
//   final _vehicleUpdatesController = StreamController<Map<String, dynamic>>.broadcast();
//   bool _isConnected = false;
//   final String _webSocketUrl = 'wss://ws-mt1.pusher.com:443/app/cf378b7d56a8a5a1b7ad?protocol=7&client=js&version=8.2.0&flash=false';
//   final String _authUrl = 'https://cti.maypaseducation.com/api/broadcasting/auth';
//
//   PusherService(this.token, this.userId) {
//     initializePusher();
//   }
//
//   Stream<Map<String, dynamic>> get vehicleUpdates => _vehicleUpdatesController.stream;
//
//   initializePusher() async {
//     try {
//       _socket = await WebSocket.connect(_webSocketUrl);
//       _socket.listen(
//         _handleMessage,
//         onDone: _onDisconnected,
//         onError: _onError,
//       );
//       _isConnected = true;
//     } catch (e) {
//       print('Error connecting to Laravel Echo: $e');
//       _isConnected = false;
//       _attemptReconnect();
//     }
//   }
//
//   Future<void> _attemptReconnect({int delaySeconds = 5, int maxAttempts = 3}) async {
//     for (int attempt = 1; attempt <= maxAttempts; attempt++) {
//       print('Attempting to reconnect... Attempt $attempt');
//       await Future.delayed(Duration(seconds: delaySeconds));
//       try {
//         await initializePusher();
//         if (_isConnected) break;
//       } catch (e) {
//         print('Reconnection attempt $attempt failed: $e');
//       }
//     }
//   }
//
//   Future<String> _getAuthToken(String channelName, String socketId) async {
//     const int maxRetries = 3;
//     int attempt = 0;
//     while (attempt < maxRetries) {
//       try {
//         final response = await http.post(
//           Uri.parse(_authUrl),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//           body: {
//             'socket_id': socketId,
//             'channel_name': channelName,
//           },
//         );
//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           return data['auth'];
//         } else {
//           throw Exception('Failed to authenticate with Laravel Echo: ${response.statusCode}');
//         }
//       } catch (e) {
//         print('Auth token fetch error: $e, retrying... ($attempt)');
//         attempt++;
//         await Future.delayed(const Duration(seconds: 2));
//       }
//     }
//     throw Exception('Failed to authenticate after $maxRetries attempts');
//   }
//
//   void _handleMessage(dynamic message) async {
//     final decodedMessage = jsonDecode(message);
//     final event = decodedMessage['event'];
//     final data = decodedMessage['data'];
//     if (event == 'pusher:connection_established' && data is String) {
//       final dataMap = jsonDecode(data);
//       final socketId = dataMap['socket_id'];
//       await _subscribeToChannel('private-admin.vehicle-location', socketId);
//     } else if (event == 'VehicleLocationUpdated' && data != null) {
//       final decodedData = jsonDecode(data);
//       if (decodedData is Map<String, dynamic>) {
//         _vehicleUpdatesController.add(decodedData);
//       }
//     }
//   }
//
//   Future<void> _subscribeToChannel(String channelName, String socketId) async {
//     try {
//       final authToken = await _getAuthToken(channelName, socketId);
//       final message = {
//         "event": "pusher:subscribe",
//         "data": {
//           "auth": authToken,
//           "channel": channelName,
//         },
//       };
//       _socket.add(jsonEncode(message));
//     } catch (e) {
//       print('Subscription error: $e');
//     }
//   }
//
//   void _onDisconnected() {
//     print('Disconnected from Laravel Echo');
//     _isConnected = false;
//     _attemptReconnect();
//   }
//
//   void _onError(error) {
//     print('Laravel Echo error: $error');
//     _isConnected = false;
//   }
//
//   void dispose() {
//     _vehicleUpdatesController.close();
//     _socket.close();
//   }
// }


///------
// class PusherService {
//   final String token;
//   final String userId;
//   late WebSocket _socket;
//   final _vehicleUpdatesController = StreamController<Map<String, dynamic>>.broadcast();
//   bool _isConnected = false;
//   final int _maxReconnectAttempts = 3;
//   int _reconnectAttempts = 0;
//
//   PusherService(this.token, this.userId) {
//     initializePusher();
//   }
//
//   Stream<Map<String, dynamic>> get vehicleUpdates => _vehicleUpdatesController.stream;
//
//   void initializePusher() async {
//     try {
//       _socket = await WebSocket.connect(
//           'wss://ws-mt1.pusher.com:443/app/cf378b7d56a8a5a1b7ad?protocol=7&client=js&version=8.2.0&flash=false');
//       _socket.listen(_handleMessage, onDone: _onDisconnected, onError: _onError);
//       _isConnected = true;
//       _reconnectAttempts = 0; // Reset reconnect attempts on successful connection
//     } catch (e) {
//       print('Error connecting to Laravel Echo: $e');
//       _isConnected = false;
//       _retryConnection();
//     }
//   }
//
//   Future<void> _retryConnection() async {
//     if (_reconnectAttempts < _maxReconnectAttempts) {
//       _reconnectAttempts++;
//       print('Retrying connection... Attempt $_reconnectAttempts');
//       await Future.delayed(Duration(seconds: 2 * _reconnectAttempts));
//       initializePusher();
//     } else {
//       print('Max reconnect attempts reached. Giving up.');
//     }
//   }
//
//   Future<String> _getAuthToken(String channelName, String socketId) async {
//     const int maxRetries = 3;
//     int attempt = 0;
//     print("token:::::::: $token");
//     while (attempt < maxRetries) {
//       try {
//         final response = await http.post(
//           Uri.parse('https://cti.maypaseducation.com/api/broadcasting/auth'),
//           headers: {
//             'Authorization': token,
//             'Accept': 'application/json',
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//           body: {
//             'socket_id': socketId,
//             'channel_name': channelName,
//           },
//         );
//
//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           return data['auth'];
//         } else {
//           print('Error: ${response.statusCode} - ${response.body}');
//         }
//       } catch (e) {
//         print('Error fetching auth token: $e');
//       }
//       attempt++;
//       if (attempt < maxRetries) {
//         await Future.delayed(const Duration(seconds: 2));
//       }
//     }
//     throw Exception('Failed to authenticate after $maxRetries attempts');
//   }
//
//   void _handleMessage(dynamic message) async {
//     final decodedMessage = jsonDecode(message);
//     final event = decodedMessage['event'];
//     final data = decodedMessage['data'];
//
//     if (event == 'pusher:connection_established' && data is String) {
//       print('Connected to Laravel Echo');
//       final dataMap = jsonDecode(data);
//       String socketId = dataMap['socket_id'];
//       print('Socket ID: $socketId');
//       await _subscribeToChannel('private-admin.vehicle-location', socketId);
//     } else if (event == 'VehicleLocationUpdated' && data != null) {
//       final decodedData = jsonDecode(data);
//       if (decodedData is Map<String, dynamic>) {
//         _vehicleUpdatesController.add(decodedData);
//       }
//     }
//   }
//
//   Future<void> _subscribeToChannel(String channelName, String socketId) async {
//     // if (!_isConnected) return;
//     print(":::::: _subscribeToChannel_1:::::::::");
//     final authToken = await _getAuthToken(channelName, socketId);
//     final message = {
//       "event": "pusher:subscribe",
//       "data": {
//         "auth": authToken,
//         "channel": channelName,
//       },
//     };
//     print(":::::: _subscribeToChannel_2:::::::::");
//     _socket.add(jsonEncode(message));
//   }
//
//   void _onDisconnected() {
//     print('Disconnected from Laravel Echo');
//     _isConnected = false;
//     _retryConnection();
//   }
//
//   void _onError(error) {
//     print('Laravel Echo error: $error');
//     _isConnected = false;
//     _retryConnection();
//   }
//
//   void dispose() {
//     _vehicleUpdatesController.close();
//     _socket.close();
//   }
// }

///---------------------------------------------------------------
// class PusherService {
//   final String token;
//   final String userId;
//   late final PusherClient _pusherClient;
//   final _vehicleUpdatesController = StreamController<Map<String, dynamic>>.broadcast();
//   bool _isInitialized = false; // Flag to prevent reinitialization
//   bool _isSubscribedToAdminChannel = false;
//   bool _isSubscribedToOwnerChannel = false;
//
//   PusherService(this.token, this.userId) {
//     try {
//       initializePusher();
//     } catch (e) {
//       print('Pusher initialization error: $e');
//     }
//   }
//
//   Stream<Map<String, dynamic>> getVehicleUpdates() => _vehicleUpdatesController.stream;
//
//   void initializePusher() {
//     if (_isInitialized) return; // Check if already initialized
//     PusherOptions options = PusherOptions(
//       encrypted: true,
//       cluster: 'mt1',
//       auth: PusherAuth(
//         'https://cti.maypaseducation.com/api/broadcasting/auth',
//         headers: {
//           'Authorization': token,
//           'Accept': 'application/json',
//         },
//       ),
//     );
//
//     _pusherClient = PusherClient('cf378b7d56a8a5a1b7ad', options, enableLogging: true);
//
//     _pusherClient.connect();
//
//     _pusherClient.onConnectionStateChange((state) {
//       if (state?.currentState == 'CONNECTED') {
//         _subscribeToChannels();
//       }
//     });
//
//     _pusherClient.onConnectionError((error) {
//       print('Pusher connection error: ${error?.message}');
//     });
//
//     _isInitialized = true; // Set flag after initializing
//
//   }
//
//   void _subscribeToChannels() {
//     final echo = Echo(
//       broadcaster: EchoBroadcasterType.Pusher,
//       client: _pusherClient,
//     );
//
//
//     if (!_isSubscribedToAdminChannel) {
//       echo.private('admin.vehicle-location').listen('VehicleLocationUpdated', (PusherEvent? event) {
//         if (event?.data != null) {
//           final decodedData = jsonDecode(event!.data!);
//           if (decodedData is Map<String, dynamic>) {
//             print('data::::--::::: $decodedData ::::::--::::data');
//             _vehicleUpdatesController.add(decodedData);
//
//           }
//         }
//       });
//       _isSubscribedToAdminChannel = true; // Mark as subscribed
//     }
//
//     if (!_isSubscribedToOwnerChannel) {
//       echo.private('vehicle-owner.$userId').listen('VehicleLocationUpdated', (PusherEvent? event) {
//         if (event?.data != null) {
//           final decodedData = jsonDecode(event!.data!);
//           if (decodedData is Map<String, dynamic>) {
//             _vehicleUpdatesController.add(decodedData);
//           }
//         }
//       });
//       _isSubscribedToOwnerChannel = true; // Mark as subscribed
//     }
//
//     // echo.private('admin.vehicle-location').listen('VehicleLocationUpdated', (PusherEvent? event) {
//     //   if (event?.data != null) {
//     //     final decodedData = jsonDecode(event!.data!);
//     //     if (decodedData is Map<String, dynamic>) {
//     //       _vehicleUpdatesController.add(decodedData);
//     //     }
//     //   }
//     // });
//     //
//     // echo.private('vehicle-owner.$userId').listen('VehicleLocationUpdated', (PusherEvent? event) {
//     //   if (event?.data != null) {
//     //     final decodedData = jsonDecode(event!.data!);
//     //     if (decodedData is Map<String, dynamic>) {
//     //       _vehicleUpdatesController.add(decodedData);
//     //     }
//     //   }
//     // });
//   }
//
//   void disconnect() {
//     _pusherClient.disconnect();
//     _vehicleUpdatesController.close();
//     _isInitialized = false; // Reset initialization flag if disconnecting
//     _isSubscribedToAdminChannel = false; // Reset subscription tracking
//     _isSubscribedToOwnerChannel = false; // Reset subscription tracking
//
//   }
//   void dispose() {
//     _vehicleUpdatesController.close();
//     disconnect();
//   }
//
// // PusherOptions options = PusherOptions(
// //   encrypted: true,
// //   cluster: 'mt1',
// //   host: 'cti.maypaseducation.com',
// //   authOptions: PusherAuthOptions(
// //     'https://cti.maypaseducation.com/api/broadcasting/auth',
// //     headers: {
// //       'Authorization': token,
// //       'Accept': 'application/json',
// //     },
// //   ),
// //   key: 'cf378b7d56a8a5a1b7ad',
// //   enableLogging: true
// // );
//
// // _pusherClient = PusherClient(
// //     // 'cf378b7d56a8a5a1b7ad',
// //     options: options,
// //     // enableLogging: true,
// //     );
// //
// // _pusherClient.connect();
// //
// // _pusherClient.onConnectionEstablished((data) {
// //   print("Connection established - socket-id: ${_pusherClient.socketId}");
// //   _subscribeToChannels();
// // });
// }

///-=-------------------------------------------------------------
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:pusher_client_fixed/pusher_client_fixed.dart';
// import 'package:wivoce_laravel_echo_client/wivoce_laravel_echo_client.dart';
//
// class PusherService {
//   final String token;
//   final String userId;
//   late final PusherClient _pusherClient;
//   final _vehicleUpdatesController = StreamController<Map<String, dynamic>>();
//
//   PusherService(this.token, this.userId) {
//     initializePusher();
//   }
//
//   Stream<Map<String, dynamic>> getVehicleUpdates() => _vehicleUpdatesController.stream;
//
//   void initializePusher() {
//
//     if (_pusherClient != null) return; // Prevent reinitialization
//
//     PusherOptions options = PusherOptions(
//       encrypted: true,
//       cluster: 'mt1',
//       auth: PusherAuth(
//         'https://cti.maypaseducation.com/api/broadcasting/auth',
//         headers: {
//           'Authorization': token,
//           'Accept': 'application/json',
//         },
//       ),
//     );
//
//     _pusherClient = PusherClient('cf378b7d56a8a5a1b7ad', options, enableLogging: true);
//
//     _pusherClient.connect();
//
//     _pusherClient.onConnectionStateChange((state) {
//       if (state?.currentState == 'CONNECTED') {
//         _subscribeToChannels();
//       }
//     });
//   }
//
//   // void _subscribeToChannels() {
//   //   final echo = Echo(
//   //     broadcaster: EchoBroadcasterType.Pusher,
//   //     client: _pusherClient,
//   //   );
//   //
//   //   echo.private('admin.vehicle-location').listen('VehicleLocationUpdated', (event) {
//   //     _vehicleUpdatesController.add(event);
//   //   });
//   //
//   //   echo.private('vehicle-owner.$userId').listen('VehicleLocationUpdated', (event) {
//   //     _vehicleUpdatesController.add(event);
//   //   });
//   // }
//
//   void _subscribeToChannels() {
//     final echo = Echo(
//       broadcaster: EchoBroadcasterType.Pusher,
//       client: _pusherClient,
//     );
//
//     echo.private('admin.vehicle-location').listen('VehicleLocationUpdated', (PusherEvent? event) {
//       if (event!.data != null) {
//         final decodedData = jsonDecode(event.data!); // Decode JSON string to Map
//         if (decodedData is Map<String, dynamic>) {
//           _vehicleUpdatesController.add(decodedData);
//         }
//       }
//     });
//
//     echo.private('vehicle-owner.$userId').listen('VehicleLocationUpdated', (PusherEvent? event) {
//       if (event!.data != null) {
//         final decodedData = jsonDecode(event.data!); // Decode JSON string to Map
//         if (decodedData is Map<String, dynamic>) {
//           _vehicleUpdatesController.add(decodedData);
//         }
//       }
//     });
//   }
//
//
//   void disconnect() {
//     _pusherClient.disconnect();
//     _vehicleUpdatesController.close();
//   }
// }
