import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../helpers/form_validators.dart';

class LoginState extends Equatable with FormzMixin {
  final Email email;
  final Password password;
  final FormzSubmissionStatus formSubmissionsStatus;
  final String errorMessage;

  LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.formSubmissionsStatus = FormzSubmissionStatus.initial,
    this.errorMessage = '',
  });

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? formSubmissionsStatus,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formSubmissionsStatus:
          formSubmissionsStatus ?? this.formSubmissionsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isFormValid => email.isValid && password.isValid;

  @override
  List<Object> get props =>
      [email, password, formSubmissionsStatus, errorMessage];

  @override
  bool get stringify => true;

  @override
  List<FormzInput> get inputs => [email, password];
}
