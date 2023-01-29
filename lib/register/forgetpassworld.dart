import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/register/register.dart';
import 'package:restaurant_almalk_app/home/mainscreen.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';

class forgetp extends StatefulWidget {
  @override
  _forgetpState createState() => _forgetpState();
}

class _forgetpState extends State<forgetp> {
  double w=0,h=0;
  var errorEmail = "";
  var istrylogin = false;
  TextEditingController emailControlar = new TextEditingController();

  chickdata() {
    String e = emailControlar.text;
    errorEmail = "";
    if (e.isEmpty || !e.contains("@") || !e.contains("."))
      setState(() {
        errorEmail = "الرجاء ادخال البريد الالكتروني";
      });
    if (errorEmail == "")
      tryinglogin("", context);
      /*setState(() {
        istrylogin = true;
      });*/
  }


  tryinglogin(String e, BuildContext context){
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Zoom(mianscreen()))) ;
  }

  @override
  Widget build(BuildContext context) {
     w = MediaQuery.of(context).size.width;
     h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 25, left: 20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "الحصول على كلمة المرور",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 30,
                          inherit: false,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  mytextfield(hint: "البريد الالكتروني", errortext: errorEmail,
                      controlar: emailControlar, icon: Icons.email_outlined,
                      typek: TextInputType.emailAddress),
                  /*istrylogin ? FutureBuilder(
                      future: tryinglogin(
                          emailControlar.text, context),
                      builder: (context, v) {
                        if (v.connectionState == ConnectionState.waiting)
                          return Container(
                              margin: EdgeInsets.only(top: 20, bottom: 10),
                              child: CircularProgressIndicator(),
                              width: w / 2,
                              height: h / 18,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.lightGreenAccent,
                                borderRadius: BorderRadius.circular(20.0),
                              ));
                        if (Provider
                            .of<mainProvider>(context)
                            .user1
                            .id != 0) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Zoom(mianscreen())));
                        } else {
                          istrylogin = false;
                        }
                        return mybutton(action:chickdata , title: "تاكيد");
                      }) :*/
                  mybutton(action:chickdata , title: "تاكيد"),
                  Container(
                    child: Text(
                        "ستصل رسالة على البريد الكتروني المدخل لتعيين كلمة سر جديدة ",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            Container(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => register())),
                    child: Text(
                      "انشاء",
                      style: TextStyle(
                          fontSize: 16,
                          inherit: false,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Text(
                  "هل تريد انشاء حساب جديد؟",
                  style: TextStyle(
                      fontSize: 16,
                      inherit: false,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget mycontainer({required int model, required Widget child}) {
    return Container(
      height:  model==0 ? h / 20 : h / 10,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: child,
    );
  }

  Widget mytextfield(
      {required String hint, required String errortext,
        required TextEditingController controlar,
        required IconData icon, required TextInputType typek}) {
    int m=errortext==""?0:1;
    return mycontainer(model: m,
        child: TextFormField(
          controller: controlar,
          keyboardType: typek,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errortext == "" ? null : errortext,
            errorStyle: TextStyle(
                fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500),
            hintTextDirection: TextDirection.rtl,
            border: InputBorder.none,
            suffixIcon:Icon(icon),
          ),
        ));
  }

  Widget mybutton({required void Function() action,required String title,}){
    return MaterialButton(
      onPressed: action,
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 10),
        child: Text(title, style: TextStyle(fontSize: 18)),
        width: w / 2,
        height: h / 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

}
