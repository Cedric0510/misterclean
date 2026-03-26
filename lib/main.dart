import 'package:app/shared/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/cats/presentation/pages/cat_detail_page.dart';
import 'features/cats/presentation/pages/home_screen.dart';

//! Boyscout rule
//? Supprimer le code commenter (le 1er qui le voit)
// TODO: fix this later - old routing approach
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(body: Center(child: Text('Hello'))),
//   ));
// }

void main() {
  runApp(
    ProviderScope(
      observers: [AppObserver()],
      child: MyApp(navigatorKey: NavigationService.instance.navigatorKey),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Heliosito',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: UI.backgroundColor),
      initialRoute: routeName,
      routes: {
        routeName: (context) => const HomeScreen(),
        CatDetailPage.routeName: (context) => const CatDetailPage(),
      },
    );
  }
}

class AppObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('[${provider.name ?? provider.runtimeType}] value: $newValue');
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    print('[${provider.name ?? provider.runtimeType}] error: $error');
  }
}

class NavigationService {
  static final NavigationService instance = NavigationService._internal();
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
