import 'package:advert_list_demo/state/advert/advert_cubit.dart';
import 'package:advert_list_demo/state/advert/models/advert_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_deriv_api/api/api_initializer.dart';

import '../../sample_data/data.dart';




class MockAdvertCubit extends MockCubit<AdvertCubitState>
    implements AdvertCubit {}


class FakeAdvertState extends Fake implements AdvertCubitState {}


void main() {
  setUpAll(() {
    registerFallbackValue(FakeAdvertState());
  });

  group('advert list test =>', () {
    test('should advert list.', () async {
      final MockAdvertCubit advertCubit = MockAdvertCubit();

      whenListen(
        advertCubit,
        Stream<AdvertCubitState>.fromIterable(
          <AdvertCubitState>[
            AdvertCubitInitialState(),
            AdvertCubitLoadingState(),
            AdvertCubitLoadedState(advertList: advertList),
              //assets: assets,
          ],
        ),

      );

      await expectLater(
        advertCubit.stream,
        emitsInOrder(
          <dynamic>[
            isA<AdvertCubitInitialState>(),
            isA<AdvertCubitLoadingState>(),
            isA<AdvertCubitLoadedState>(),
          ],
        ),
      );

      expect(advertCubit.state, isA<AdvertCubitLoadedState>());

      final AdvertCubitLoadedState currentState =
      advertCubit.state as AdvertCubitLoadedState;

      expect(currentState.advertList, isNotNull);
      expect(currentState.advertList, isA<List<AdvertList?>>());

    });

    final Exception exception = Exception('Advert Cubit Exception.');

    blocTest<AdvertCubit, AdvertCubitState>(
      'captures exceptions.',
      build: () => AdvertCubit(),
      act: (AdvertCubit cubit) => cubit.addError(exception),
      errors: () => <Matcher>[equals(exception)],
    );
  });
}
