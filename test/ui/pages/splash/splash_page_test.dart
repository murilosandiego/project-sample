import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/domain/entities/account.dart';
import 'package:news_app/domain/entities/user.dart';
import 'package:news_app/main/routes/app_routes.dart';
import 'package:news_app/presentation/pages/feed/cubit/feed_cubit.dart';
import 'package:news_app/presentation/pages/feed/cubit/feed_state.dart';
import 'package:news_app/presentation/pages/feed/feed_page.dart';
import 'package:news_app/presentation/pages/login/login_page.dart';
import 'package:news_app/presentation/pages/splash/cubit/splash_cubit.dart';
import 'package:news_app/presentation/pages/splash/cubit/splash_state.dart';
import 'package:news_app/presentation/pages/splash/splash_page.dart';
import 'package:news_app/presentation/user/user_cubit.dart';

class SplashCubitSpy extends MockCubit<SplashState> implements SplashCubit {}

class FeedCubitSpy extends MockCubit<FeedState> implements FeedCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

class UserCubitSpy extends MockCubit<UserState> implements UserCubit {}

main() {
  late SplashCubitSpy splashCubit;
  late MockNavigatorObserver navigatorObserver;
  late FeedCubitSpy feedCubit;
  late UserCubitSpy userCubit;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    splashCubit = SplashCubitSpy();
    feedCubit = FeedCubitSpy();
    userCubit = UserCubitSpy();
    navigatorObserver = MockNavigatorObserver();
  });

  Future loadPage(
    WidgetTester tester,
  ) async {
    final Map<String, WidgetBuilder> routes = {
      AppRoutes.login: (_) => LoginPage(),
      AppRoutes.splash: (_) => BlocProvider<SplashCubit>.value(
            value: splashCubit,
            child: SplashPage(),
          ),
      AppRoutes.feed: (_) => BlocProvider<FeedCubit>.value(
            value: feedCubit,
            child: FeedPage(),
          ),
    };

    await tester.pumpWidget(
      BlocProvider<UserCubit>.value(
        value: userCubit,
        child: MaterialApp(
          initialRoute: AppRoutes.splash,
          routes: routes,
          navigatorObservers: [navigatorObserver],
        ),
      ),
    );
  }

  testWidgets('Should go to FeedPage if state is SplashToHome',
      (WidgetTester tester) async {
    when(() => splashCubit.state).thenReturn(SplashInitial());
    when(() => feedCubit.state).thenReturn(FeedInitial());
    when(() => userCubit.state)
        .thenReturn(UserState(user: User(id: 2, name: 'name')));

    whenListen<SplashState>(
      splashCubit,
      Stream.fromIterable(
        [
          SplashToHome(
            account: Account(
              token: faker.guid.guid(),
              id: faker.randomGenerator.integer(10),
              username: faker.person.name(),
              email: faker.internet.email(),
            ),
          )
        ],
      ),
    );

    await loadPage(tester);

    await tester.pumpAndSettle();

    verify(() => navigatorObserver.didPush(any(), any()));
    expect(find.byType(FeedPage), findsOneWidget);
  });
}
