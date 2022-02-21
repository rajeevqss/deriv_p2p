import 'package:advert_list_demo/features/advert_list/repository/advert_cubit_repository.dart';
import 'package:bloc/bloc.dart';

import '../models/advert_response.dart';
import 'advert_cubit_state.dart';

class AdvertCubit extends Cubit<AdvertCubitState> {
  AdvertCubit({this.advertCubitRepository}) : super(AdvertCubitInitialState());
  P2pAdvertList? p2pAdvertList;
  AdvertCubitRepository? advertCubitRepository;

  Future<void> getAdvertList(int offset, String counterpartyType) async {
    try {
      emit(AdvertCubitLoadingState());

      final AdvertResponse response =
          await advertCubitRepository!.getList(offset, counterpartyType);
      p2pAdvertList = response.p2pAdvertList;
      emit(AdvertCubitLoadedState(
          p2pAdvertList: response.p2pAdvertList,
          advertList: response.p2pAdvertList!.list!));
    } catch (error) {
      emit(AdvertError(error.toString()));
    }
  }

  Future<void> getAdvertListNext(int offset, String counterpartyType) async {
    try {
      final AdvertResponse response =
          await advertCubitRepository!.getList(offset, counterpartyType);
      p2pAdvertList = response.p2pAdvertList;
      emit(AdvertCubitLoadedState(
          p2pAdvertList: response.p2pAdvertList,
          advertList: response.p2pAdvertList!.list!));
    } catch (error) {
      emit(AdvertError(error.toString()));
    }
  }

  Future<void> search(String search) async {
    final List<AdvertList>? list = p2pAdvertList!.list
        ?.where((AdvertList x) =>
            x.advertiserDetails!.name!.toLowerCase().contains(search))
        .toList();
    print('------------------list length${list!.length}---------------------');
    emit(AdvertCubitLoadedStateForSearch(advertList: list));
  }

  Future<void> sortPrice() async {
    final List<AdvertList>? data = p2pAdvertList!.list;
    data!.sort((AdvertList a, AdvertList b) => b.price!.compareTo(a.price!));

    emit(AdvertCubitLoadedStateForSearch(advertList: data));
  }

  Future<void> sortDate() async {
    final List<AdvertList>? data = p2pAdvertList!.list;
    data!.sort((AdvertList a, AdvertList b) =>
        b.createdTime!.compareTo(a.createdTime!));

    emit(AdvertCubitLoadedStateForSearch(advertList: data));
  }
}
