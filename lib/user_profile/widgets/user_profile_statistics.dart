import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:flutter_instagram_clone/selector/locale/view/locale_selector.dart';

import '../bloc/user_profile_bloc.dart';

class UserProfileStatistics extends StatefulWidget {
  const UserProfileStatistics({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<UserProfileStatistics> createState() => _UserProfileStatisticsState();
}

class _UserProfileStatisticsState extends State<UserProfileStatistics>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _tabController.animateTo(widget.tabIndex);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: UserProfileStatisticsAppBar(
                    controller: _tabController,
                  ),
                )
              ];
            },
            body: TabBarView(controller: _tabController, children: const [
              //TODO(tab) : Add tab for followers
              //TODO(tab) : Add tab for followings
            ])));
  }
}

class UserProfileStatisticsAppBar extends StatelessWidget {
  const UserProfileStatisticsAppBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final followers =
        context.select((UserProfileBloc bloc) => bloc.state.followersCount);

    final followings =
        context.select((UserProfileBloc bloc) => bloc.state.followingsCount);

    final user = context.select((UserProfileBloc bloc) => bloc.state.user);

    return SliverAppBar(
      pinned: true,
      centerTitle: false,
      title: Text(user.displayUsername),
      bottom: TabBar(
          indicatorWeight: 1,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: controller,
          labelColor: context.adaptiveColor,
          labelStyle: context.bodyLarge,
          labelPadding: EdgeInsets.zero,
          unselectedLabelColor: AppColors.grey,
          unselectedLabelStyle: context.bodyLarge,
          indicatorColor: context.adaptiveColor,
          tabs: [
            Tab(
              text: context.l10n.followersCountText(followers),
            ),
            Tab(
              text: context.l10n.followingsCountText(followings),
            ),
          ]),
    );
  }
}
