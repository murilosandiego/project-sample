import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
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

class FormSignUpCubitSpy extends MockCubit<FormSignUpState>
    implements FormSignUpCubit {}

class FeedCubitSpy extends MockCubit<FeedState> implements FeedCubit {}

class FormLoginCubitSpy extends MockCubit<LoginState> implements LoginCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

class UserCubitSpy extends MockCubit<UserState> implements UserCubit {}

main() {
  late FormSignUpCubitSpy formSignCubit;
  late MockNavigatorObserver navigatorObserver;
  late FeedCubitSpy feedCubit;
  late FormLoginCubitSpy formLoginCubit;
  late UserCubitSpy userCubit;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    formSignCubit = FormSignUpCubitSpy();
    feedCubit = FeedCubitSpy();
    userCubit = UserCubitSpy();
    formLoginCubit = FormLoginCubitSpy();
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
          initialRoute: AppRoutes.signUp,
          routes: routes,
          navigatorObservers: [navigatorObserver],
        ),
      ),
    );
  }

  testWidgets('Should call handles with correct values', (tester) async {
    when(() => formSignCubit.state).thenReturn(FormSignUpState());

    await loadPage(tester);

    final name = faker.person.firstName();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => formSignCubit.handleName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(() => formSignCubit.handleEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => formSignCubit.handlePassword(password));
  });

  testWidgets('Should show error message if name is invalid', (tester) async {
    when(() => formSignCubit.state)
        .thenReturn(FormSignUpState(name: NameInput.dirty('us')));

    await loadPage(tester);
    await tester.pump();

    expect(find.text(PresentationConstants.veryShortName), findsOneWidget);
  });

  testWidgets('Should show error message if name is empty', (tester) async {
    when(() => formSignCubit.state).thenReturn(FormSignUpState());

    whenListen<FormSignUpState>(
      formSignCubit,
      Stream.fromIterable(
        [
          FormSignUpState(
            email: Email.pure('mail@mail.com'),
            name: NameInput.dirty(''),
            password: Password.dirty('123456'),
          ),
        ],
      ),
    );
    await loadPage(tester);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Should show error message if email is invalid', (tester) async {
    when(() => formSignCubit.state)
        .thenReturn(FormSignUpState(email: Email.dirty('invalid')));

    await loadPage(tester);
    await tester.pump();

    expect(find.text(PresentationConstants.invalidEmail), findsOneWidget);
  });

  testWidgets('Should show error message if email is empty', (tester) async {
    when(() => formSignCubit.state).thenReturn(FormSignUpState());

    whenListen<FormSignUpState>(
      formSignCubit,
      Stream.fromIterable(
        [
          FormSignUpState(
            email: Email.dirty(''),
            name: NameInput.dirty('name'),
            password: Password.dirty('123456'),
          )
        ],
      ),
    );
    await loadPage(tester);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Should show error if password is invalid', (tester) async {
    when(() => formSignCubit.state).thenReturn(FormSignUpState());

    whenListen<FormSignUpState>(
      formSignCubit,
      Stream.fromIterable(
        [FormSignUpState(password: Password.dirty('123'))],
      ),
    );
    await loadPage(tester);
    await tester.pump();

    expect(find.text(PresentationConstants.passwordTooShort), findsOneWidget);
  });

  testWidgets('Should show error if password is empty', (tester) async {
    when(() => formSignCubit.state).thenReturn(FormSignUpState());

    whenListen<FormSignUpState>(
      formSignCubit,
      Stream.fromIterable(
        [
          FormSignUpState(
            email: Email.pure('mail@mail.com'),
            name: NameInput.dirty('name'),
            password: Password.dirty(''),
          ),
        ],
      ),
    );
    await loadPage(tester);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Should show snackBar if unexpected ocurrs', (tester) async {
    when(() => formSignCubit.state).thenReturn(FormSignUpState());

    whenListen<FormSignUpState>(
      formSignCubit,
      Stream.fromIterable(
        [
          FormSignUpState(
            errorMessage: UIError.unexpected.description,
            formSubmissionStatus: FormzSubmissionStatus.failure,
          )
        ],
      ),
    );

    await loadPage(tester);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(UIError.unexpected.description), findsOneWidget);
  });

  testWidgets('Should pop page if Icons.close pressed',
      (WidgetTester tester) async {
    when(() => formSignCubit.state).thenReturn(FormSignUpState());
    when(() => formLoginCubit.state).thenReturn(LoginState());

    await loadPage(tester);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    verify(() => navigatorObserver.didPop(any(), any()));
  });
}
