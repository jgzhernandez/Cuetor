import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import '../home.dart';
// import 'welcome.dart';
import 'signInScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  bool _isLoading = false;

    void _signup() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully!')),
        );

//      DatabaseReference ref = FirebaseDatabase.instance.ref("users");
 //     await ref.set({
 //       "userName": _userNameController.text,
 //       "uid": FirebaseAuth.instance.currentUser?.uid
 //     });

      Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInScreen()));
      

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred! ${e.code}')));
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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  }
                  return null;
                },
              ),
              const SizedBox(height:16),
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Username'),
                //keyboardType: TextInputType.userName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        _signup();
                        }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Sign Up'),
                  ),
                  //SignInButton()   
                ],
              ),
              const SizedBox(height:10),
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
        const Text("Already Have an account? "),
        GestureDetector(
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => const SignInScreen()));
          },
          child: const Text("Sign In", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)
        )

      ],
    );

  }
}