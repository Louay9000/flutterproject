
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/ForgotPasswordScreen.dart';
import 'package:flutterproject/Home.dart';
import 'package:flutterproject/Homee.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'SignUpScreen.dart';


class SignInScreen extends StatelessWidget {
final _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

  SignInScreen({super.key});

void _signIn(BuildContext context) async {
  // Connexion de l'utilisateur avec email et mot de passe via Firebase
  if (_formKey.currentState!.validate()) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigation vers la page d'accueil après connexion réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homee()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'Aucun utilisateur trouvé avec cet email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mot de passe incorrect.';
      } else {
        errorMessage = 'Erreur lors de la connexion. Veuillez réessayer.';
      }

      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Erreur de connexion',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
    centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to our App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Image.asset('assets/images/food.png', height: 40, color: Colors.white),
        ],
      ),
      backgroundColor: Colors.blueGrey,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Image.asset(
                'assets/images/hamburger.png', 
                height: 120,
              ),
            ),
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey, 
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Please sign in to your account',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 25),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.email), 
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock), 
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _signIn(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blueGrey, 
                    ),
                    icon: Image.asset(
                      'assets/images/login.png',
                      height: 24,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Login', 
                      style: TextStyle(fontSize: 16, 
                      color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      _signInWithGoogle(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    
                    icon: Image.asset(
                      'assets/images/google.png', 
                      height: 24,
                    ),
                    label: Text(
                      'Login with Google',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.blueGrey), 
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(color: Colors.blueGrey), 
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


void _signInWithGoogle(BuildContext context) async {
  var googleuser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;

  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  print(userCredential.user?.email);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Home()),
  );
}



}