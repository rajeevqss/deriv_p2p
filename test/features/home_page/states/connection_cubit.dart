import 'package:advert_list_demo/features/advert_list/states/advert_cubit.dart';
import 'package:advert_list_demo/features/advert_list/states/advert_cubit_state.dart';
import 'package:advert_list_demo/features/home_page/state/connection/connection_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';





class MockConnectionCubit extends MockCubit<ConnectionCubitState>
    implements ConnectionCubit {}


class FakeConnectionState extends Fake implements ConnectionCubitState {}


void main() {
  setUpAll(() {
    registerFallbackValue(FakeConnectionState());

  });

  group('connection test =>', () {
    test('should connection.', () async {
      final MockConnectionCubit connectionCubit = MockConnectionCubit();

      whenListen(
        connectionCubit,
        Stream<ConnectionCubitState>.fromIterable(
          <ConnectionCubitState>[
            InitialConnectionState(),
            Disconnected(),
            Connected(),
            //assets: assets,
          ],
        ),

      );

      await expectLater(
        connectionCubit.stream,
        emitsInOrder(
          <dynamic>[
            isA<InitialConnectionState>(),
            isA<Disconnected>(),
            isA<Connected>(),
          ],
        ),
      );

      expect(connectionCubit.state, isA<Connected>());


    });

    final Exception exception = Exception('Connection Exception.');

    blocTest<AdvertCubit, AdvertCubitState>(
      'captures exceptions.',
      build: () => AdvertCubit(),
      act: (AdvertCubit cubit) => cubit.addError(exception),
      errors: () => <Matcher>[equals(exception)],
    );
  });
}
