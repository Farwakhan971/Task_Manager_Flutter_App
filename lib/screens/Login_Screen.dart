import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    bool success = await Provider.of<AuthProvider>(context, listen: false)
        .login(_usernameController.text, _passwordController.text);
    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/tasks');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.orange[900]!,
                      Colors.orange[800]!,
                      Colors.orange[400]!,
                    ]
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40,),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login", style: TextStyle(
                          color: Colors.white, fontSize: 40
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Welcome Back", style: TextStyle(
                          color: Colors.white, fontSize: 18
                      ),),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(55),
                            topRight: Radius.circular(55)
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            const SizedBox(height: 60,),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [BoxShadow(
                                      color: Color.fromARGB(225, 95, 27, 3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)
                                  )]
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200]!))
                                    ),
                                    child: TextField(
                                      controller: _usernameController,
                                      decoration: const InputDecoration(
                                        hintText: "Username",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200]!))
                                    ),
                                    child: TextField(
                                      controller: _passwordController,
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      obscureText: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 80,),
                            _isLoading
                                ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[900]!),
                            )
                                : GestureDetector(
                              onTap: () => _login(context),
                              child: Container(
                                height: 50,
                                margin: const EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orange[900]
                                ),
                                child: const Center(
                                  child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}
