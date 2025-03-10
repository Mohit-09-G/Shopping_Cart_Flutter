import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/database/dbhelper.dart';
import 'package:shop/models/user_model.dart';
import 'package:shop/routes/route.dart' as route;

import '../../widgets/app_primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSwitched = true;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  bool isLoggedIn = false;
  bool isLoading = true;

  getData() async {
    UserModel? user = await DatabaseHelper.instance.getUserStatus();
    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route.homepage,
        (route) => false,
      );

      setState(() {
        isLoggedIn = true;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isLoggedIn = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> validateUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      String emailcontroller = _emailController.text.toString().trim();
      String passwordcontroller = _passwordController.text.toString().trim();

      RegExp emailRegExp =
          RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

      if (emailRegExp.hasMatch(emailcontroller)) {
        UserModel user =
            UserModel(email: emailcontroller, password: passwordcontroller);
        int result = await DatabaseHelper.instance.checkUserCredential(user);
        await DatabaseHelper.instance.userStatus(user);

        if (result > 0) {
          Navigator.pushNamed(context, route.homepage);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: isLoading
            ? CircularProgressIndicator(
                color: Colors.amber,
              )
            : Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/products/login.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFF4F5F9),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Welcome back !",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Sign in to your account",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: Color(0xFF868889),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please fill this field';
                                          }
                                          return null;
                                        },
                                        controller: _emailController,
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: Color(0xFF868889),
                                          ),
                                          hintText: "Enter Email",
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .white, // White border color
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5), // 5px border radius
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .white, // White border color on focus
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5), // 5px border radius
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .white, // White border color when not focused
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5), // 5px border radius
                                          ),
                                          labelText: null,
                                          labelStyle: TextStyle(fontSize: 12),
                                        ),
                                      )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          focusNode: _passwordFocus,
                                          onFieldSubmitted: (value) {},
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please fill this field';
                                            }
                                            return null;
                                          },
                                          controller: _passwordController,
                                          obscureText: !passwordVisible,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.password_outlined,
                                                color: Color(0xFF868889),
                                              ),
                                              hintText: "Enter Password",
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: null,
                                              labelStyle:
                                                  TextStyle(fontSize: 12),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    passwordVisible =
                                                        !passwordVisible;
                                                  });
                                                },
                                                icon: Icon(
                                                  passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Color(0xFF868889),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scaleX: 0.7,
                                                scaleY: 0.5,
                                                child: Switch(
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      _isSwitched = value;
                                                    });
                                                  },
                                                  value: _isSwitched,
                                                  activeColor:
                                                      Color(0xFF6CC51D),
                                                ),
                                              ),
                                              Text(
                                                "Remember me",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Color(0xFF868889),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                          child: Text(
                                        "Forgot password",
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Color(0xFF407EC7),
                                            fontWeight: FontWeight.w500),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  AppPrimaryButton(
                                    buttonText: "Login",
                                    onPressedTapped: () {
                                      validateUser();
                                    },
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Don’t have an account ?",
                                            style: GoogleFonts.poppins(
                                                color: Color(0xFF868889),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                route.registrationpage);
                                          },
                                          child: Text(
                                            " Sign up",
                                            style: GoogleFonts.poppins(
                                                color: Color(0xFF000000),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
