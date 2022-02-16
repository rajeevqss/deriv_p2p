
import 'package:advert_list_demo/event_listener/home_cubit_event_listener.dart';
import 'package:advert_list_demo/state/advert/advert_cubit.dart';
import 'package:flutter_deriv_bloc_manager/base_state_emitter.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/base_bloc_manager.dart';

class HomeCubitStateEmitter
    extends BaseStateEmitter<HomeCubitEventListener, AdvertCubit> {
  /// Initializes account settings state emitter.
  HomeCubitStateEmitter(BaseBlocManager blocManager) : super(blocManager);

  @override
  void handleStates({
    required HomeCubitEventListener eventListener,
    required Object state,
  }) {
    if(state is AdvertCubitInitialState) {
      eventListener.connect();
    }
  }
}
