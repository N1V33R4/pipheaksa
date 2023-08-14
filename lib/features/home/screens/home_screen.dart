import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipheaksa/features/auth/controller/auth_controller.dart';
import 'package:pipheaksa/features/home/drawers/community_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

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
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
            ),
            onPressed: () {},
          )
        ],
      ),
      drawer: const CommunityListDrawer(),
      body: Center(
        child: Text(user.name),
      ),
    );
  }
}
