import 'package:flutter/material.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/register/forgetpassworld.dart';
import 'package:restaurant_almalk_app/home/mainscreen.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  double w = 0,
      h = 0;
  bool ob = false;
  var errorEmail = "";
  var errorPassword = "";
  var istrylogin = false;
  TextEditingController emailControlar = new TextEditingController();
  TextEditingController passwordControlar = new TextEditingController();

  chickdata() {
    String p = passwordControlar.text;
    String e = emailControlar.text;
    errorPassword = "";
    errorEmail = "";
    if (p.length < 8)
      setState(() {
        errorPassword = "الرجاء ادخال كلمة السر";
      });
    if (e.isEmpty || !e.contains("@") || !e.contains("."))
      setState(() {
        errorEmail = "الرجاء ادخال البريد الالكتروني";
      });
    if (errorEmail == "" && errorPassword == "")
      setState(() {
        istrylogin = true;
      });
  }


  savedata(BuildContext context)async{
    var s=await SharedPreferences.getInstance();
    await Provider.of<mainProvider>(context,listen: false).SaveDataOfUser(s);
    print(Provider.of<mainProvider>(context).user1.token);
    }



  tryinglogin(String e, String p, BuildContext context) async {
    Provider
        .of<mainProvider>(context)
        .user1 = await loginuser(e, p);
  }

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
                    padding: EdgeInsets.only(top: 10, bottom: 25),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                          fontSize: 30,
                          inherit: false,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  mytextfield(ispassworld: false,
                      hint: "البريد الالكتروني",
                      errortext: errorEmail,
                      controlar: emailControlar,
                      icon: Icons.email_outlined, typek: TextInputType.emailAddress),
                  mytextfield(ispassworld:true,
                      hint: "كلمة السر",
                      errortext: errorPassword,
                      controlar: passwordControlar,
                      icon: Icons.visibility, typek: TextInputType.visiblePassword),
                  istrylogin ? FutureBuilder(
                      future: tryinglogin(
                          emailControlar.text, passwordControlar.text, context),
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
                          return FutureBuilder(
                              future: savedata(context),
                              builder: (ctx,v){
                                return mybutton(action:() =>Navigator.of(ctx).pushReplacement(
                                    MaterialPageRoute(builder: (_) => Zoom(mianscreen())))
                                    , title: "");
                              });
                        } else {
                          istrylogin = false;
                        }
                        return mybutton(action: chickdata, title: "دخول");
                      }) :
                  mybutton(action: chickdata, title: "دخول"),
                  Container(
                    child: Text("مرحبا بك مرة اخرى",
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
                    onPressed: () =>
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => forgetp())),
                    child: Text(
                      "اضغط هنا",
                      style: TextStyle(
                          fontSize: 16,
                          inherit: false,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Text(
                  "هل نسيت كلمة السر؟",
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
      {required bool ispassworld ,required String hint, required String errortext,
        required TextEditingController controlar,
         required IconData icon, required TextInputType typek}) {
    int m=errortext==""?0:1;
    return mycontainer(model: m,
        child: TextFormField(
          controller: controlar,
          obscureText:ispassworld?ob:false,
          keyboardType: typek,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errortext == "" ? null : errortext,
            errorStyle: TextStyle(
                fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500),
            hintTextDirection: TextDirection.rtl,
            border: InputBorder.none,
            suffixIcon:ispassworld? IconButton(
              icon: Icon(
                  ob ? Icons.visibility_off : icon),
              onPressed: () {
                setState(() {
                  ob = !ob;
                  errorEmail = "";
                  errorPassword = "";
                });
              },
            ):Icon(icon),
          ),
        ));
  }

  Widget mybutton({required  action,required String title,}){
    return MaterialButton(
      onPressed: action,
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 10),
        child: title!=""?Text(title, style: TextStyle(fontSize: 18))
            :Icon(Icons.check),
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
