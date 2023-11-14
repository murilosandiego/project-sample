import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_app/presentation/helpers/presentation_constants.dart';

import 'components/form_login.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PresentationConstants.signInWithEMail),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppLogo(),
              SizedBox(height: AppSpacing.xxlg),
              FormLogin(),
            ],
          ),
        ),
      ),
    );
  }
}
