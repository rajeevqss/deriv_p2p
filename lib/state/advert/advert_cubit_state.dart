
part of 'advert_cubit.dart';
abstract class AdvertCubitState {}

class AdvertCubitInitialState extends AdvertCubitState {
  @override
  String toString() => 'Home Cubit Initial State';
}

class AdvertCubitLoadingState extends AdvertCubitState {

  @override
  String toString() => 'Home Cubit Loading State';
}

class AdvertCubitLoadedState extends AdvertCubitState {

  // /// Initializes
  AdvertCubitLoadedState({
    this.p2pAdvertList,
  });

 final P2pAdvertList? p2pAdvertList;

  @override
  String toString() => 'Home Cubit Loaded State';
}

/// ActiveSymbolsError
class AdvertError extends AdvertCubitState {
  /// Initializes
  AdvertError(this.message);

  /// Error message
  final String? message;

  @override
  String toString() => 'ActiveSymbolsError';
}


