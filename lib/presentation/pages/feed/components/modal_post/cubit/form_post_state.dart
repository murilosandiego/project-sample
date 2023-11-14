part of 'form_post_cubit.dart';

class FormPostState extends Equatable with FormzMixin {
  final MessageInput message;
  final String errorMessage;

  FormPostState({
    this.message = const MessageInput.pure(),
    this.errorMessage = '',
  });

  FormPostState copyWith({
    MessageInput? message,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return FormPostState(
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
    );
  }

  bool get isFormValid => message.isValid;

  @override
  List<Object> get props => [message, errorMessage];

  @override
  bool get stringify => true;

  @override
  List<FormzInput> get inputs => [message];
}
