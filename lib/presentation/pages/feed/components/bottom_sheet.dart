import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/helpers/presentation_constants.dart';
import 'package:news_app/presentation/pages/feed/cubit/feed_cubit.dart';

import '../post_view_model.dart';
import 'modal_post/modal_post.dart';
import 'modal_remove.dart';

Future getBottomSheet({
  required BuildContext context,
  required NewsViewModel news,
}) {
  final cubit = context.read<FeedCubit>();

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: <Widget>[
            ListTile(
                title: Text(
                  PresentationConstants.edit,
                  textAlign: TextAlign.center,
                ),
                onTap: () async {
                  final message = await showModalPost(context, news: news);
                  if (message == null) return;

                  cubit.handleSavePost(message: message, postId: news.id);
                  Navigator.of(context).pop();
                }),
            ListTile(
              title: Text(
                PresentationConstants.remove,
                textAlign: TextAlign.center,
              ),
              onTap: () async {
                final postId = await showModalRemove(
                  news: news,
                  context: context,
                );
                if (postId == null) return;
                cubit.handleRemovePost(postId: postId);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
