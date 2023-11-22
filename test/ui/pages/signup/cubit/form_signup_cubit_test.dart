import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/domain/entities/account.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:news_app/domain/usecases/add_account.dart';
import 'package:news_app/domain/usecases/save_current_account.dart';
import 'package:news_app/presentation/helpers/form_validators.dart';
import 'package:news_app/presentation/helpers/ui_error.dart';
import 'package:news_app/presentation/pages/signup/cubit/form_sign_up_cubit.dart';
import 'package:news_app/presentation/pages/signup/cubit/form_sign_up_state.dart';

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

class FakeAddAccountParams extends Fake implements AddAccountParams {}

class FakeAccountEntity extends Fake implements Account {}

main() {
  late FormSignUpCubit sut;
  late AddAccountSpy addAccount;
  late SaveCurrentAccountSpy saveCurrentAccount;

  final String validUsername = faker.person.firstName();
  final String validEmail = faker.internet.email();
  final String validPassword = faker.internet.password();
  final String token = faker.guid.guid();

  final String invalidUsername = 'us';
  final String invalidEmail = 'invalid_email';
  final String invalidPassword = '12345';

  final successFlowSubmitForm = [
    FormSignUpState(
      name: NameInput.dirty(validUsername),
    ),
    FormSignUpState(
      name: NameInput.dirty(validUsername),
      email: Email.dirty(validEmail),
    ),
    FormSignUpState(
      name: NameInput.dirty(validUsername),
      email: Email.dirty(validEmail),
      password: Password.dirty(validPassword),
    ),
    FormSignUpState(
      name: NameInput.dirty(validUsername),
      email: Email.dirty(validEmail),
      password: Password.dirty(validPassword),
      formSubmissionStatus: FormzSubmissionStatus.inProgress,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeAddAccountParams());
    registerFallbackValue(FakeAccountEntity());
  });

  setUp(() {
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = FormSignUpCubit(
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );

    when(() => addAccount.add(any())).thenAnswer(
      (_) async => Account(
        token: token,
        id: 1,
        username: validUsername,
        email: 'email',
      ),
    );

    when(() => saveCurrentAccount.save(any())).thenAnswer(
      (_) => Future.value(),
    );
  });

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should emits FormSignUpState with NameInput.dirty if name is valid',
    build: () => sut,
    act: (cubit) => cubit.handleName(validUsername),
    expect: () => [
      FormSignUpState(
        name: NameInput.dirty(validUsername),
      ),
    ],
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should emits FormSignUpState with NameInput.pure if name is invalid',
    build: () => sut,
    act: (cubit) => cubit.handleName(invalidUsername),
    expect: () => [
      FormSignUpState(
        name: NameInput.dirty(invalidUsername),
      ),
    ],
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should emits FormSignUpState with Email.dirty if email is valid',
    build: () => sut,
    act: (cubit) => cubit.handleEmail(validEmail),
    expect: () => [
      FormSignUpState(
        email: Email.dirty(validEmail),
      ),
    ],
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should emits FormSignUpState with Email.pure if email is invalid',
    build: () => sut,
    act: (cubit) => cubit.handleEmail(invalidEmail),
    expect: () => [
      FormSignUpState(
        email: Email.dirty(invalidEmail),
      ),
    ],
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should emits FormSignUpState with Password.dirty if password is valid',
    build: () => sut,
    act: (cubit) => cubit.handlePassword(validPassword),
    expect: () => [
      FormSignUpState(
        password: Password.dirty(validPassword),
      ),
    ],
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should emits FormSignUpState with Password.pure if password is invalid',
    build: () => sut,
    act: (cubit) => cubit.handlePassword(invalidPassword),
    expect: () => [
      FormSignUpState(
        password: Password.dirty(invalidPassword),
      ),
    ],
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should call AddAccount with correct values',
    build: () => sut,
    act: (cubit) {
      cubit.handleName(validUsername);
      cubit.handlePassword(validPassword);
      cubit.handleEmail(validEmail);
      cubit.add();
    },
    verify: (_) {
      verify(() => addAccount.add(AddAccountParams(
            email: validEmail,
            secret: validPassword,
            name: validUsername,
          ))).called(1);
    },
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should call SaveCurrentAccount with correct values',
    build: () {
      when(() => addAccount.add(any())).thenAnswer(
        (_) async => Account(
            token: token, id: 1, username: validUsername, email: 'email'),
      );
      return sut;
    },
    act: (cubit) async {
      cubit.handleName(validUsername);
      cubit.handlePassword(validPassword);
      cubit.handleEmail(validEmail);
      await cubit.add();
    },
    verify: (_) {
      verify(() => saveCurrentAccount.save(Account(
          token: token,
          id: 1,
          username: validUsername,
          email: 'email'))).called(1);
    },
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should not call AddAccount and SaveCurrentAccount if is form invalid',
    build: () => sut,
    act: (cubit) {
      cubit.handleName(invalidUsername);
      cubit.handleEmail(validEmail);
      cubit.handlePassword(validPassword);
      cubit.add();
    },
    verify: (_) {
      verifyNever(() => addAccount.add(AddAccountParams(
            name: invalidUsername,
            email: validEmail,
            secret: validPassword,
          )));
    },
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should emits correct events on InvalidCredentialsError',
    build: () {
      when(() => addAccount.add(any()))
          .thenThrow(DomainError.invalidCredentials);
      return sut;
    },
    act: (cubit) async {
      cubit.handleName(validUsername);
      cubit.handleEmail(validEmail);
      cubit.handlePassword(validPassword);
      await cubit.add();
    },
    expect: () => [
      ...successFlowSubmitForm,
      FormSignUpState(
        name: NameInput.dirty(validUsername),
        email: Email.dirty(validEmail),
        password: Password.dirty(validPassword),
        formSubmissionStatus: FormzSubmissionStatus.failure,
        errorMessage: UIError.emailInUse.description,
      ),
      FormSignUpState(
        name: NameInput.dirty(validUsername),
        email: Email.dirty(validEmail),
        password: Password.dirty(validPassword),
        formSubmissionStatus: FormzSubmissionStatus.initial,
        errorMessage: '',
      )
    ],
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should emits correct events on Unexpected',
    build: () {
      when(() => addAccount.add(any())).thenThrow(DomainError.unexpected);
      return sut;
    },
    act: (cubit) async {
      cubit.handleName(validUsername);
      cubit.handleEmail(validEmail);
      cubit.handlePassword(validPassword);
      await cubit.add();
    },
    expect: () => [
      ...successFlowSubmitForm,
      FormSignUpState(
        name: NameInput.dirty(validUsername),
        email: Email.dirty(validEmail),
        password: Password.dirty(validPassword),
        formSubmissionStatus: FormzSubmissionStatus.failure,
        errorMessage: UIError.unexpected.description,
      ),
      FormSignUpState(
        name: NameInput.dirty(validUsername),
        email: Email.dirty(validEmail),
        password: Password.dirty(validPassword),
        formSubmissionStatus: FormzSubmissionStatus.initial,
        errorMessage: '',
      )
    ],
  );

  blocTest<FormSignUpCubit, FormSignUpState>(
    'Should call UserManager with correct values',
    build: () {
      when(() => addAccount.add(any())).thenAnswer(
        (_) async => Account(
            token: token, id: 1, username: validUsername, email: 'email'),
      );
      return sut;
    },
    act: (cubit) async {
      cubit.handleName(validUsername);
      cubit.handlePassword(validPassword);
      cubit.handleEmail(validEmail);
      await cubit.add();
    },
  );
}
