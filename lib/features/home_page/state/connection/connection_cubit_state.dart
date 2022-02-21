part of 'connection_cubit.dart';

/// Connection States
abstract class ConnectionCubitState {}

/// Initial state
class InitialConnectionState extends ConnectionCubitState {
  @override
  String toString() => 'ConnectionState: InitialConnectionState';
}

/// shows that we are in the process of connecting
class Connecting extends ConnectionCubitState {
  /// Initializes
  Connecting();

  @override
  String toString() => 'ConnectionState: Connecting...';
}

/// Connected state
class Connected extends ConnectionCubitState {
  @override
  String toString() => 'ConnectionState: Connected';
}

/// Disconnected state
class Disconnected extends ConnectionCubitState {
  @override
  String toString() => 'ConnectionState: Disconnected';
}

/// Reconnecting state
class Reconnecting extends ConnectionCubitState {
  @override
  String toString() => 'ConnectionState: Reconnecting...';
}

/// Connection error state
class ConnectionError extends ConnectionCubitState {
  /// Initializes with the this [error] message
  ConnectionError(this.error);

  /// An exception or message from the server
  final String error;

  @override
  String toString() => 'ConnectionState: Error(error: $error)';
}
