import 'package:flutter/material.dart';
import 'package:restaurant_almalk_app/config.dart';
class AboutUs extends StatelessWidget {
  double w = 0,
      h = 0;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery
        .of(context)
        .size
        .width;
    h = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        leading: Text(""),
        actions: [
          IconButton(onPressed: ()=> Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios,color: iconColor1,))
        ],
        title:  Center(child: Text("حول مطعمنا",style: TextStyle(fontWeight: FontWeight.bold,fontSize:22,color: textColor3 ),)),
        backgroundColor: headerColor1,
      ),
      body: ListView(
        children: [
          Container(
              height:h/3 ,
              width:w ,
              child: Image(fit: BoxFit.fill,image: AssetImage("images/images1.jpg"),)),
             Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:[
                textp("مطعم الملك هو نوع من المطاعم الذي "),
                textp("يتميز بتقديم قائمة محدودة من الوجبات "),
                textp("سريعة التحضير"),
                textp("سنة الانشاء :"),
                textp(" تم افتاح مطعمنا في 2016/2/20"),
                textp("الموقع:"),
                textp("سوريا-حمص-شارع الباص"),
                textp("الاقسام الموجودة في المطعم:"),
                textp("قسم المعجنات"),
                textp("قسم وجبات الدجاج"),
                textp("قسم الشاورما"),
              ],
            ),
        ],
      ),
    );
  }
  Widget textp(String text){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child:Text(text,
          textAlign:TextAlign.right, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: textColor3))
    )
    ;
  }
}
