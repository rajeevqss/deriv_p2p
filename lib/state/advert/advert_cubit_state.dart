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
  AdvertCubitLoadedState(
      {this.p2pAdvertList, this.advertList, this.searchData});

  final P2pAdvertList? p2pAdvertList;
  final List<AdvertList>? advertList;
  final String? searchData;

  AdvertCubitLoadedState copyWith(
      {P2pAdvertList? p2pAdvertList1, String? searchData1}) {
    return AdvertCubitLoadedState(
        p2pAdvertList: p2pAdvertList1 ?? p2pAdvertList,
        searchData: searchData1 ?? searchData);
  }

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
