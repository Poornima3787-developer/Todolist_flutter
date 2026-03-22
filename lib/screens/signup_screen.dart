import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/homeScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  Future<void> signup() async {
    print("🔥 signup function started");
    final response = await AuthService().signup(
      emailController.text,
      pwdController.text,
    );
    print("Signup Response: $response");
    if (response['success'] == true) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Signup failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: pwdController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () async{
    print("Signup button clicked"); // 👈 ADD THIS
    await signup();
  },
 child: Text("Signup")),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Already have an account?Login'),
            ),
          ],
        ),
      ),
    );
  }
}
