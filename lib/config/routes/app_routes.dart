import 'package:ctntelematics/modules/authentication/presentation/pages/onBoarding_page.dart';
import 'package:ctntelematics/modules/eshop/presentation/widgets/checkout.dart';
import 'package:ctntelematics/modules/profile/presentation/pages/setting_widget.dart';
import 'package:ctntelematics/modules/dashboard/presentation/pages/dashboard_page.dart';
import 'package:ctntelematics/modules/service/presentation/pages/service_page.dart';
import 'package:ctntelematics/modules/vehincle/presentation/pages/vehicle_page.dart';
import 'package:flutter/material.dart';

import '../../home.dart';
import '../../modules/authentication/presentation/pages/forgetPwd_page.dart';
import '../../modules/authentication/presentation/pages/login_page.dart';
import '../../modules/authentication/presentation/pages/resetPwd_page.dart';
import '../../modules/authentication/presentation/pages/signup_page.dart';
import '../../modules/authentication/presentation/pages/verify_email_page.dart';
import '../../modules/authentication/presentation/widgets/response_widget.dart';
import '../../modules/eshop/presentation/widgets/payment_method.dart';
import '../../core/widgets/payment_success.dart';
import '../../modules/eshop/presentation/widgets/product_review.dart';
import '../../modules/home/presentation/widgets/bottom_nav_bar.dart';
import '../../modules/map/presentation/pages/map_page.dart';
import '../../modules/profile/presentation/widgets/change_pwd_widget.dart';
import '../../modules/profile/presentation/widgets/response_widget.dart';



final routes = {
  '/': (BuildContext context) => OnboardingPage(),
  '/login': (BuildContext context) => LoginPage(),
  '/signup': (BuildContext context) => SignupPage(),
  // '/home': (BuildContext context) => const Home(),
  '/map': (BuildContext context) => MapPage(),
  '/bottomNav': (BuildContext context) =>  BottomNavBar(),
  '/forgetPassword': (BuildContext context) =>  ForgotPasswordPage(),
  '/resetPassword': (BuildContext context) =>  ResetPasswordPage(),
  '/response': (BuildContext context) =>  ResponsePage(),
  '/responseProfile': (BuildContext context) =>  ResponseProfilePage(),
  '/paymentSuccess': (BuildContext context) =>  const PaymentSuccess(),
  '/setting': (BuildContext context) =>  const Setting(),
};