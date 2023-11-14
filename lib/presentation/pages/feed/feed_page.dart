import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/helpers/presentation_constants.dart';
import 'package:news_app/presentation/user/user_cubit.dart';

import '../../../main/routes/app_routes.dart';
import 'components/bottom_sheet.dart';
import 'components/modal_post/modal_post.dart';
import 'cubit/feed_cubit.dart';
import 'cubit/feed_state.dart';
import 'post_view_model.dart';

class FeedPage extends StatefulWidget {
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late FeedCubit cubit;

  @override
  void initState() {
    cubit = BlocProvider.of<FeedCubit>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cubit.load();

    return Scaffold(
      drawer: AppDrawer(
        onTapLogout: cubit.logoutUser,
        username: context.watch<UserCubit>().state.user?.name ?? '',
        email: context.watch<UserCubit>().state.user?.email ?? '',
      ),
      appBar: AppBar(
        title: Text(PresentationConstants.feed),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final message = await showModalPost(context);
          if (message == null) return;

          cubit.handleSavePost(message: message);
        },
        child: Icon(Icons.post_add),
      ),
      body: RefreshIndicator(
        child: BlocConsumer<FeedCubit, FeedState>(
          listener: (_, state) {
            if (state is LogoutUser) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (route) => false);
            }
          },
          builder: (context, state) {
            if (state is FeedLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is FeedError) {
              return AppErrorPage(
                error: state.message,
                reload: cubit.load,
              );
            }

            if (state is FeedLoaded) {
              return _Content(newsList: state.news);
            }

            return SizedBox();
          },
        ),
        onRefresh: () async {
          cubit.load();
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.newsList});

  final List<NewsViewModel> newsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      itemCount: newsList.length,
      itemBuilder: (_, index) {
        final news = newsList[index];
        return AppCard(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${news.user}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${news.date}',
                            style: TextStyle(
                              color: Theme.of(context).dividerColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text('${news.message}')
            ],
          ),
          trailing: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => getBottomSheet(context: context, news: news),
            icon: Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
}
