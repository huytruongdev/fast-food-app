import 'package:flutter/material.dart';
import 'package:fast_food_app/Core/Utils/consts.dart';
import 'package:fast_food_app/Core/models/on_bording_model.dart';
import 'package:fast_food_app/Pages/auth/Screen/app_main_screen.dart';

class OnboardingScreenState extends StatefulWidget {
  const OnboardingScreenState({super.key});

  @override
  State<OnboardingScreenState> createState() => _OnboardingScreenStateState();
}

class _OnboardingScreenStateState extends State<OnboardingScreenState> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground1,
            child: Image.asset(
              "assets/food-delivery/food pattern.png",
              color: imageBackground2,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          Positioned(
            top: -80,
            right: 0,
            left: 0,
            child: Image.asset("assets/food-delivery/chef.png"),
          ),
          Positioned(
            top: 139,
            right: 50,

            child: Image.asset("assets/food-delivery/leaf.png"),
          ),
          Positioned(
            top: 390,
            right: 40,

            child: Image.asset("assets/food-delivery/chili.png", width: 80),
          ),
          Positioned(
            top: 230,
            left: -20,
            child: Image.asset(
              "assets/food-delivery/ginger.png",
              width: 90,
              height: 90,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            // alignment: Alignment.center,
            child: ClipPath(
              clipper: CustomClip(),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: data.length,
                        onPageChanged: (value){
                          setState(() {
                            _currentPage = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: data[index]['title1'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: data[index]['title2'],
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                data[index]["description"]!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        data.length,
                        (index) => AnimatedContainer(
                          duration: Duration(microseconds: 300),
                          width: _currentPage == index ? 20 : 10,
                          height: 10,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.orange
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(
                            builder: (context)=> AppMainScreen(),
                          ),
                        );
                      },
                      color: red,
                      height: 65,
                      minWidth: 250,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClip extends CustomClipper<Path> {

  @override
  Path getClip (Size size){
    Path path = Path();
    path. lineTo(0, 30);
    path. lineTo(0, size.height);
    path. lineTo(size.width, size.height);
    path. lineTo(size.width, 30);
    path. quadraticBezierTo(size.width / 2, -30, 0, 30);

    return path;
  }
  @override
  bool shouldReclip (CustomClipper<Path> oldClipper) => false;
}