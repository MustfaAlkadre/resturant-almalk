import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:restaurant_almalk_app/main.dart';
import 'package:restaurant_almalk_app/register/register.dart';
import 'package:restaurant_almalk_app/register/login.dart';
class tip1 extends StatefulWidget {

  @override
  _tip1State createState() => _tip1State();
}

class _tip1State extends State<tip1> {
  late PageController controller;
  double h=0.0;
  @override
  void initState() {
    super.initState();
    controller = PageController();
  }
  @override
  void dispose() {
    controller.dispose();
  super.dispose();
  }
  int counter = 0;

  @override
  Widget build(BuildContext context) {
     double w = MediaQuery.of(context).size.width;
     h = MediaQuery.of(context).size.height /5;
    return Scaffold(
      body:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                          child: Container(
                            height: h*4+h/2,
                            child: PageIndicatorContainer(
                              child: PageView(
                                children: <Widget>[
                                  buildtip("images/tip1.png","مرحبا بكم في مطعمنا"),
                                  buildtip("images/tip2.png","اطباقنا ذات جودة عالية"),
                                  buildtip("images/tip3.png","طعامك سيصلك اينما كتت مع خدمة التوصل"),
                                ],
                                controller: controller,
                                reverse: true,
                              ),
                              align: IndicatorAlign.bottom,
                              length: 3,
                              indicatorSpace: 10.0,
                              indicatorColor: Colors.teal,
                              indicatorSelectorColor: Colors.tealAccent ,
                            ),
                          )
                      )
                    ],) ,
                ),
                Container(
                  child:TextButton(onPressed:()=> Navigator.of(context).push(MaterialPageRoute(builder:(context)=>login())),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.login_rounded,color: Colors.deepPurple,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Text("Login"),
                        ),],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: h/2,
            decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius:BorderRadius.vertical(top:Radius.circular(10)),
              ),
            child: Column(
              children: [
                MaterialButton(onPressed:()=> Navigator.of(context).push(MaterialPageRoute(builder:(context)=>register())),
                  child: Container(
                      child: Text("انشاء حساب"),
                      width: w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius:BorderRadius.circular(10.0),
                       ),
                    ),),
                MaterialButton(onPressed: null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius:BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.facebook,color: Colors.deepPurple,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("تواصل معنا "),
                          ),],
                      ),
                    ),
                ),],
            ),
          ),
        ],),
      );
  }
        Widget buildtip(String image , String text){
         return Stack(
           textDirection: TextDirection.rtl,
                 alignment: Alignment.center,
                 children: [
                   Container(
                     height: h*4+h/3,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.vertical(bottom:Radius.circular(20)),
                       image:DecorationImage(
                         image:  AssetImage(image),
                         fit: BoxFit.contain,
                   ),
                 ),
               ),
                   Positioned(
                     bottom: h/2,
                   child: Text(text,
                     style:TextStyle(fontSize: 20,inherit: false,fontWeight: FontWeight.bold),)
                   ),
             ],
           );}
}