import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../post_view_model.dart';

Future<int?> showModalRemove({
  required NewsViewModel news,
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Remover publicação?'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      actions: [
        AppButton.secondary(
          onPressed: () => Navigator.pop(context),
          label: 'Cancelar',
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, news.id);
          },
          child: Text('Remover'),
        ),
      ],
    ),
  );
}
