import 'package:flutter/material.dart';
import 'package:wecare/widgets/custome_scaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen ({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreennState();
}

class _SignInScreennState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Text('Sign in'),
    );
  }
}

