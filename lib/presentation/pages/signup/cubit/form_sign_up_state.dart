import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../domain/entities/account.dart';
import '../../../helpers/form_validators.dart';

class FormSignUpState extends Equatable with FormzMixin {
  final NameInput name;
  final Email email;
  final Password password;
  final FormzSubmissionStatus formSubmissionStatus;
  final String errorMessage;
  final Account? account;

  FormSignUpState(
      {this.name = const NameInput.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.formSubmissionStatus = FormzSubmissionStatus.initial,
      this.errorMessage = '',
      this.account});

  FormSignUpState copyWith(
      {Email? email,
      Password? password,
      FormzSubmissionStatus? formSubmissionStatus,
      NameInput? name,
      String? errorMessage,
      Account? account}) {
    return FormSignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
      name: name ?? this.name,
      errorMessage: errorMessage ?? this.errorMessage,
      account: account ?? this.account,
    );
  }

  bool get isFormValid => name.isValid && email.isValid && password.isValid;

  @override
  List<Object?> get props => [
        email,
        password,
        formSubmissionStatus,
        name,
        errorMessage,
        account,
      ];

  @override
  bool get stringify => true;

  @override
  List<FormzInput> get inputs => [email, name, password];
}
