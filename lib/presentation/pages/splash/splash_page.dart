import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/user/user_cubit.dart';

import '../../../main/routes/app_routes.dart';
import 'cubit/splash_cubit.dart';
import 'cubit/splash_state.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    final cubit = context.read<SplashCubit>();
    cubit.checkAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          child: BlocListener<SplashCubit, SplashState>(
            listener: (_, state) {
              if (state is SplashToLogin) {
                context.read<UserCubit>().addUser(account: null);
                Navigator.popAndPushNamed(_, AppRoutes.login);
              }

              if (state is SplashToHome) {
                context.read<UserCubit>().addUser(account: state.account);
                Navigator.popAndPushNamed(_, AppRoutes.feed);
              }
            },
            child: AppLogo(),
          ),
        ),
      ),
    );
  }
}
