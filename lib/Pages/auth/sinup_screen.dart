import 'package:flutter/material.dart';
import 'package:fast_food_app/Service/auth_service.dart';
import 'package:fast_food_app/Widget/my_button.dart';
import 'package:fast_food_app/Widget/snack_back.dart';
import 'package:fast_food_app/Pages/auth/login_screen.dart';

class SinupScreen extends StatefulWidget {
  const SinupScreen({super.key});

  @override
  State<SinupScreen> createState() => _SinupScreenState();
}

class _SinupScreenState extends State<SinupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoadin = false;
  bool isPasswordHidden = true;

  void _signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!email.contains(".com")) {
      showSnackBar(context, "Invalid email. It must contain .com", Colors.red);
      return;
    }
    setState(() {
      isLoadin = true;
    });
    final result = await _authService.signup(email, password);
    if (!mounted) return;
    if (result == null) {
      setState(() {
        isLoadin = false;
      });
      showSnackBar(context, "Signup Successful! Now Turn to Login", Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      setState(() {
        isLoadin = false;
      });
      showSnackBar(context, "Signup Failed: $result", Colors.red);
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
                "assets/6343825.jpg",
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

              //Password
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
                      child: MyButton(onTap: _signUp, buttonText: "Signup"),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Already have an acount !",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login here",
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
