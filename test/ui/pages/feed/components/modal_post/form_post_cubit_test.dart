import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:news_app/presentation/helpers/form_validators.dart';
import 'package:news_app/presentation/pages/feed/components/modal_post/cubit/form_post_cubit.dart';
import 'package:test/test.dart';

main() {
  late FormPostCubit sut;
  final String invalidMessage = faker.randomGenerator.string(300, min: 281);
  final String validMessage = faker.randomGenerator.string(280, min: 280);

  setUp(() {
    sut = FormPostCubit();
  });

  blocTest<FormPostCubit, FormPostState>(
    'Should emits LoginState with MessageInput.pure if message is invalid',
    build: () => sut,
    act: (cubit) => cubit.handleMessage(invalidMessage),
    expect: () => [
      FormPostState(
        message: MessageInput.dirty(invalidMessage),
      ),
    ],
  );

  blocTest<FormPostCubit, FormPostState>(
    'Should emits LoginState with MessageInput.pure if message is empty',
    build: () => sut,
    act: (cubit) => cubit.handleMessage(''),
    expect: () => [
      FormPostState(
        message: MessageInput.dirty(''),
      ),
    ],
  );

  blocTest<FormPostCubit, FormPostState>(
    'Should emits LoginState with MessageInput.dirty if message is valid',
    build: () => sut,
    act: (cubit) => cubit.handleMessage(validMessage),
    expect: () => [
      FormPostState(
        message: MessageInput.dirty(validMessage),
      ),
    ],
  );
}
