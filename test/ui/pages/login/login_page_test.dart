import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/domain/entities/user.dart';
import 'package:news_app/main/routes/app_routes.dart';
import 'package:news_app/presentation/helpers/form_validators.dart';
import 'package:news_app/presentation/helpers/presentation_constants.dart';
import 'package:news_app/presentation/helpers/ui_error.dart';
import 'package:news_app/presentation/pages/feed/cubit/feed_cubit.dart';
import 'package:news_app/presentation/pages/feed/cubit/feed_state.dart';
import 'package:news_app/presentation/pages/feed/feed_page.dart';
import 'package:news_app/presentation/pages/login/cubit/login_cubit.dart';
import 'package:news_app/presentation/pages/login/cubit/login_state.dart';
import 'package:news_app/presentation/pages/login/login_page.dart';
import 'package:news_app/presentation/pages/signup/cubit/form_sign_up_cubit.dart';
import 'package:news_app/presentation/pages/signup/cubit/form_sign_up_state.dart';
import 'package:news_app/presentation/pages/signup/signup_page.dart';
import 'package:news_app/presentation/user/user_cubit.dart';

class FormLoginCubitSpy extends MockCubit<LoginState> implements LoginCubit {}

class FormSignUpCubitSpy extends MockCubit<FormSignUpState>
    implements FormSignUpCubit {}

class FeedCubitSpy extends MockCubit<FeedState> implements FeedCubit {}

class UserCubitSpy extends MockCubit<UserState> implements UserCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

main() {
  late FormLoginCubitSpy formLoginCubit;
  late MockNavigatorObserver navigatorObserver;
  late FeedCubitSpy feedCubit;
  late FormSignUpCubitSpy formSignCubit;
  late UserCubitSpy userCubit;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    formLoginCubit = FormLoginCubitSpy();
    formSignCubit = FormSignUpCubitSpy();
    feedCubit = FeedCubitSpy();
    userCubit = UserCubitSpy();
    navigatorObserver = MockNavigatorObserver();
  });

  Future loadPage(
    WidgetTester tester,
  ) async {
    final Map<String, WidgetBuilder> routes = {
      AppRoutes.signUp: (_) => BlocProvider<FormSignUpCubit>.value(
            value: formSignCubit,
            child: SignUpPage(),
          ),
      AppRoutes.feed: (_) => BlocProvider<FeedCubit>.value(
            value: feedCubit,
            child: FeedPage(),
          ),
      AppRoutes.login: (_) => BlocProvider<LoginCubit>.value(
            value: formLoginCubit,
            child: LoginPage(),
          ),
    };

    await tester.pumpWidget(
      BlocProvider<UserCubit>.value(
        value: userCubit,
        child: MaterialApp(
          initialRoute: AppRoutes.login,
          routes: routes,
          navigatorObservers: [navigatorObserver],
        ),
      ),
    );
  }

  testWidgets('Should call handles with correct values', (tester) async {
    when(() => formLoginCubit.state).thenReturn(LoginState());

    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(() => formLoginCubit.handleEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => formLoginCubit.handlePassword(password));
  });

  testWidgets('Should show error message if email is invalid', (tester) async {
    when(() => formLoginCubit.state).thenReturn(LoginState());

    whenListen<LoginState>(
      formLoginCubit,
      Stream.fromIterable(
        [LoginState(email: Email.dirty('invalid'))],
      ),
    );
    await loadPage(tester);
    await tester.pump();

    expect(find.text(PresentationConstants.invalidEmail), findsOneWidget);
  });

  testWidgets('Should show error message if email is empty', (tester) async {
    when(() => formLoginCubit.state).thenReturn(
      LoginState(
        email: Email.dirty(''),
        password: Password.dirty('123456'),
      ),
    );

    await loadPage(tester);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Should show error if password is invalid', (tester) async {
    when(() => formLoginCubit.state).thenReturn(LoginState());

    whenListen<LoginState>(
      formLoginCubit,
      Stream.fromIterable(
        [LoginState(password: Password.dirty('123'))],
      ),
    );
    await loadPage(tester);
    await tester.pump();

    expect(find.text(PresentationConstants.passwordTooShort), findsOneWidget);
  });

  testWidgets('Should show error if password is empty', (tester) async {
    when(() => formLoginCubit.state).thenReturn(
      LoginState(
        password: Password.dirty(''),
        email: Email.dirty('email@mail.com'),
      ),
    );

    await loadPage(tester);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Should go to FeedPage if is Submission Success',
      (WidgetTester tester) async {
    when(() => formLoginCubit.state).thenReturn(LoginState());
    when(() => feedCubit.state).thenReturn(FeedInitial());
    when(() => userCubit.state).thenReturn(
      UserState(
        user: User(
          id: 2,
          name: 'name',
          email: 'email',
        ),
      ),
    );

    whenListen<LoginState>(
      formLoginCubit,
      Stream.fromIterable(
        [LoginState(formSubmissionsStatus: FormzSubmissionStatus.success)],
      ),
    );

    await loadPage(tester);

    await tester.pumpAndSettle();

    verify(() => navigatorObserver.didPush(any(), any()));
    expect(find.byType(FeedPage), findsOneWidget);
  });

  testWidgets('Should show snackBar if unexpected error occurs',
      (tester) async {
    when(() => formLoginCubit.state).thenReturn(LoginState());

    whenListen<LoginState>(
      formLoginCubit,
      Stream.fromIterable(
        [
          LoginState(
            errorMessage: UIError.unexpected.description,
            formSubmissionsStatus: FormzSubmissionStatus.failure,
          )
        ],
      ),
    );

    await loadPage(tester);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(UIError.unexpected.description), findsOneWidget);
  });

  testWidgets('Should go to SignupPage if tap in CreateAccountButton ',
      (WidgetTester tester) async {
    when(() => formSignCubit.state).thenReturn(FormSignUpState());
    when(() => formLoginCubit.state).thenReturn(LoginState());

    await loadPage(tester);

    await tester.tap(find.text('Não tem conta? Cadastrar'));
    await tester.pumpAndSettle();

    verify(() => navigatorObserver.didPush(any(), any()));
    expect(find.byType(SignUpPage), findsOneWidget);
  });
}
