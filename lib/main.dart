import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rezervujme_app/screens/intro_screen.dart';
import 'package:rezervujme_app/screens/login_screen.dart';
import 'package:rezervujme_app/screens/onboarding_screen.dart';
import 'package:rezervujme_app/screens/order_screen.dart';
import 'package:rezervujme_app/screens/order_success_screen.dart';
import 'package:rezervujme_app/screens/register_screen.dart';
import 'package:rezervujme_app/screens/reservations_screen.dart';
import 'package:rezervujme_app/screens/settings_screen.dart';
import 'package:rezervujme_app/state/auth_cubit.dart';
import 'package:rezervujme_app/state/restaurants_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

import 'screens/restaurant_detail_screen.dart';
import 'screens/restaurants_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<RestaurantsCubit>(
        create: (BuildContext context) => RestaurantsCubit(),
      ),
      BlocProvider<AuthCubit>(
        create: (BuildContext context) => AuthCubit(),
      ),
    ], child: const Router());
  }
}

class Router extends StatefulWidget {
  const Router({Key? key}) : super(key: key);

  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  @override
  void initState() {
    context.read<AuthCubit>().loadAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VRouter(
      debugShowCheckedModeBanner: false,
      initialUrl: '/onboarding',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF2F2F2),
          primaryColor: const Color(0xFFDC2625),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFDC2625)),
          textTheme: const TextTheme(
              headline4: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black))),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('sk')],
      routes: [
        VRouteRedirector(path: '/tabs', redirectTo: '/tabs/restaurants'),
        // ONBOARDING
        VGuard(
            beforeEnter: (vRedirector) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var onboarded = prefs.getBool('onboarded') ?? false;
              if (onboarded) {
                if (context.read<AuthCubit>().isLoggedIn()) {
                  vRedirector.to('/tabs/restaurants');
                } else {
                  vRedirector.to('/intro');
                }
              }
            },
            stackedRoutes: [
              VWidget(path: '/onboarding', widget: const OnboardingScreen())
            ]),
        VWidget(path: '/intro', widget: const IntroScreen(), stackedRoutes: [
          VWidget.builder(
              path: 'register/:phoneNumber',
              builder: (context, state) => RegisterScreen(
                  phoneNumber:
                      context.vRouter.pathParameters['phoneNumber'] as String)),
          VWidget.builder(
              path: 'login/:phoneNumber',
              builder: (context, state) => LoginScreen(
                  phoneNumber:
                      context.vRouter.pathParameters['phoneNumber'] as String)),
        ]),

        VWidget(path: '/order-success', widget: const OrderSuccessScreen()),
        //TABS
        VNester(
          path: '/tabs',
          widgetBuilder: (child) {
            if (kDebugMode) {
              print(child.toString());
            }
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
                      stackedRoutes: [
                        VWidget.builder(
                          path: 'order/:reservationDate',
                          builder: (context, state) => OrderScreen(
                            restaurantId: int.parse(context.vRouter
                                .pathParameters['restaurantId'] as String),
                            reservationDateString: context.vRouter
                                .pathParameters['reservationDate'] as String,
                          ),
                        )
                      ]),
                  VWidget(
                      path: 'reservations', widget: const ReservationsScreen())
                ])
          ],
          nestedRoutes: [
            VWidget(
              path: 'restaurants',
              aliases: const [
                'restaurants/:restaurantId',
                'restaurants/:restaurantId/order/:date',
                'reservations'
              ],
              widget: const RestaurantsScreen(),
              key: const ValueKey('restaurants'),
              transitionDuration: Duration.zero,
            ),
            VWidget(
              transitionDuration: Duration.zero,
              path: 'settings',
              widget: const SettingsScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

class TabsScaffold extends StatelessWidget {
  const TabsScaffold({Key? key, required this.child}) : super(key: key);

  final Widget child;

  final List<String> _tabs = const ['/tabs/restaurants', '/tabs/settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: !_tabs.contains(context.vRouter.url)
            ? 0
            : _tabs.indexOf(context.vRouter.url),
        onTap: (index) => context.vRouter.to(_tabs[index]),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_outlined), label: 'Reštaurácie'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Nastavenia'),
        ],
      ),
    );
  }
}
