import 'package:example/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage() : super(key: const Key('login_page'));

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isLoginButtonEnabled = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _username(),
          _password(),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _username() {
    return TextFormField(
      key: const Key('username'),
      controller: _usernameController,
    );
  }

  Widget _password() {
    return TextFormField(
      key: const Key('password'),
      controller: _passwordController,
      obscureText: true,
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      key: const Key('login_button'),
      onPressed: _isLoginButtonEnabled ? _login : null,
      child: const Text('Login'),
    );
  }

  void _login() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }
}
