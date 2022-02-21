import 'package:advert_list_demo/core/models/token/token_request.dart';
import 'package:advert_list_demo/features/advert_list/models/advert_request.dart';
import 'package:advert_list_demo/features/advert_list/models/advert_response.dart';
import 'package:advert_list_demo/utils/string_conts.dart';
import 'package:flutter_deriv_api/basic_api/response.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/binary_api.dart';

class AdvertCubitRepository {
  AdvertCubitRepository({this.api});

  BinaryAPI? api;

  Future<AdvertResponse> getList(int offset, String counterpartyType) async {
    final Response response1 = await api!.call<Response>(
        request: const TokenRequest(authorize: token, reqId: 1));
    final Response response = await api!.call<Response>(
        request: AdvertRequest(
            counterpartyType: counterpartyType,
            p2pAdvertList: 1,
            limit: 10,
            offset: offset));
    return AdvertResponse.fromJson(response.toJson());
  }
}
