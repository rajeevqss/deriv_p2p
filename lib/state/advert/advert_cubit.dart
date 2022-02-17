import 'package:advert_list_demo/models/token_request.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_deriv_api/basic_api/response.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/binary_api.dart';

import 'models/advert_request.dart';
import 'models/advert_response.dart';

part 'advert_cubit_state.dart';

class AdvertCubit extends Cubit<AdvertCubitState> {
  AdvertCubit({this.api}) : super(AdvertCubitInitialState());
  BinaryAPI? api;
  P2pAdvertList? p2pAdvertList;

  Future<void> getAdvertList(int offset, String counterpartyType) async {
    try {
      emit(AdvertCubitLoadingState());

      final AdvertResponse response = await getList(offset, counterpartyType);
      p2pAdvertList = response.p2pAdvertList;
      emit(AdvertCubitLoadedState(
          p2pAdvertList: response.p2pAdvertList,
          advertList: response.p2pAdvertList!.list!));
    } catch (error) {
      emit(AdvertError(error.toString()));
    }
  }

  Future<AdvertResponse> getList(int offset, String counterpartyType) async {
    final Response response1 = await api!.call<Response>(
        request: const TokenRequest(authorize: 'wThCsCkSSms4Qmz', reqId: 1));
    final Response response = await api!.call<Response>(
        request: AdvertRequest(
            counterpartyType: counterpartyType,
            p2pAdvertList: 1,
            limit: 10,
            offset: offset));
    return AdvertResponse.fromJson(response.toJson());
  }

  Future<void> search(String search) async {
    var list = p2pAdvertList!.list
        ?.where(
            (x) => x.advertiserDetails!.name!.toLowerCase().contains(search))
        .toList();

    emit(AdvertCubitLoadedState(advertList: list));
  }

  Future<void> sortPrice() async {
    var data = p2pAdvertList!.list;
    data!.sort((a, b) {
      return b.price!.compareTo(a.price!);
    });

    emit(AdvertCubitLoadedState(advertList: data));
  }

  Future<void> sortDate() async {
    var data = p2pAdvertList!.list;
    data!.sort((a, b) {
      return b.createdTime!.compareTo(a.createdTime!);
    });

    emit(AdvertCubitLoadedState(advertList: data));
  }
}
