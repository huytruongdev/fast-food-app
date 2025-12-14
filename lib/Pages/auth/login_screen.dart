import 'package:fast_food_app/pages/auth/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_app/pages/auth/signup_screen.dart';
import 'package:fast_food_app/widgets/my_button.dart';
import 'package:fast_food_app/service/auth_service.dart';
import 'package:fast_food_app/widgets/snack_back.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isPasswordHidden = true;

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    final result = await _authService.login(email, password);
    if (!mounted) return;
    if (result == null) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreenState()),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Signup Failed: $result", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Image.asset(
                  "assets/login.jpg",
                  width: double.maxFinite,
                  height: 300, 
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
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
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.maxFinite,
                        child: MyButton(onTap: _login, buttonText: "Login"),
                      ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Don't have an account ! ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => SignupScreen()),
                        );
                      },
                      child: Text(
                        "Signup here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
