import 'package:flutter/material.dart';
import 'package:wecare/screens/signin.dart';
import 'package:wecare/screens/signup.dart';
import 'package:wecare/widgets/custome_scaffold.dart';
import 'package:wecare/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 12, 106, 66), // Change text color to black
                    ),
                    children: [
                      TextSpan(
                        text: 'Welcome Back!\n',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\n Welcome to the best Online Patient Management application in the world',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign In',
                        onTap: SignInScreen(),
                        color: Colors.transparent,
                        textColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        onTap: SignUpScreen(),
                        color: Colors.white,
                        textColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
