import 'package:flutter/material.dart';
import 'package:wecare/widgets/custome_scaffold.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen ({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreennState();
}

class _SignUpScreennState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Text('Sign Up'),
    );
  }
}

