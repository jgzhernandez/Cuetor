import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import '../home.dart';
// import 'welcome.dart';
// import 'signUpScreen.dart';
import 'signInScreen.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  
  void _resetpass() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar( content:  Text('Reset email sent!')));

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar( content:  Text('An error occured! ${e.code}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Send Reset E-mail'),
                    onPressed: _isLoading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        _resetpass();
                        }
                    },
                  ),
                  //SignInButton()   
                ],
              ),
              SizedBox(height:10),
              SignInButton()   
            ],
          ),
        ),
      ),
    );
  }
    Row SignInButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Back to Sign In page "),
        GestureDetector(
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          child: const Text("Sign In", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)
        )

      ],
    );

  }
}
