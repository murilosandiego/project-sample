import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app/presentation/helpers/ui_error.dart';

import '../../../../domain/errors/domain_error.dart';
import '../../../../domain/usecases/authentication.dart';
import '../../../../domain/usecases/save_current_account.dart';
import '../../../helpers/form_validators.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  LoginCubit({
    required this.authentication,
    required this.saveCurrentAccount,
  }) : super(LoginState());

  Future<void> auth() async {
    try {
      if (!_isFormValid) return;

      emit(state.copyWith(
          formSubmissionsStatus: FormzSubmissionStatus.inProgress));

      final account = await authentication.auth(AuthenticationParams(
        email: state.email.value,
        secret: state.password.value,
      ));

      await saveCurrentAccount.save(account);

      emit(
          state.copyWith(formSubmissionsStatus: FormzSubmissionStatus.success));
    } on DomainError catch (error) {
      String errorMessage = UIError.unexpected.description;
      if (error == DomainError.invalidCredentials) {
        errorMessage = UIError.invalidCredentials.description;
      }

      emit(state.copyWith(
        formSubmissionsStatus: FormzSubmissionStatus.failure,
        errorMessage: errorMessage,
      ));

      emit(
        state.copyWith(
          formSubmissionsStatus: FormzSubmissionStatus.initial,
          errorMessage: '',
        ),
      );
    }
  }

  void handleEmail(String text) {
    emit(state.copyWith(email: Email.dirty(text)));
  }

  void handlePassword(String text) {
    emit(state.copyWith(password: Password.dirty(text)));
  }

  bool get _isFormValid {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      email: email,
      password: password,
    ));

    return email.isValid && password.isValid;
  }
}
