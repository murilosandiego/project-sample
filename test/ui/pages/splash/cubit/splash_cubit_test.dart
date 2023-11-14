import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/domain/entities/account.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:news_app/domain/usecases/load_current_account.dart';
import 'package:news_app/presentation/pages/splash/cubit/splash_cubit.dart';
import 'package:news_app/presentation/pages/splash/cubit/splash_state.dart';
import 'package:test/test.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

main() {
  late SplashCubit sut;
  late LoadCurrentAccountSpy loadCurrentAccount;
  late Account accountEntity;

  mockLoadAccountWithAccount() => when(() => loadCurrentAccount.load())
      .thenAnswer((_) async => accountEntity);

  mockLoadAccountWithoutAccount() =>
      when(() => loadCurrentAccount.load()).thenAnswer((_) async => null);

  mockLoadAccountWithoutError() =>
      when(() => loadCurrentAccount.load()).thenThrow(DomainError.unexpected);

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();

    sut = SplashCubit(
      loadCurrentAccount: loadCurrentAccount,
    );
    accountEntity = Account(
      token: faker.guid.guid(),
      id: faker.randomGenerator.integer(10),
      username: faker.person.name(),
      email: faker.internet.email(),
    );
  });

  blocTest<SplashCubit, SplashState>(
    'Should call LoadCurrentAccount with success',
    build: () => sut,
    act: (cubit) => cubit.checkAccount(),
    verify: (_) {
      verify(() => loadCurrentAccount.load()).called(1);
    },
  );

  blocTest<SplashCubit, SplashState>(
    'Should emits [SplashToHome] if has account',
    build: () {
      mockLoadAccountWithAccount();
      return sut;
    },
    act: (cubit) => cubit.checkAccount(),
    expect: () => [
      SplashToHome(account: accountEntity),
    ],
  );

  blocTest<SplashCubit, SplashState>(
    'Should emits [SplashToLogin] if has not account',
    build: () {
      mockLoadAccountWithoutAccount();
      return sut;
    },
    act: (cubit) => cubit.checkAccount(),
    expect: () => [
      SplashToLogin(),
    ],
  );

  blocTest<SplashCubit, SplashState>(
    'Should emits [SplashToLogin] if error occurs',
    build: () {
      mockLoadAccountWithoutError();
      return sut;
    },
    act: (cubit) => cubit.checkAccount(),
    expect: () => [
      SplashToLogin(),
    ],
  );
}
