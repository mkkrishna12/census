import 'package:census/login-Page/components/arrow_button.dart';
import 'package:census/login-Page/components/day/sun.dart';
import 'package:census/login-Page/components/day/sun_rays.dart';
import 'package:census/login-Page/components/input_field.dart';
import 'package:census/login-Page/components/night/moon.dart';
import 'package:census/login-Page/components/night/moon_rays.dart';
import 'package:census/login-Page/components/toggle_button.dart';
import 'package:census/login-Page/enums/mode.dart';
import 'package:census/login-Page/models/login_theme.dart';
import 'package:census/login-Page/utils/cached_images.dart';
import 'package:census/login-Page/utils/viewport_size.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  LoginTheme day;
  LoginTheme night;
  Mode _activeMode = Mode.day;
  InputField email, password;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward(from: 0.0);
    }); // wait for all the widget to render
    initializeTheme(); //initializing theme for day and night
    super.initState();
  }

  @override
  void didChangeDependencies() {
    cacheImages();
    super.didChangeDependencies();
  }

  cacheImages() {
    CachedImages.imageAssets.forEach((asset) {
      precacheImage(asset, context);
    });
  }

  initializeTheme() {
    day = LoginTheme(
      title: 'Welcome',
      backgroundGradient: [
        const Color(0xFFFF8A80),
        const Color(0xFFFFE57F),
        const Color(0xFFFFE57F),
        const Color(0xFFFFFF8D),
      ],
      landscape: CachedImages.imageAssets[0],
      circle: Sun(
        controller: _animationController,
      ),
      rays: SunRays(
        controller: _animationController,
      ),
    );

    night = LoginTheme(
      title: 'Welcome',
      backgroundGradient: [
        const Color(0xFF212121),
        const Color(0xFF1A237E),
        const Color(0xFF6384B2),
        const Color(0xFF6486B7),
      ],
      landscape: CachedImages.imageAssets[1],
      circle: Moon(
        controller: _animationController,
      ),
      rays: MoonRays(
        controller: _animationController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ViewportSize.getSize(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _activeMode == Mode.day
                ? day.backgroundGradient
                : night.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              width: height * 0.8,
              height: height * 0.8,
              bottom: _activeMode == Mode.day ? -300 : -50,
              child: _activeMode == Mode.day ? day.rays : night.rays,
            ),
            Positioned(
              bottom: _activeMode == Mode.day ? -160 : -80,
              child: _activeMode == Mode.day ? day.circle : night.circle,
            ),
            Positioned.fill(
              child: Image(
                image:
                    _activeMode == Mode.day ? day.landscape : night.landscape,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: height * 0.1,
              left: width * 0.12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToggleButton(
                    startText: 'Login',
                    endText: 'Registration ',
                    tapCallback: (index) {
                      setState(() {
                        _activeMode = index == 0 ? Mode.day : Mode.night;
                        _animationController.forward(from: 0.0);
                      });
                    },
                  ),
                  buildText(
                    text: _activeMode == Mode.day ? day.title : night.title,
                    padding:
                        EdgeInsets.only(top: height * 0.06, left: width * 0.20),
                    fontSize: width * 0.085,
                    fontFamily: 'YesevaOne',
                  ),
                  buildText(
                    text: 'Email ID',
                    padding: EdgeInsets.only(
                        top: height * 0.06, bottom: height * 0.015),
                    fontSize: width * 0.044,
                  ),
                  email = InputField(
                    hintText: 'Enter your Email Id ',
                    obscureText: false,
                  ),
                  buildText(
                    text: 'Password',
                    padding: EdgeInsets.only(
                      top: height * 0.04,
                      bottom: height * 0.015,
                    ),
                    fontSize: width * 0.044,
                  ),
                  password = InputField(
                    hintText: 'Enter your password',
                    obscureText: true,
                  ),
                  ArrowButton(
                      email: email.getEmail1(),
                      password: password.getPassword1(),
                      activeMode: _activeMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildText(
      {double fontSize, EdgeInsets padding, String text, String fontFamily}) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontSize: fontSize,
          fontFamily: fontFamily ?? '',
        ),
      ),
    );
  }
}
