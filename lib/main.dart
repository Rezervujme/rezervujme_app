import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rezervujme_app/onboarding_screen.dart';
import 'package:rezervujme_app/state/restaurants_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

import 'home_screen.dart';
import 'restaurant_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantsCubit>(
          create: (BuildContext context) => RestaurantsCubit(),
        ),
      ],
      child: VRouter(
          initialUrl: '/onboarding',
          routes: [
            VNester(
              path: '/tabs',
              widgetBuilder: (child) {
                print(child.toString());
                return TabsScaffold(child: child);
              },
              stackedRoutes: [
                VPopHandler(
                    onSystemPop: (vRedirector) async {
                      vRedirector.to(vRedirector.fromUrl!
                          .substring(0, vRedirector.fromUrl!.lastIndexOf('/')));
                    },
                    onPop: (vRedirector) async {
                      vRedirector.to(vRedirector.fromUrl!
                          .substring(0, vRedirector.fromUrl!.lastIndexOf('/')));
                    },
                    stackedRoutes: [
                      VWidget.builder(
                        path: 'restaurants/:restaurantId',
                        builder: (context, state) => RestaurantDetailScreen(
                          restaurantId: int.parse(context.vRouter
                              .pathParameters['restaurantId'] as String),
                        ),
                      )
                    ])
              ],
              nestedRoutes: [
                VWidget(
                  path: 'restaurants',
                  aliases: const ['restaurants/:restaurantId'],
                  widget: const HomeScreen(),
                  key: const ValueKey('restaurants'),
                ),
              ],
            ),
            VGuard(
                beforeEnter: (vRedirector) async {
                  print(vRedirector.toString());
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var onboarded = prefs.getBool('onboarded') ?? false;
                  // if (onboarded) vRedirector.to('/tabs/restaurants');
                },
                stackedRoutes: [
                  VWidget(path: '/onboarding', widget: const OnboardingScreen())
                ]),
          ],
          theme: ThemeData(
            primaryColor: const Color(0xFFDC2625),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFDC2625)),
          )),
    );
  }
}

class TabsScaffold extends StatelessWidget {
  const TabsScaffold({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.vRouter.url.contains('restaurants') ? 0 : 1,
        onTap: (value) => context.vRouter
            .to((value == 0) ? '/tabs/restaurants' : '/tabs/onboarding'),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
