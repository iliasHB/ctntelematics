import 'package:ctntelematics/core/widgets/custom_input_decorator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_export_util.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/auth_req_entites/login_req_entity.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  PrefUtils prefUtils = PrefUtils();

  bool isPasswordVisible = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Function to save auth_user into SharedPreferences
  Future<void> _saveAuthUser(
      String first_name,
      String last_name,
      String middle_name,
      String email,
      String token,
      String phone,
      String status,
      String user_type, int id) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefUtils.setStringList('auth_user', <String>[
      first_name,
      last_name,
      middle_name,
      email,
      token,
      phone,
      status,
      user_type,
      id.toString()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              "assets/images/tematics_name.jpeg",
              height: 100,
            ),
            const SizedBox(height: 40),

            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.green,
                      decoration: customInputDecoration(
                          labelText: 'Username or email',
                          hintText: 'abc@gmail.com'),
                      validator: (value) {
                        if (_emailController.text.isEmpty ||
                            _emailController.text == "") {
                          return "Username or email is empty";
                        }
                        return null;
                      },

                      // InputDecoration(
                      //   labelText: 'Username or email',
                      //   hintText: 'francisjoe@gmail.com',
                      //   hintStyle: AppStyle.cardfooter,
                      //   prefixIcon: const Icon(Icons.email_outlined,
                      //       color: Colors.green),
                      //   filled: true,
                      //   fillColor: Colors.grey[200],
                      //   border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(10),
                      //     borderSide: BorderSide.none,
                      //   ),
                      // ),
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: isPasswordVisible,
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'abc@gmail.com',
                        hintStyle: AppStyle.cardfooter
                            .copyWith(fontSize: 12, color: Colors.grey[600]),
                        labelStyle: AppStyle.cardfooter
                            .copyWith(fontSize: 12, color: Colors.green[800]),
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.green),
                        suffix: InkWell(
                            onTap: () {
                              setState(() {
                                isPasswordVisible
                                    ? isPasswordVisible = false
                                    : isPasswordVisible = true;
                              });
                            },
                            child: isPasswordVisible
                                ? const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.green,
                                  )),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (_passwordController.text.isEmpty ||
                            _passwordController.text == "") {
                          return "Password is empty";
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            // Username/Email Field

            const SizedBox(height: 16),

            // Remember me and Forgotten Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (bool? value) {},
                      activeColor: Colors.green,
                    ),
                    const Text('Remember me'),
                  ],
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/forgetPassword"),
                  child: Text(
                    'Forgotten Password?',
                    style: AppStyle.cardfooter
                        .copyWith(fontSize: 14, color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocConsumer<LoginBloc, AuthState>(
              listener: (context, state) {
                if (state is LoginDone) {
                  print("token::::::${state.resp.token}");
                  _saveAuthUser(
                    state.resp.user.first_name,
                    state.resp.user.last_name,
                    state.resp.user.middle_name,
                    state.resp.user.email,
                    'Bearer ${state.resp.token}',
                    state.resp.user.phone,
                    state.resp.user.status,
                    state.resp.user.user_type,
                    state.resp.user.id,
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/bottomNav',
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.resp.message)));
                } else if (state is AuthFailure) {
                  // if (state.message.contains("Unauthenticated")) {
                  // Navigator.pushNamed(context, "/login");
                  // }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(
                    child: SizedBox(
                      height: 30, // Adjust the height
                      width: 30, // Adjust the width
                      child: CircularProgressIndicator(
                        strokeWidth: 3, // Adjust the thickness
                        color: Colors
                            .green, // Optional: Change the color to match your theme
                      ),
                    ),
                  );
                }
                return CustomPrimaryButton(
                  label: 'Log in',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final loginReqEntity = LoginReqEntity(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim());
                      context.read<LoginBloc>().add(LoginEvent(loginReqEntity));
                    }
                  },
                );

                //   ElevatedButton(
                //   onPressed: () {
                //     if (_formKey.currentState?.validate() ?? false) {
                //       final loginReqEntity = LoginReqEntity(
                //           email: _emailController.text.trim(),
                //           password: _passwordController.text.trim());
                //       context.read<LoginBloc>().add(LoginEvent(loginReqEntity));
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(vertical: 16.0),
                //     child: Text(
                //       'Login',
                //       style: AppStyle.cardfooter.copyWith(fontSize: 16),
                //     ),
                //   ),
                // );
              },
            ),
            // Login Button

            const SizedBox(height: 20),

            // Terms & Conditions
            Text(
              'By successful login you are agreeing with our Terms & Conditions and Privacy Policy.',
              textAlign: TextAlign.center,
              style: AppStyle.cardfooter
                  .copyWith(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
