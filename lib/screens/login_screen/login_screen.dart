import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/screens/login_screen/register_screen.dart';
import 'package:shop/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome back !",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Sign in to your account",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Color(0xFF868889),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                  fontSize: 12, fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF868889),
                                  ),
                                  hintText: "Enter Email",
                                  fillColor: Color(0xFFFFFFFF),
                                  filled: true,
                                  border: InputBorder.none,
                                  labelText: null,
                                  labelStyle: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                              controller: _passwordController,
                              obscureText: !passwordVisible,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.password_outlined,
                                    color: Color(0xFF868889),
                                  ),
                                  hintText: "Enter Password",
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: null,
                                  labelStyle: TextStyle(fontSize: 12),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Remember me",
                                style: TextStyle(color: Color(0xFF868889)),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              child: Text(
                            "Forgot password",
                            style: TextStyle(color: Color(0xFF407EC7)),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
