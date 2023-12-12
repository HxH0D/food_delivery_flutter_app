import 'package:flutter/material.dart';
import 'package:food_delivery_flutter_app/cubits/sign_in_cubit.dart';
import 'package:food_delivery_flutter_app/cubits/sign_up_cubit.dart';
import 'package:food_delivery_flutter_app/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_flutter_app/cubits/sign_in_cubit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool checkboxController = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInStatus>(
      listener: (context, state) {
        if (state == SignInStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Giriş Başarılı."),
            ),
          );
          Navigator.pop(context); // Başarı durumunda sayfayı kapat
        }
        else if (state == SignInStatus.failure){

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Hata Oluştu"),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: primaryColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: SingleChildScrollView(
          child: Center(
              child: Stack(
            children: [
              Positioned(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.transparent, Colors.black],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    width: context.width(),
                    child: Image.asset(
                      "assets/images/foods-image.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: context.height() / 5,
                  ),
                  const Text(
                    "Sing In",
                    style: TextStyle(
                      fontSize: 24,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: context.height() / 6,
                  ),
                  Column(
                    children: [
                      buildTextField(
                        controller: usernameController,
                        hintText: "Username",
                        prefixIcon: Icons.account_circle,
                      ),
                      SizedBox(height: context.height() / 80),
                      buildTextField(
                        controller: emailController,
                        hintText: "Email",
                        prefixIcon: Icons.mail,
                      ),
                      SizedBox(height: context.height() / 80),
                      buildPasswordTextField(),
                    ],
                  ),
                  SizedBox(
                    height: context.height() / 20,
                  ),
                  SizedBox(
                    width: context.width() / 1.12,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SignInCubit>().singIn(emailController.text,
                            passwordController.text, usernameController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        "Sing in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.height() / 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: context.width() / 3,
                        color: Colors.white,
                      ),
                      SizedBox(width: context.width() / 50),
                      const Text(
                        "Or Sign in with",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: context.width() / 50),
                      Container(
                        height: 1,
                        width: context.width() / 3,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.width() / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<SignUpCubit>().signUpWithGoogle();
                        },
                        icon: Image.asset("assets/images/google-icon.png",
                            width: 50),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.width() / 30,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Sing up",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return SizedBox(
      width: context.width() / 1.12,
      child: TextField(
        controller: controller,
        cursorColor: primaryColor,
        style: const TextStyle(color: textColor1),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: textColor1),
          filled: true,
          fillColor: secondaryColor,
          prefixIcon: Icon(prefixIcon, color: primaryColor),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF222222), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordTextField() {
    return SizedBox(
      width: context.width() / 1.12,
      child: TextField(
        controller: passwordController,
        cursorColor: primaryColor,
        style: const TextStyle(color: textColor1),
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: const TextStyle(color: textColor1),
          filled: true,
          fillColor: secondaryColor,
          prefixIcon: const Icon(Icons.lock, color: primaryColor),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: primaryColor,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF222222), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
        obscureText: _obscureText,
      ),
    );
  }
}
