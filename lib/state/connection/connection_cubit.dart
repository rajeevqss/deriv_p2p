import 'package:advert_list_demo/event_listener/home_cubit_event_listener.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_deriv_api/api/api_initializer.dart';
import 'package:flutter_deriv_api/basic_api/generated/api.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/base_api.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/binary_api.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:flutter_deriv_api/services/dependency_injector/injector.dart';

part 'connection_cubit_state.dart';

class ConnectionCubit extends Cubit<ConnectionCubitState>
    implements HomeCubitEventListener {
  ConnectionCubit() : super(InitialConnectionState());
  BinaryAPI? api;
  final UniqueKey _uniqueKey = UniqueKey();
   Duration _callTimeOut = Duration(seconds: 10);
  @override
  void connect()  {
    openWebsocket();
  }

  @override
  void disConnect() {}

  Future<void> openWebsocket() async {
 //   APIInitializer().initialize(isMock:false,uniqueKey: _uniqueKey);
    // _api = Injector.getInjector().get<BaseAPI>();
    api=BinaryAPI(UniqueKey());
    await api?.disconnect().timeout(_callTimeOut);
    await api?.connect(
      ConnectionInformation(
        appId: '1089',
        brand: 'binary',
        endpoint: 'frontend.binaryws.com',
      ),
      onDone: (UniqueKey key) {
        if (_uniqueKey == key) {
          api!.disconnect();
          emit(Disconnected());
        }
      },
      onOpen: (UniqueKey key) {
       // if (_uniqueKey == key) {
          emit(Connected());
       // }
      },
      onError: (UniqueKey key) {
        if (_uniqueKey == key) {
          // emit(ConnectionError(error));
        }
      },
    );

    final PingResponse response=await api!.call<PingResponse>(request: PingRequest());

    print('--------------${response.toJson()}');
  }
}
