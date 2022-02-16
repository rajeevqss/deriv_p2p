import 'package:flutter_deriv_bloc_manager/base_event_listener.dart';

abstract class HomeCubitEventListener extends BaseEventListener {
void connect();
void disConnect();
}
