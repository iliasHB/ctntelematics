import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/core/widgets/custom_input_decorator.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.abc, color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and title
              Image.asset("assets/images/tematics_name.jpeg", height: 100,),
              const SizedBox(height: 40),
              // Username/Email Field
              TextField(
                cursorColor: Colors.green,
                decoration: customInputDecoration(
                    labelText: 'Firstname',
                    hintText: 'Enter your firstname',
                    prefixIcon: const Icon(Icons.person, color: Colors.green),
                )
                // InputDecoration(
                //   labelText: 'firstname',
                //   hintText: 'francisjoe@gmail.com',
                //   prefixIcon: const Icon(Icons.person, color: Colors.green),
                //   filled: true,
                //   fillColor: Colors.grey[200],
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: BorderSide.none,
                //   ),
                // ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: customInputDecoration(
                  labelText: 'Middle-name',
                  hintText: 'Enter your middle-name',
                  prefixIcon: const Icon(Icons.person, color: Colors.green),
                )
                // InputDecoration(
                //   labelText: 'middlename',
                //   hintText: 'francisjoe@gmail.com',
                //   prefixIcon: const Icon(Icons.person, color: Colors.green),
                //   filled: true,
                //   fillColor: Colors.grey[200],
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: BorderSide.none,
                //   ),
                // ),
              ),
              const SizedBox(height: 16),
              TextField(
                  decoration: customInputDecoration(
                    labelText: 'Lastname',
                    hintText: 'Enter your last-name',
                    prefixIcon: const Icon(Icons.person, color: Colors.green),
                  )
                // InputDecoration(
                //   labelText: 'lastname',
                //   hintText: 'francisjoe@gmail.com',
                //   prefixIcon: const Icon(Icons.person, color: Colors.green),
                //   filled: true,
                //   fillColor: Colors.grey[200],
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: BorderSide.none,
                //   ),
                // ),
              ),
              const SizedBox(height: 16),
              TextField(
                  decoration:
                  customInputDecoration(
                    labelText: 'Phone number',
                    hintText: 'Enter your phone number',
                    prefixIcon: const Icon(Icons.call, color: Colors.green),
                  )
                // decoration: InputDecoration(
                //   labelText: 'phone number',
                //   hintText: 'francisjoe@gmail.com',
                //   prefixIcon: const Icon(Icons.call, color: Colors.green),
                //   filled: true,
                //   fillColor: Colors.grey[200],
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: BorderSide.none,
                //   ),
                // ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration:  customInputDecoration(
                  labelText: 'email',
                  hintText: 'abc@gmail.com',
                  // prefixIcon: const Icon(Icons.call, color: Colors.green),
                )
                // InputDecoration(
                //   labelText: 'email',
                //   hintText: 'francisjoe@gmail.com',
                //   prefixIcon: const Icon(Icons.email_outlined, color: Colors.green),
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
                  obscureText: true,
                decoration:  customInputDecoration(
                  labelText: 'Password',
                  hintText: '*******',
                  prefixIcon: const Icon(Icons.lock, color: Colors.green),
                )
                // InputDecoration(
                //   labelText: 'Password',
                //   hintText: 'Francisjoe@123',
                //   prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                //   suffixIcon: const Icon(Icons.visibility, color: Colors.green),
                //   filled: true,
                //   fillColor: Colors.grey[200],
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: BorderSide.none,
                //   ),
                // ),

              ),
              const SizedBox(height: 16),

              TextFormField(
                  obscureText: true,
                  decoration:  customInputDecoration(
                    labelText: 'confirm password',
                    hintText: '*******',
                    prefixIcon: const Icon(Icons.lock, color: Colors.green),
                  )
                // InputDecoration(
                //   labelText: 'confirm password',
                //   hintText: 'francisjoe@gmail.com',
                //   prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                //   filled: true,
                //   fillColor: Colors.grey[200],
                //   border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: BorderSide.none,
                //   ),
                // ),
              ),
              const SizedBox(height: 16),

              // Remember me and Forgotten Password
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         Checkbox(
              //           value: true,
              //           onChanged: (bool? value) {},
              //           activeColor: Colors.green,
              //         ),
              //         const Text('Remember me'),
              //       ],
              //     ),
              //     TextButton(
              //       onPressed: () => Navigator.pushNamed(context, "/forgetPassword"),
              //       child: const Text(
              //         'Forgotten Password?',
              //         style: TextStyle(color: Colors.red),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),

              // Login Button
              CustomPrimaryButton(label: 'Signup',
                onPressed: () {
                // Navigator.pushNamed(context, "/login");
              },),
              // ElevatedButton(
              //   onPressed: () {},
              //   style:
              //   ElevatedButton.styleFrom(
              //     backgroundColor: Colors.green,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(vertical: 16.0),
              //     child: Text(
              //       'Login',
              //       style: TextStyle(fontSize: 18),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20),

              // Back to Login Button
              CustomSecondaryButton(
                  label:  'Back to login',
                  onPressed: () =>Navigator.pushNamed(context, "/login"))
              // TextButton.icon(
              //   onPressed: () {
              //     Navigator.pushNamed(context, "/login");
              //   },
              //   icon: Icon(Icons.arrow_back, color: Colors.black),
              //   label: Text(
              //     'Back to login',
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   style: TextButton.styleFrom(
              //     padding: EdgeInsets.symmetric(vertical: 16.0),
              //     shape: RoundedRectangleBorder(
              //       side: BorderSide(color: Colors.black),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),
        //
              // Terms & Conditions
              // const Text(
              //   'By successful login you are agreeing with our Terms & Conditions and Privacy Policy.',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(color: Colors.grey, fontSize: 12),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
