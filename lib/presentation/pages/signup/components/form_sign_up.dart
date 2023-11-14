import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app/presentation/helpers/form_validators.dart';
import 'package:news_app/presentation/helpers/presentation_constants.dart';
import 'package:news_app/presentation/user/user_cubit.dart';

import '../../../../main/routes/app_routes.dart';
import '../cubit/form_sign_up_cubit.dart';
import '../cubit/form_sign_up_state.dart';

class FormSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<FormSignUpCubit, FormSignUpState>(
      listener: (context, state) {
        if (state.formSubmissionStatus.isSuccess) {
          context.read<UserCubit>().addUser(account: state.account);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.feed,
            (route) => false,
          );
        }
        if (state.formSubmissionStatus.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
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
            _NameField(),
            SizedBox(height: AppSpacing.xlg),
            _EmailField(),
            SizedBox(height: AppSpacing.xlg),
            _PasswordField(),
            SizedBox(height: AppSpacing.xlg),
            _SubmitButton(),
            SizedBox(height: AppSpacing.xlg),
            AppButton.secondary(
              onPressed: () => Navigator.pop(context),
              label: PresentationConstants.alreadyHaveAnAccount,
            )
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FormSignUpCubit>();

    return BlocBuilder<FormSignUpCubit, FormSignUpState>(
      builder: (context, state) {
        return AppButton.primary(
          isLoading: state.formSubmissionStatus.isInProgress,
          label: PresentationConstants.createAccount,
          onPressed: state.isFormValid ? () => cubit.add() : null,
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<FormSignUpCubit>(context);

    return BlocBuilder<FormSignUpCubit, FormSignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
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
  const _EmailField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<FormSignUpCubit>(context);

    return BlocBuilder<FormSignUpCubit, FormSignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AppTextFormField(
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

class _NameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<FormSignUpCubit>(context);

    return BlocBuilder<FormSignUpCubit, FormSignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return AppTextFormField(
          label: PresentationConstants.name,
          onChanged: cubit.handleName,
          errorText: state.name.errorMessage,
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}
