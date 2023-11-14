import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/helpers/presentation_constants.dart';

import '../../../../helpers/form_validators.dart';
import '../../post_view_model.dart';
import 'cubit/form_post_cubit.dart';

Future<String?> showModalPost(BuildContext context, {NewsViewModel? news}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (context) => FormPostCubit(),
        child: _Alert(
          news: news,
        ),
      );
    },
  );
}

class _Alert extends StatelessWidget {
  final NewsViewModel? news;
  const _Alert({this.news});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FormPostCubit>();
    return AlertDialog(
      title: Text(PresentationConstants.createPublication),
      content: BlocBuilder<FormPostCubit, FormPostState>(
        builder: (context, state) {
          return TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: PresentationConstants.whatDoYouWantToShare,
              errorText: state.message.errorMessage,
              errorBorder: InputBorder.none,
              border: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              fillColor: Theme.of(context).colorScheme.background,
              filled: true,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
            onChanged: cubit.handleMessage,
            initialValue: news?.message,
          );
        },
      ),
      actions: [
        AppButton.secondary(
          onPressed: () => Navigator.of(context).pop(),
          label: PresentationConstants.cancel,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: BlocBuilder<FormPostCubit, FormPostState>(
            builder: (_, state) {
              return AppButton.secondary(
                onPressed: state.isFormValid
                    ? () {
                        Navigator.of(context).pop(
                          state.message.value,
                        );
                      }
                    : null,
                label: PresentationConstants.publish,
              );
            },
          ),
        ),
      ],
    );
  }
}
