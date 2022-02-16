import 'dart:convert';

import 'package:advert_list_demo/models/token_request.dart';
import 'package:advert_list_demo/state/connection/connection_cubit.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter_deriv_api/basic_api/response.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/bloc_manager.dart';

import 'models/advert_request.dart';
import 'models/advert_response.dart';

part 'advert_cubit_state.dart';

class AdvertCubit extends Cubit<AdvertCubitState> {
  AdvertCubit() : super(AdvertCubitInitialState());


  Future<void> getAdvertList(int offset) async {

    try {
      emit(AdvertCubitLoadingState());

      final AdvertResponse response = await getList(offset);
      emit(AdvertCubitLoadedState(p2pAdvertList: response.p2pAdvertList));
    }
    catch (error) {
      emit(AdvertError(error.toString()));
    }
  }

  Future<AdvertResponse> getList(int offset) async {
    final Response response1 = await  BlocManager.instance
        .fetch<ConnectionCubit>()
        .api!.call<Response>(request: TokenRequest(authorize: 'wThCsCkSSms4Qmz',reqId: 1));
   ///print('${response1}');

    final Response response = await BlocManager.instance
        .fetch<ConnectionCubit>()
        .api!
        .call<Response>(
            request: AdvertRequest(counterpartyType: 'buy', p2pAdvertList: 1,reqId: 2,limit: 50,offset:offset ));
    print('advertise jitendra ---------------------${response}');
    return AdvertResponse.fromJson(response.toJson());
  }
}
