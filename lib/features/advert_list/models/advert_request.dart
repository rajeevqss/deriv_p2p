import 'package:flutter_deriv_api/basic_api/request.dart';

/// counterparty_type : "buy"
/// p2p_advert_list : 1

class AdvertRequest extends Request {
  AdvertRequest(
      {String? counterpartyType,
      int? p2pAdvertList,
      Map<String, dynamic>? passthrough,
      int? reqId,
      int? limit,
      int? offset})
      : super(
          msgType: 'AdvertRequest',
          passthrough: passthrough,
          reqId: reqId,
        ) {
    _counterpartyType = counterpartyType;
    _p2pAdvertList = p2pAdvertList;
    _reqId = reqId;
    _passthrough = passthrough;
    _limit = limit;
    _offset = offset;
  }

  @override
  AdvertRequest copyWith(
          {String? counterpartyType,
          int? p2pAdvertList,
          Map<String, dynamic>? passthrough,
          int? reqId,
          int? limit,
          int? offset}) =>
      AdvertRequest(
          reqId: reqId,
          passthrough: passthrough,
          p2pAdvertList: _p2pAdvertList,
          counterpartyType: _counterpartyType,
          limit: _limit,
          offset: _offset);

  AdvertRequest.fromJson(dynamic json) {
    _counterpartyType = json['counterparty_type'];
    _p2pAdvertList = json['p2p_advert_list'];
    _passthrough = json['passthrough'];
    _reqId = json['req_id'];
    _offset = json['offset'];
    _limit = json['limit'];
  }

  String? _counterpartyType;
  int? _p2pAdvertList;

  Map<String, dynamic>? _passthrough;

  int? _reqId;

  int? _limit;
  int? _offset;

  int? get limit => _limit;

  int? get offest => _offset;

  String? get counterpartyType => _counterpartyType;

  int? get p2pAdvertList => _p2pAdvertList;

  Map<String, dynamic>? get passthrough => _passthrough;

  int? get reqId => _reqId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['counterparty_type'] = _counterpartyType;
    map['p2p_advert_list'] = _p2pAdvertList;
    map['passthrough'] = _passthrough;
    map['req_id'] = _reqId;
    map['offset'] = _offset;
    map['limit'] = _limit;
    return map;
  }

  int? get offset => _offset;
}
