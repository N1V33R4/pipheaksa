import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipheaksa/core/constants/constants.dart';
import 'package:pipheaksa/features/auth/controller/auth_controller.dart';
import 'package:pipheaksa/features/home/delegates/search_community_delegate.dart';
import 'package:pipheaksa/features/home/drawers/community_list_drawer.dart';
import 'package:pipheaksa/features/home/drawers/profile_drawer.dart';
import 'package:pipheaksa/theme/pallet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Home'),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => displayDrawer(context),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCommunityDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () => displayEndDrawer(context),
            );
          })
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Constants.tabWidgets[_page],
      bottomNavigationBar: CupertinoTabBar(
        height: 60,
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.add),
            ),
            label: 'Create',
          ),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}
