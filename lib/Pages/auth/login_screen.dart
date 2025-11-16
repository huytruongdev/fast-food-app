import 'package:flutter/material.dart';
import 'package:fast_food_app/Pages/auth/Screen/onboarding.dart';
import 'package:fast_food_app/Pages/auth/sinup_screen.dart';
import 'package:fast_food_app/Widget/my_button.dart';
import 'package:fast_food_app/Service/auth_service.dart';
import 'package:fast_food_app/Widget/snack_back.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoadin = false;
  bool isPasswordHidden = true;

  void _logIN() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (!mounted) return;
    setState(() {
      isLoadin = true;
    });
    final result = await _authService.login(email, password);
    if (!mounted) return;
    if (result == null) {
      setState(() {
        isLoadin = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnbordingScreenState()),
      );
    } else {
      setState(() {
        isLoadin = false;
      });
      showSnackBar(context, "Signup Failed: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset(
                "assets/login.jpg",
                width: double.maxFinite,
                height: 500,
                fit: BoxFit.cover,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                obscureText: isPasswordHidden,
              ),
              SizedBox(height: 20),
              isLoadin
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.maxFinite,
                      child: MyButton(onTap: _logIN, buttonText: "Login"),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Don't have an acount !",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SinupScreen()),
                      );
                    },
                    child: Text(
                      "Sigup here",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
