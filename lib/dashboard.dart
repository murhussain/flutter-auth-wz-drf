import 'package:bloc_login/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String token = "";
  @override
  void initState() {
    //  TODO: Implement initState
    super.initState();
    getCred();
  }

  void getCred() async{
    //  HERE WE FETCH OUR CREDENTIALS FROM SHARED PREF
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text("WELCOME USER"),
              const SizedBox(height: 15.0,),
              Text("Your Token: ${token} "),
              const SizedBox(height: 20.0),
              OutlinedButton.icon(
                onPressed: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text("Logout"),
              )
            ],
          )
          )
        ),
      ),
    );
  }
}
