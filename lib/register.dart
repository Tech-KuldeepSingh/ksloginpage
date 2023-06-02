import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:ksloginpage/login.dart';
import 'package:ksloginpage/service/authService.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
       return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login_bg1.png'), fit: BoxFit.fill
          )
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: 'Name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true, // secure password
                      decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white,
                              fontSize: 28, fontWeight: FontWeight.w400),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            color: Colors.white,
                            onPressed: handleSignUp,
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleSignUp() {
    // pick input values
    final String email = emailController.text;
    final String name = nameController.text;
    final String password = passwordController.text;

    // TODO: add validation here...

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Signing Up...'),
                  SizedBox(height: 16.0),
                  SpinKitCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                ],
              ),
            ),
          );
        },
      );

      authService.signUp(name, email, password).then((value) {
        Navigator.pop(context); // Close the loading dialog

        if (value) {
          // Navigate to login page
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('Registration completed !!'),
              actions: [
                TextButton(
                  onPressed: () => navigateToLogin(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Failed'),
              content: Text('Could not complete the registration'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    } catch (e) {
      // printing the error information
      print(e);
    }
  }


  // navigate to login page after successful registeration.
  navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyLogin()),
    );
  }
}
