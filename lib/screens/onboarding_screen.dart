import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageDecoration _pageDecoration = const PageDecoration(
      bodyAlignment: Alignment.center,
      titleTextStyle: TextStyle(
          color: Color(0xFFDC2625), fontWeight: FontWeight.bold, fontSize: 20));

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        // child: IntroductionScreen(
        //   dotsDecorator: DotsDecorator(
        //       color: Colors.grey.shade300,
        //       activeColor: Theme.of(context).primaryColor),
        //   globalFooter: SizedBox(
        //     width: double.infinity,
        //     height: 64,
        //     child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         primary: Theme.of(context).primaryColor,
        //       ),
        //       child: const Text(
        //         'Let\'s go right away!',
        //         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        //       ),
        //       onPressed: () async {
        //         SharedPreferences prefs = await SharedPreferences.getInstance();
        //         prefs.setBool('onboarded', true);
        //         context.vRouter.to('/intro');
        //       },
        //     ),
        //   ),
        //   pages: [
        //     PageViewModel(
        //       title: "Fractional shares",
        //       body:
        //           "Instead of having to buy an entire share, invest any amount you want.",
        //       decoration: _pageDecoration,
        //     ),
        //     PageViewModel(
        //       title: "Fractional shares",
        //       body:
        //           "Instead of having to buy an entire share, invest any amount you want.",
        //       decoration: _pageDecoration,
        //     )
        //   ],
        //   showDoneButton: false,
        //   showNextButton: true,
        //   showSkipButton: false,
        // ),
        child: IntroductionScreen(
          dotsDecorator: DotsDecorator(
            color: Colors.grey.shade300,
            activeColor: Theme.of(context).primaryColor,
          ),
          pages: [
            PageViewModel(
                title: 'Vitajte na Rezervujme.sk',
                body: '',
                decoration: _pageDecoration),
            PageViewModel(
                title: 'Rezervujte si svoj stôl',
                body:
                    'Rezervujte si pomocou tejto aplikácie stôl vo svojom obľúbenom podniku!',
                decoration: _pageDecoration),
          ],
          done: Text('Pokračovať',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          next: Icon(
            Icons.chevron_right_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onDone: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('onboarded', true);
            context.vRouter.to('/intro');
          },
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: false,
        ));
  }
}
