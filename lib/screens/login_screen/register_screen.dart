import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/screens/login_screen/login_screen.dart';
import 'package:shop/widgets/app_primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = false;
  bool cpasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();

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
                  'assets/products/register.png',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Create account",
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
                                "Quickly create account",
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
                                    fontSize: 12, fontWeight: FontWeight.w300),
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
                                      color: Colors.white, // White border color
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
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
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password_outlined,
                                        color: Color(0xFF868889),
                                      ),
                                      hintText: "Enter Password",
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
                            height: 5,
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
                                  controller: _cpasswordController,
                                  obscureText: !cpasswordVisible,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password_outlined,
                                        color: Color(0xFF868889),
                                      ),
                                      hintText: "Confirm Password",
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: null,
                                      labelStyle: TextStyle(fontSize: 12),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            cpasswordVisible =
                                                !cpasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                          cpasswordVisible
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
                          AppPrimaryButton(
                            buttonText: "Signup",
                            onPressedTapped: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
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
                                    "Already have an account ?",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xFF868889),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: Text(
                                    " Login",
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
    );
    ;
  }
}
