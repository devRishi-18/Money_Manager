import 'package:flutter/material.dart';
import 'package:newproject2/controllers/db_helper.dart';
import 'package:newproject2/pages/add_details.dart';

import 'homepage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  DbHelper dbHelper= DbHelper();
  Future getSettings() async{
    String? name = await dbHelper.getName();
    if(name!=null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomePage(),));
    }
    else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AddName(),));

    }
  }

    @override
    void initState() {
      super.initState();
      getSettings();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: Color(0xffe2e7ef),

      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Image.asset(
            "assets/icon.png",
            width: 64.0,
            height: 64.0,
          ),
        ),
      ),
    );
  }
}
