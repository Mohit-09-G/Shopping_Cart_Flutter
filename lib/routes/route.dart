import 'package:flutter/material.dart';
import 'package:shop/screens/add_to_cart.dart';
import 'package:shop/screens/home_page.dart';
import 'package:shop/screens/login_screen/login_screen.dart';
import 'package:shop/screens/login_screen/register_screen.dart';

const String loginpage = 'login';
const String registrationpage = 'register';
const String homepage = 'home';
const String addcartpge = "cart";

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loginpage:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case registrationpage:
      return MaterialPageRoute(builder: (context) => RegisterScreen());
    case homepage:
      return MaterialPageRoute(builder: (context) => HomePage());
    case addcartpge:
      return MaterialPageRoute(builder: (context) => AddToCart(cartItems: []));
    default:
      throw ('sorry');
  }
}
