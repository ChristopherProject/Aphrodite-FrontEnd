// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:aphrodite/pages/home.dart';
import 'package:aphrodite/utilitities/requests.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String responseText = '';
  bool isAutoLoginInProgress = true;

  @override
  void initState() {
    super.initState();
    _attemptAutoLogin();
  }

  Future<void> _attemptAutoLogin() async {
    await Requests.loadCredentials();
    if (Requests.username.isNotEmpty && Requests.password.isNotEmpty) {
      await _handleLogin();
    }
    setState(() {
      isAutoLoginInProgress = false;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      return false;
    },
    child: Scaffold(
      body: Center(
        child: isAutoLoginInProgress
          ? const CircularProgressIndicator(
              color: Color.fromARGB(255, 189, 182, 182),
            )
          : _buildLoginForm(),
      ),
    ),
  );
}

  Widget _buildLoginForm() {
   return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/logo.png',
              width: 200.0,
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Material(
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await _handleLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200.0, 40.0),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    await Requests.loadCredentials();

    final String usernameToUse = Requests.username.isNotEmpty
        ? Requests.username
        : usernameController.text;
    final String passwordToUse = Requests.password.isNotEmpty
        ? Requests.password
        : passwordController.text;

    try {
      await Requests.refreshAuthToken(usernameToUse, passwordToUse);

      if (Requests.authToken.isNotEmpty) {
        final  Map<String, dynamic> currentAccountData = await Requests.getCurrentAccountData();
        final Map<String, dynamic> userInformations = await Requests.fetchUserInformation(currentAccountData['user_id']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserProfilePage(userInformations: userInformations, privateData: currentAccountData),
          ),
        );
      } else {
        setState(() {
          responseText = 'Login failed. Please check your credentials.';
        });
      }
    } catch (error) {
      setState(() {
        responseText = 'An error occurred during login.';
      });
    }
  }
}
