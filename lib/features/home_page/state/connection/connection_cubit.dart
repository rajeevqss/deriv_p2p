import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_deriv_api/basic_api/generated/api.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/binary_api.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';

part 'connection_cubit_state.dart';

class ConnectionCubit extends Cubit<ConnectionCubitState> {
  ConnectionCubit() : super(InitialConnectionState());
  BinaryAPI? _api;
  final UniqueKey _uniqueKey = UniqueKey();
  final Duration _callTimeOut = const Duration(seconds: 10);

  BinaryAPI? get api => _api;

  void connect() {
    openWebsocket();
  }

  void disConnect() {
    api?.disconnect();
  }

  Future<void> openWebsocket() async {
    _api = BinaryAPI(UniqueKey());
    await api?.disconnect().timeout(_callTimeOut);
    await api?.connect(
      ConnectionInformation(
        appId: '1089',
        brand: 'binary',
        endpoint: 'frontend.binaryws.com',
      ),
      onDone: (UniqueKey key) {
        api!.disconnect();
        emit(Disconnected());
      },
      onOpen: (UniqueKey key) {
        emit(Connected());
      },
      onError: (UniqueKey key) {
        if (_uniqueKey == key) {
          // emit(ConnectionError(error));
        }
      },
    );

    final PingResponse response =
        await api!.call<PingResponse>(request: const PingRequest());
  }
}
