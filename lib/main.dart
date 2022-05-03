import 'dart:convert';
import 'package:bloc_login/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin () async{
    // HERE WE CHECK IF THE USER ALREADY LOGIN OR CREDENTIALS ALREADY EXIST OR NOT
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString("login");
    if (val != null){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
        (route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 35
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.email)
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password)
                  ),
                ),
                const SizedBox(height: 20.0),
                OutlinedButton.icon(
                  onPressed: () {
                    login();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text("Login"),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

  void login() async{
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
      var response= await http.post(
        Uri.parse("https://rbsdc.azurewebsites.net/api/account/"),
        body: ({
          "username": emailController,
          "password": passwordController
        })
      );
      if (response.statusCode == 200){
        final body = jsonDecode(response.body);
        // print("Login Token " + body["token"]);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Token : ${body["token"]}")));
        pageRoute(body["token"]);

      }else{
        // print("invalid credentials provided");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
      }
    }else{
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Blank Value Found")));
    }
  }

  void pageRoute( String token) async{
    //  HERE WE STORE VALUE OR TOKEN INSIDE SHARED PREFERENCES
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("login", token);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
            (route) => false
    );
  }
}
