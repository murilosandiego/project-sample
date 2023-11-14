import 'package:formz/formz.dart';
import 'package:news_app/presentation/helpers/presentation_constants.dart';

enum EmailValidationError { invalid, empty, isNull }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([String value = '']) : super.pure(value);
  const Email.dirty([String value = '']) : super.dirty(value);

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (this.isPure) return EmailValidationError.isNull;
    if (value.isEmpty) return EmailValidationError.empty;
    return _emailRegex.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

extension EmailErrorMessageExtension on Email {
  String? get errorMessage {
    if (this.error == EmailValidationError.isNull) return null;
    if (this.error == EmailValidationError.invalid)
      return PresentationConstants.invalidEmail;
    return this.error == EmailValidationError.empty
        ? PresentationConstants.requiredField
        : null;
  }
}

enum PasswordValidationError { invalid, empty, isNull }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([String value = '']) : super.pure(value);
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (this.isPure) return PasswordValidationError.isNull;
    if (value.isEmpty) return PasswordValidationError.empty;
    return value.length >= 6 ? null : PasswordValidationError.invalid;
  }
}

extension PasswordErrorMessageExtension on Password {
  String? get errorMessage {
    if (this.error == PasswordValidationError.isNull) return null;
    if (this.error == PasswordValidationError.invalid)
      return PresentationConstants.passwordTooShort;
    return this.error == PasswordValidationError.empty
        ? PresentationConstants.requiredField
        : null;
  }
}

enum NameValidationError { invalid, empty, isNull }

class NameInput extends FormzInput<String, NameValidationError> {
  const NameInput.pure([String value = '']) : super.pure(value);
  const NameInput.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String value) {
    if (this.isPure) return NameValidationError.isNull;
    if (value.isEmpty) return NameValidationError.empty;
    return value.length >= 3 ? null : NameValidationError.invalid;
  }
}

extension NameInputErrorMessageExtension on NameInput {
  String? get errorMessage {
    if (this.error == NameValidationError.isNull) return null;
    if (this.error == NameValidationError.invalid)
      return PresentationConstants.veryShortName;
    return this.error == NameValidationError.empty
        ? PresentationConstants.requiredField
        : null;
  }
}

enum MessageValidationError { invalid, empty, isNull }

class MessageInput extends FormzInput<String, MessageValidationError> {
  const MessageInput.pure([String value = '']) : super.pure(value);
  const MessageInput.dirty([String value = '']) : super.dirty(value);

  @override
  MessageValidationError? validator(String value) {
    if (this.isPure) return MessageValidationError.isNull;
    if (value.isEmpty) return MessageValidationError.empty;
    return value.length <= 280 ? null : MessageValidationError.invalid;
  }
}

extension MessageInputErrorMessageExtension on MessageInput {
  String? get errorMessage {
    if (this.error == MessageValidationError.isNull) return null;
    if (this.error == MessageValidationError.invalid)
      return PresentationConstants.veryLongMessage;
    return this.error == MessageValidationError.empty
        ? PresentationConstants.requiredField
        : null;
  }
}
