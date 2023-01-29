import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/category/categories.dart';
import 'package:restaurant_almalk_app/category/request.dart';
import 'package:restaurant_almalk_app/home/home.dart';
import 'package:restaurant_almalk_app/home/mainscreen.dart';
import 'package:restaurant_almalk_app/models/user.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/register/login.dart';
import 'package:restaurant_almalk_app/register/register.dart';
import 'package:restaurant_almalk_app/shopping_bag/shopping_bag.dart';
import 'package:restaurant_almalk_app/tips/tip1.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:restaurant_almalk_app/category/categories.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<mainProvider>(create:(_)=>mainProvider())],
    builder:(BuildContext ctx,_)=>MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: mysplash(),
    ),
  ));
}


class mysplash extends StatefulWidget {
  @override
  State<mysplash> createState() => _mysplashState();
}

class _mysplashState extends State<mysplash> {

  var islogin=false;
  var isfirstv=true;


  getstate(BuildContext context)async{
  SharedPreferences s=await SharedPreferences.getInstance();
  var id = s.getInt("id")!=null?s.getInt("id"):0;
  var dark= s.getBool("isdark")!=null?s.getBool("isdark"):false;
  isdark=dark!=null?dark:false;
  Provider.of<mainProvider>(context,listen: false).switchtheme();
  var token =  s.getString("token")!=null?s.getString("token"):"";
    setState(() {
      isfirstv=id==0;
      islogin=token!="";
    });
  }

  @override
  Widget build(BuildContext context){
    double w = MediaQuery.of(context).size.width / 3;
    return FutureBuilder(
        future: getstate(context),
        builder: (ctx,v){
          return SplashScreen(
            seconds: 3,
            navigateAfterSeconds:isfirstv?tip1():(islogin?Zoom(mianscreen()):register()),
            image: Image.asset("images/im.png"),
            photoSize: w/2,
            backgroundColor: Colors.tealAccent,
            loaderColor: Colors.white,
          );
        });
  }
}
