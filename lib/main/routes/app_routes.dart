import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/main/factories/usecases/authetication.dart';

import '../../infra/storage/local_storage_adater.dart';
import '../../presentation/pages/feed/cubit/feed_cubit.dart';
import '../../presentation/pages/feed/feed_page.dart';
import '../../presentation/pages/login/cubit/login_cubit.dart';
import '../../presentation/pages/login/login_page.dart';
import '../../presentation/pages/signup/cubit/form_sign_up_cubit.dart';
import '../../presentation/pages/signup/signup_page.dart';
import '../../presentation/pages/splash/cubit/splash_cubit.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../factories/usecases/add_account_factory.dart';
import '../factories/usecases/load_current_account_factory.dart';
import '../factories/usecases/load_posts_factory.dart';
import '../factories/usecases/remove_post_factory.dart';
import '../factories/usecases/save_current_account_factory.dart';
import '../factories/usecases/save_post_factory.dart';
import '../singletons/local_storage_singleton.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const feed = '/feed';
  static const newPost = '/new-post';
  static const signUp = 'signUp';

  static getRoutes(_) {
    final Map<String, WidgetBuilder> routes = {
      splash: (_) => _makeSplashPage(),
      signUp: (_) => _makeSignUpPage(),
      login: (_) => _makeLoginPage(),
      feed: (_) => _makeFeedPage(),
    };

    return routes;
  }

  static BlocProvider<FormSignUpCubit> _makeSignUpPage() {
    return BlocProvider(
      create: (context) => FormSignUpCubit(
        addAccount: AddAccountFactory.makeRemoteAddAccount(),
        saveCurrentAccount:
            SaveCurrentAccountFactory.makeLocalSaveCurrentAccount(),
      ),
      child: SignUpPage(),
    );
  }

  static BlocProvider<FeedCubit> _makeFeedPage() {
    return BlocProvider(
      create: (_) => FeedCubit(
        loadPosts: LoadPostsFactory.makeRemoteLoadNews(),
        savePost: SavePostFactory.makeRemoteSavePost(),
        removePost: RemovePostFactory.makeRemoteRemovePost(),
        localStorage: LocalStorageAdapter(
          localStorage: LocalStorage.instance.preferences,
        ),
      ),
      child: FeedPage(),
    );
  }

  static BlocProvider<LoginCubit> _makeLoginPage() {
    return BlocProvider(
      create: (context) => LoginCubit(
        authentication: AuthenticationFactory.makeRemoteAuthentication(),
        saveCurrentAccount:
            SaveCurrentAccountFactory.makeLocalSaveCurrentAccount(),
      ),
      child: LoginPage(),
    );
  }

  static BlocProvider<SplashCubit> _makeSplashPage() {
    return BlocProvider(
      create: (context) => SplashCubit(
        loadCurrentAccount: makeLocalLoadCurrentAccount(),
      ),
      child: SplashPage(),
    );
  }
}
