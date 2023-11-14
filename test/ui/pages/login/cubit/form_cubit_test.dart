import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/domain/entities/account.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:news_app/domain/usecases/authentication.dart';
import 'package:news_app/domain/usecases/save_current_account.dart';
import 'package:news_app/presentation/helpers/form_validators.dart';
import 'package:news_app/presentation/helpers/ui_error.dart';
import 'package:news_app/presentation/pages/login/cubit/login_cubit.dart';
import 'package:news_app/presentation/pages/login/cubit/login_state.dart';

class AuthenticationSpy extends Mock implements Authentication {}

class SaveAccountSpy extends Mock implements SaveCurrentAccount {}

class FakeAuthenticationParams extends Fake implements AuthenticationParams {}

main() {
  late LoginCubit sut;
  late AuthenticationSpy authentication;
  late SaveAccountSpy saveCurrentAccount;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticationParams());
  });

  setUp(() {
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveAccountSpy();

    sut = LoginCubit(
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );

    when(() => authentication.auth(any())).thenAnswer(
      (_) async => Account(
        token: 'token',
        id: 1,
        username: 'user',
        email: 'email',
      ),
    );

    when(() => saveCurrentAccount.save(Account(
          token: 'token',
          id: 1,
          username: 'user',
          email: 'email',
        ))).thenAnswer((_) => Future.value());
  });

  blocTest<LoginCubit, LoginState>(
    'Should emits LoginState with Email.pure if email is invalid',
    build: () => sut,
    act: (cubit) => cubit.handleEmail('invalid_email'),
    expect: () => [
      LoginState(
        email: Email.dirty('invalid_email'),
      ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'Should emits LoginState with Email.dirty if email is valid',
    build: () => sut,
    act: (cubit) => cubit.handleEmail('mail@mail.com'),
    expect: () => [
      LoginState(
        email: Email.dirty('mail@mail.com'),
      ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'Should emits LoginState with Password.pure if password is invalid',
    build: () => sut,
    act: (cubit) => cubit.handlePassword('123'),
    expect: () => [
      LoginState(
        password: Password.dirty('123'),
      ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'Should emits LoginState with Password.dirty if password is valid',
    build: () => sut,
    act: (cubit) => cubit.handlePassword('123456'),
    expect: () => [
      LoginState(
        password: Password.dirty('123456'),
      ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'Should call Authentication with correct values',
    build: () => sut,
    act: (cubit) {
      cubit.handlePassword('123456');
      cubit.handleEmail('mail@mail.com');
      cubit.auth();
    },
    verify: (_) {
      verify(() => authentication.auth(
              AuthenticationParams(email: 'mail@mail.com', secret: '123456')))
          .called(1);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'Should call saveCurrentAccount with correct values',
    build: () {
      when(() => authentication.auth(any())).thenAnswer(
        (_) async => Account(
          token: 'token',
          id: 1,
          username: 'user',
          email: 'email',
        ),
      );
      return sut;
    },
    act: (cubit) async {
      cubit.handlePassword('123456');
      cubit.handleEmail('mail@mail.com');
      await cubit.auth();
    },
    verify: (_) {
      verify(() => saveCurrentAccount.save(
              Account(token: 'token', id: 1, username: 'user', email: 'email')))
          .called(1);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'Should emits correct events on InvalidCredentialsError',
    build: () {
      when(() => authentication.auth(any()))
          .thenThrow(DomainError.invalidCredentials);
      return sut;
    },
    act: (cubit) async {
      cubit.handleEmail('mail@mail.com');
      cubit.handlePassword('123456');
      await cubit.auth();
    },
    expect: () => [
      LoginState(
        email: Email.dirty('mail@mail.com'),
      ),
      LoginState(
        email: Email.dirty('mail@mail.com'),
        password: Password.dirty('123456'),
      ),
      LoginState(
        email: Email.dirty('mail@mail.com'),
        password: Password.dirty('123456'),
        formSubmissionsStatus: FormzSubmissionStatus.inProgress,
      ),
      LoginState(
        email: Email.dirty('mail@mail.com'),
        password: Password.dirty('123456'),
        errorMessage: UIError.invalidCredentials.description,
        formSubmissionsStatus: FormzSubmissionStatus.failure,
      ),
      LoginState(
        email: Email.dirty('mail@mail.com'),
        password: Password.dirty('123456'),
        errorMessage: '',
        formSubmissionsStatus: FormzSubmissionStatus.initial,
      )
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'Should emits correct events on Unexpected',
    build: () {
      when(() => authentication.auth(any())).thenThrow(DomainError.unexpected);
      return sut;
    },
    act: (cubit) async {
      cubit.handleEmail('mail@mail.com');
      cubit.handlePassword('123456');
      await cubit.auth();
    },
    expect: () => [
      LoginState(
        email: Email.dirty('mail@mail.com'),
      ),
      LoginState(
        email: Email.dirty('mail@mail.com'),
        password: Password.dirty('123456'),
      ),
      LoginState(
        email: Email.dirty('mail@mail.com'),
        password: Password.dirty('123456'),
        formSubmissionsStatus: FormzSubmissionStatus.inProgress,
      ),
      LoginState(
        email: Email.dirty('mail@mail.com'),
        password: Password.dirty('123456'),
        formSubmissionsStatus: FormzSubmissionStatus.failure,
        errorMessage: UIError.unexpected.description,
      ),
      LoginState(
        email: Email.dirty('mail@mail.com'),
        password: Password.dirty('123456'),
        formSubmissionsStatus: FormzSubmissionStatus.initial,
        errorMessage: '',
      )
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'Should call UserManager with correct values',
    build: () {
      when(() => authentication.auth(any())).thenAnswer(
        (_) async =>
            Account(token: 'token', id: 1, username: 'user', email: 'email'),
      );
      return sut;
    },
    act: (cubit) async {
      cubit.handlePassword('123456');
      cubit.handleEmail('mail@mail.com');
      await cubit.auth();
    },
  );
}
