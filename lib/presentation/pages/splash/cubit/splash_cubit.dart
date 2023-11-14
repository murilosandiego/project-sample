import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../domain/usecases/load_current_account.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final LoadCurrentAccount loadCurrentAccount;

  SplashCubit({
    required this.loadCurrentAccount,
  }) : super(SplashInitial());

  FutureOr<void> checkAccount({bool test = false}) async {
    try {
      final account = await loadCurrentAccount.load();

      if (account != null) {
        emit(SplashToHome(account: account));
      } else {
        emit(SplashToLogin());
      }
    } catch (_) {
      emit(SplashToLogin());
    }
  }
}
