
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
