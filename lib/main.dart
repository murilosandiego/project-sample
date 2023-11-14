import 'package:app_ui/app_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:news_app/main/routes/app_routes.dart';
import 'package:news_app/main/singletons/local_storage_singleton.dart';
import 'package:news_app/presentation/user/user_cubit.dart';

void main() async {
  await _initializer();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Microblog',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routes: AppRoutes.getRoutes(context),
        initialRoute: AppRoutes.splash,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('pt', 'BR')],
      ),
    );
  }
}

Future<void> _initializer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.instance.init();
}
