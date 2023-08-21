import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipheaksa/core/common/loader.dart';
import 'package:pipheaksa/features/auth/controller/auth_controller.dart';
import 'package:pipheaksa/router.dart';
import 'package:pipheaksa/theme/pallet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'core/common/error_text.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    print("getting data=================================");
    userModel =
        await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
    print("finish setting userModel=================================");
  }

  @override
  Widget build(BuildContext context) {
    print("Where tf am I !____________________________________!!!!!!!!!!!!!");
    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            print('=================================');
            print(userModel);
            print(data);
            print('=================================');
            return MaterialApp.router(
              title: 'Pipheaksa',
              theme: ref.watch(themeNotifierProvider),
              routerDelegate: RoutemasterDelegate(
                routesBuilder: (context) {
                  if (data != null) {
                    print("Data is not null=================================");
                    if (userModel == null) {
                      getData(ref, data);
                    }
                    if (userModel != null) {
                      print("userModel is not null=================================");
                      return loggedInRoute;
                    }
                  }
                  print("RETURN LOGOUT=================================");
                  return loggedOutRoute;
                },
              ),
              routeInformationParser: const RoutemasterParser(),
              scaffoldMessengerKey: scaffoldMessengerKey,
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
