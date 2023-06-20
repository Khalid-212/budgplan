import 'package:budgplan/Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late SharedPreferences _prefs;
  int _currentIndex = 0;
  bool _initialized = false;

  final List<Widget> _pages = [
    OnboardingPage(
      image: 'assets/slide1.png',
      title: 'Welcome to MyApp',
      description: 'This is the first page of the onboarding.',
    ),
    OnboardingPage(
      image: 'assets/slide2.png',
      title: 'Explore Features',
      description: 'This is the second page of the onboarding.',
    ),
    OnboardingPage(
      image: 'assets/slide3.png',
      title: 'Get Started',
      description: 'This is the third page of the onboarding.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _initialized = true;
    });
  }

  Future<void> _completeOnboarding() async {
    await _prefs.setBool('onboarding_completed', true);
  }

  bool _isOnboardingCompleted() {
    return _prefs.getBool('onboarding_completed') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_isOnboardingCompleted()) {
      return homePage(); // Replace with your home page widget
    } else {
      return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_currentIndex == _pages.length - 1) {
                  _completeOnboarding();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            homePage()), // Replace with your home page widget
                  );
                } else {
                  _currentIndex++;
                }
              });
            },
            child: Text(
              _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
            ),
          ),
        ),
      );
    }
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image),
        SizedBox(height: 16.0),
        Text(
          title,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
