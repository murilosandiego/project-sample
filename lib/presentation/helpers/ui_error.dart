import 'package:news_app/presentation/helpers/presentation_constants.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
  invalidEmail,
  invalidMessageNewPost
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return PresentationConstants.requiredField;
      case UIError.invalidField:
        return PresentationConstants.invalidField;
      case UIError.invalidCredentials:
        return PresentationConstants.invalidCredentials;
      case UIError.emailInUse:
        return PresentationConstants.theEmailIsAlreadyInUse;
      case UIError.invalidEmail:
        return PresentationConstants.invalidEmail;
      case UIError.invalidMessageNewPost:
        return PresentationConstants.messageLargerThanAllowed;
      default:
        return PresentationConstants.somethingWentWrongTryAgainSoon;
    }
  }
}
