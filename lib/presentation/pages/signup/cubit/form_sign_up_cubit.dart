import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:news_app/presentation/helpers/form_validators.dart';
import 'package:news_app/presentation/helpers/ui_error.dart';

import '../../../../domain/usecases/add_account.dart';
import '../../../../domain/usecases/save_current_account.dart';
import 'form_sign_up_state.dart';

class FormSignUpCubit extends Cubit<FormSignUpState> {
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  FormSignUpCubit({
    required this.addAccount,
    required this.saveCurrentAccount,
  }) : super(FormSignUpState());

  Future<void> add() async {
    try {
      if (!isFormValid) return;

      emit(
        state.copyWith(
          formSubmissionStatus: FormzSubmissionStatus.inProgress,
        ),
      );
      final account = await addAccount.add(
        AddAccountParams(
          name: state.name.value,
          email: state.email.value,
          secret: state.password.value,
        ),
      );

      await saveCurrentAccount.save(account);

      emit(
        state.copyWith(
          formSubmissionStatus: FormzSubmissionStatus.success,
          account: account,
        ),
      );
    } on DomainError catch (error) {
      String errorMessage = UIError.unexpected.description;
      if (error == DomainError.invalidCredentials) {
        errorMessage = UIError.emailInUse.description;
      }

      emit(state.copyWith(
        formSubmissionStatus: FormzSubmissionStatus.failure,
        errorMessage: errorMessage,
      ));
      emit(state.copyWith(
        formSubmissionStatus: FormzSubmissionStatus.initial,
        errorMessage: '',
      ));
    }
  }

  void handleName(String text) {
    emit(state.copyWith(name: NameInput.dirty(text)));
  }

  void handleEmail(String text) {
    emit(state.copyWith(email: Email.dirty(text)));
  }

  void handlePassword(String text) {
    emit(state.copyWith(password: Password.dirty(text)));
  }

  bool get isFormValid {
    final name = NameInput.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      name: name,
      email: email,
      password: password,
    ));

    return name.isValid && email.isValid && password.isValid;
  }
}
