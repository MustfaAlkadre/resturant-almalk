import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/home/mainscreen.dart';
import 'package:restaurant_almalk_app/models/user.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  double w = 0, h = 0;
  bool ob = false;
  var errorName = "";
  var errorPhone = "";
  var errorEmail = "";
  var errorPassword = "";
  var istryregister = false;
  TextEditingController nameControlar = new TextEditingController();
  TextEditingController phoneControlar = new TextEditingController();
  TextEditingController emailControlar = new TextEditingController();
  TextEditingController passwordControlar = new TextEditingController();

  chickdata() {
    String phone = phoneControlar.text;
    String name = nameControlar.text;
    String passworld = passwordControlar.text;
    String email = emailControlar.text;

    errorName = "";
    errorPhone = "";
    errorPassword = "";
    errorEmail = "";
    if (passworld.length < 8)
      setState(() {
        errorPassword = "الرجاء ادخال كلمة السر";
      });
    if (email.isEmpty || !email.contains("@") || !email.contains("."))
      setState(() {
        errorEmail = "الرجاء ادخال البريد الالكتروني";
      });
    if (name.length < 4)
      setState(() {
        errorName = "الرجاء ادخال الاسم";
      });
    if (phone.length != 10 ||
        int.tryParse(phone) == null ||
        !phone.startsWith("0"))
      setState(() {
        errorPhone = "الرجاء ادخال رقم الهاتف";
      });
    if (errorEmail == "" &&
        errorPassword == "" &&
        errorName == "" &&
        errorPhone == "")
      setState(() {
        istryregister = true;
      });
  }

  regist(BuildContext context)async{
    var s=await SharedPreferences.getInstance();
    Provider.of<mainProvider>(context,listen: false).SaveDataOfUser(s);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Zoom(mianscreen())));
  }

  tryingregister(BuildContext context, String email, String phone, String name,
      String password) async {
    Provider.of<mainProvider>(context).user1 = user(
        phone: int.parse(phone),
        name: name,
        email: email,
        password: password,
        regdate: DateTime.now());
    await registeruser(Provider.of<mainProvider>(context).user1);
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
                  Row(children: [
                    Expanded(
                      child: IconButton(
                          onPressed: null,
                          iconSize: w / 3,
                          icon: Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                          )),
                    ),
                    Column(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "انشاء حساب",
                            style: TextStyle(
                                fontSize: 30,
                                inherit: false,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "جديد",
                            style: TextStyle(
                                fontSize: 30,
                                inherit: false,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  mytextfield(
                      ispassworld: false,
                      hint: "الاسم الكامل",
                      errortext: errorName,
                      controlar: nameControlar,
                      icon: Icons.account_box_outlined,
                      typek: TextInputType.name),
                  mytextfield(
                      ispassworld: false,
                      hint: "البريد الالكتروني",
                      errortext: errorEmail,
                      controlar: emailControlar,
                      icon: Icons.email_outlined,
                      typek: TextInputType.emailAddress),
                  mytextfield(
                      ispassworld: true,
                      hint: "كلمة السر",
                      errortext: errorPassword,
                      controlar: passwordControlar,
                      icon: Icons.visibility,
                      typek: TextInputType.visiblePassword),
                  mytextfield(
                      ispassworld: false,
                      hint: "رقم الهاتف",
                      errortext: errorPhone,
                      controlar: phoneControlar,
                      icon: Icons.phone,
                      typek: TextInputType.phone),
                  istryregister
                      ? FutureBuilder(
                          future: tryingregister(
                              context,
                              emailControlar.text,
                              phoneControlar.text,
                              nameControlar.text,
                              passwordControlar.text),
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
                            if (Provider.of<mainProvider>(context).user1.id !=
                                0) {
                              return mybutton(action:() => regist(context), title: "");
                            } else {
                                istryregister = false;
                            }
                            return mybutton(action: chickdata, title: "انشاء");
                          })
                      : mybutton(action: chickdata, title: "انشاء"),
                  Container(
                    child: Text(
                        "عند الضغط على الزر انت توفافق على جميع القوانين الخاصة بالتطبيق",
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
                       onPressed: () => Navigator.of(context)
                         .push(MaterialPageRoute(builder: (context) => login())),
                       child: Text(
                         "تسجيل دخول",
                         style: TextStyle(
                          fontSize: 16,
                          inherit: false,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                     )),
                    Text(
                    "هل تملك حساب؟",
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
      height: model == 0 ? h / 20 : h / 10,
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
      {required bool ispassworld,
      required String hint,
      required String errortext,
      required TextEditingController controlar,
      required IconData icon,
      required TextInputType typek}) {
    int m = errortext == "" ? 0 : 1;
    return mycontainer(
        model: m,
        child: TextFormField(
          controller: controlar,
          obscureText: ispassworld ? ob : false,
          keyboardType: typek,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errortext == "" ? null : errortext,
            errorStyle: TextStyle(
                fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500),
            hintTextDirection: TextDirection.rtl,
            border: InputBorder.none,
            suffixIcon: ispassworld
                ? IconButton(
                    icon: Icon(ob ? Icons.visibility_off : icon),
                    onPressed: () {
                      setState(() {
                        ob = !ob;
                        errorEmail = "";
                        errorPassword = "";
                      });
                    },
                  )
                : Icon(icon),
          ),
        ));
  }

  Widget mybutton({
    required void Function() action,
    required String title,
  }) {
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