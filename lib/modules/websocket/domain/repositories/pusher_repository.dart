
/// An interface for interacting with the Pusher service.
abstract class PusherRepository {
  /// Connects to the Pusher service to start receiving events.
  ///
  /// This should be called to initiate a connection and prepare for event
  /// streaming. Optionally, authentication details or other connection parameters
  /// may be required, depending on the service configuration.
  void connect();

  /// Disconnects from the Pusher service.
  ///
  /// Ensures a clean disconnection from the Pusher service, closing
  /// any active connections and freeing up resources.
  void disconnect();

  /// Listens for vehicle updates from the Pusher service.
  ///
  /// Returns a broadcast [Stream] that emits vehicle location updates as a
  /// [Map] containing key-value pairs relevant to the update.
  ///
  /// Multiple listeners can subscribe to this stream simultaneously to receive
  /// updates. Errors on the stream are expected to be handled by subscribers.
  Stream<Map<String, dynamic>> listenToVehicleUpdates();
}

///-------
// /// An interface for interacting with the Pusher service.
// abstract class PusherRepository {
//   /// Connects to the Pusher service to start receiving events.
//   /// Optionally, you can pass authentication details or other connection parameters if needed.
//   void connect();
//
//   /// Disconnects from the Pusher service.
//   void disconnect();
//
//   /// Listens for vehicle updates from the Pusher service.
//   /// Returns a stream that emits updates in the form of a Map.
//   /// This stream can support multiple listeners if implemented as a broadcast stream.
//   Stream<Map<String, dynamic>> listenToVehicleUpdates();
// }
