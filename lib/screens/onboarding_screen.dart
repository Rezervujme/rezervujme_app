import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageDecoration _pageDecoration =
      const PageDecoration(bodyAlignment: Alignment.center);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalFooter: SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('onboarded', true);
            context.vRouter.to('/intro');
          },
        ),
      ),
      pages: [
        PageViewModel(
          title: "Fractional shares",
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
          decoration: _pageDecoration,
        ),
        PageViewModel(
          title: "Fractional shares",
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
          decoration: _pageDecoration,
        )
      ],
      showDoneButton: false,
      showNextButton: false,
      showSkipButton: false,
    );
  }
}
