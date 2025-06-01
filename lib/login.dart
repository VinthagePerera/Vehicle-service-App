import 'package:flutter/material.dart';
import 'package:project1/auth.dart';
import 'package:project1/components/label.dart';
import 'package:project1/components/my-text%20_field.dart';
import 'package:project1/components/my_buttons.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFe8f7fb),
        body: Container(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Image(
                      height: 190,
                      image: AssetImage(
                        'assets/logo.png',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Label(
                    text: 'User Name',
                  ),
                  //Email Text Field
                  My_text_feild(
                    controller: usernamecontroller,
                    hintText: 'User Name',
                  ),
                  const Label(
                    text: 'Password',
                  ),
                  //Password text Field
                  My_text_feild(
                    controller: passwordcontroller,
                    hintText: 'Password',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11.6),
                    child: Row(     
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Forget Password',
                            style: TextStyle(
                              fontSize: 17.5,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: ()  {
                      AuthService.signIn(
                        email: usernamecontroller.text,
                        password: passwordcontroller.text,
                        context: context,
                        onError: (error) {
                          print('$error');
                        },
                      );
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF130E4E),
                        fixedSize: const Size(223, 56),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  My_Buttons(
                    onpressed: () {
                      Navigator.pushReplacementNamed(context, '/perinfo');
                    },
                    size: 10,
                    text: 'Create An Account',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
