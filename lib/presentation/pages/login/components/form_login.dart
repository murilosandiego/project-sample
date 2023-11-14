import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app/presentation/helpers/presentation_constants.dart';

import '../../../../main/routes/app_routes.dart';
import '../../../helpers/form_validators.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class FormLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.formSubmissionsStatus.isSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.feed,
            (route) => false,
          );
        }
        if (state.formSubmissionsStatus.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.xxlg,
        ),
        child: Column(
          children: [
            _EmailField(),
            SizedBox(height: AppSpacing.xlg),
            _PasswordField(),
            SizedBox(height: AppSpacing.xxlg),
            _SubmitButton(),
            SizedBox(height: AppSpacing.xxlg),
            AppButton.secondary(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
              label: PresentationConstants.noAccount,
            )
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (_, state) {
        return AppButton.primary(
          isLoading: state.formSubmissionsStatus.isInProgress,
          label: PresentationConstants.login,
          onPressed: state.isFormValid ? () => cubit.auth() : null,
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password.value != current.password.value,
      builder: (context, state) {
        return AppTextFormField(
          label: PresentationConstants.password,
          onChanged: cubit.handlePassword,
          errorText: state.password.errorMessage,
          obscureText: true,
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        return previous.email.value != current.email.value;
      },
      bloc: cubit,
      builder: (context, state) {
        return AppTextFormField(
          initialValue: state.email.value,
          label: PresentationConstants.email,
          onChanged: cubit.handleEmail,
          errorText: state.email.errorMessage,
          textInputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}
