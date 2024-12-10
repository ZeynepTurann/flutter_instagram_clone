import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/selector/locale/view/locale_selector.dart';

import '../bloc/user_profile_bloc.dart';

class UserProfileFollowers extends StatefulWidget {
  const UserProfileFollowers({super.key});

  @override
  State<UserProfileFollowers> createState() => _UserProfileFollowersState();
}

class _UserProfileFollowersState extends State<UserProfileFollowers>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    context
        .read<UserProfileBloc>()
        .add(const UserProfileFollowersSubscriptionRequested());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final followers =
        context.select((UserProfileBloc bloc) => bloc.state.followers);

    return CustomScrollView(
      cacheExtent: 2760,
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverList.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              final user = followers[index];
              
            })
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
