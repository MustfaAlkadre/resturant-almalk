import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/register/forgetpassworld.dart';
import 'package:shared_preferences/shared_preferences.dart';

class changedata extends StatefulWidget {
  int index = 1;

  changedata(this.index);

  @override
  _changedataState createState() => _changedataState(index);
}

class _changedataState extends State<changedata> {
  double w = 0, h = 0;
  int index = 1;

  bool ob = false;
  bool notclick = true;
  bool istrychange = false;
  bool stateres = false;

  var errorName = "";
  var errornewPassword = "";
  var errorEmail = "";
  var errorPassword = "";
  var errorPhone = "";

  TextEditingController Controlar1 = new TextEditingController();
  TextEditingController passwordControlar = new TextEditingController();

  _changedataState(this.index);

  changename(BuildContext context, String n, String p) async {
    stateres = await changeusername(
        Provider.of<mainProvider>(context).user1.token, n, p);
    if (stateres)
      Provider.of<mainProvider>(context,listen: false).changeuserdata(index ,n );
    else
      Fluttertoast.showToast(msg: "not change");
  }

  changephone(BuildContext context, String phone, String p) async {
    stateres = await changeuserphone(
        Provider.of<mainProvider>(context).user1.token, int.parse(phone), p);
    if (stateres)
      Provider.of<mainProvider>(context,listen: false).changeuserdata(index ,phone );
    else
      Fluttertoast.showToast(msg: "not change");
  }

  changeemail(BuildContext context, String e, String p) async {
    stateres = await changeuseremail(
        Provider.of<mainProvider>(context).user1.token, e, p);
    if (stateres)
      Provider.of<mainProvider>(context,listen: false).changeuserdata(index ,e );
    else
      Fluttertoast.showToast(msg: "not change");
  }

  changepassword(BuildContext context, String newp, String oldp) async {
    stateres = await changeuserpassword(
        Provider.of<mainProvider>(context).user1.token, newp, oldp);
    if (stateres)
      Provider.of<mainProvider>(context,listen: false).changeuserdata(index ,newp );
    else
      Fluttertoast.showToast(msg: "not change");
  }

  chickdata(int index, String pass, String text) {
    errorName = "";
    errorPhone = "";
    errorPassword = "";
    errornewPassword = "";
    errorEmail = "";
    if (pass.length < 8)
      setState(() {
        errorPassword = "الرجاء ادخال كلمة السر";
      });
    if (index == 4 && text.length < 8)
      setState(() {
        errornewPassword = "الرجاء ادخال كلمة السر";
      });
    if (index == 3 &&
        (text.isEmpty || !text.contains("@") || !text.contains(".")))
      setState(() {
        errorEmail = "الرجاء ادخال البريد الالكتروني";
      });
    if (index == 1 && text.length < 4)
      setState(() {
        errorName = "الرجاء ادخال الاسم";
      });
    if (index == 2 &&
        (text.length != 10 ||
            int.tryParse(text) == null ||
            !text.startsWith("0")))
      setState(() {
        errorPhone = "الرجاء ادخال رقم الهاتف";
      });
    if (errorEmail == "" &&
        errorPassword == "" &&
        errorName == "" &&
        errorPhone == "")
      setState(() {
        istrychange = true;
      });
  }

  savedata(BuildContext context) async {
    var s = await SharedPreferences.getInstance();
    await Provider.of<mainProvider>(context, listen: false)
        .RemoveUserDataUser(s);
    await Provider.of<mainProvider>(context, listen: false).SaveDataOfUser(s);
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    String errort = "";
    TextInputType typek = TextInputType.name;
    IconData icon = Icons.account_circle;
    String felde2 = "";
    String title = "";
    String felde1 = "";
    if (index == 1) {
      errort = errorName;
      felde2 = "الاسم الجديد";
      felde1 = "كلمة السر";
      title = "تغيير الاسم";
    } else if (index == 2) {
      errort = errorPhone;
      typek = TextInputType.phone;
      icon = Icons.phone;
      felde2 = "رقم الهاتف الجديد";
      felde1 = "كلمة السر";
      title = "تغيير رقم الهاتف";
    } else if (index == 3) {
      errort = errorEmail;
      typek = TextInputType.emailAddress;
      icon = Icons.mail_sharp;
      felde2 = "الايميل الجديد";
      felde1 = "كلمة السر";
      title = "تغيير الايميل";
    } else {
      errort = errornewPassword;
      typek = TextInputType.visiblePassword;
      icon = Icons.remove_red_eye;
      felde2 = "كلمة السر الجديدة";
      felde1 = "كلمة السر القديمة";
      title = "تغيير كلمة السر";
    }
    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_rounded, color: iconColor1),
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
                      title,
                      style: TextStyle(
                          fontSize: 30,
                          inherit: false,
                          fontWeight: FontWeight.bold,
                          color: textColor3),
                    ),
                  ),
                  mytextfield(
                      ispassworld: index == 4 ? true : false,
                      hint: felde2,
                      errortext: errort,
                      controlar: Controlar1,
                      icon: icon,
                      typek: typek),
                  mytextfield(
                      ispassworld: true,
                      hint: felde1,
                      errortext: errorPassword,
                      controlar: passwordControlar,
                      icon: Icons.visibility,
                      typek: TextInputType.visiblePassword),
                  istrychange
                      ? FutureBuilder(
                          future: index == 1
                              ? changename(context, Controlar1.text,
                                  passwordControlar.text)
                              : (index == 2
                                  ? changephone(context, Controlar1.text,
                                      passwordControlar.text)
                                  : (index == 3
                                      ? changeemail(context, Controlar1.text,
                                          passwordControlar.text)
                                      : changepassword(context, Controlar1.text,
                                          passwordControlar.text))),
                          builder: (context, ve) {
                            if (ve.connectionState == ConnectionState.waiting)
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
                            if (stateres) {
                              return FutureBuilder(
                                  future: savedata(context),
                                  builder: (ctx, v) {
                                    if(v.connectionState==ConnectionState.waiting)
                                      return mybutton(
                                          action: null,
                                          title: "");
                                    return mybutton(
                                        action: () => Navigator.of(ctx).pop(),
                                        title: "");
                                  });
                            } else {
                              istrychange = false;
                            }
                            return mybutton(action: ()=>chickdata(index,passwordControlar.text,Controlar1.text), title: "تعديل");
                          })
                      : mybutton(action: ()=>chickdata(index,passwordControlar.text,Controlar1.text), title: "تعديل"),
                ],
              ),
            ),
            Container(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => forgetp())),
                    child: Text(
                      "اضغط هنا",
                      style: TextStyle(
                          fontSize: 16,
                          inherit: false,
                          fontWeight: FontWeight.bold,
                          color: textColor3),
                    )),
                Text(
                  "هل نسيت كلمة السر؟",
                  style: TextStyle(
                      fontSize: 16,
                      inherit: false,
                      fontWeight: FontWeight.bold,
                      color: textColor3),
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
        color: cardColor2,
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
          style: TextStyle(
              fontSize: 16, color: textColor3, fontWeight: FontWeight.w500),
          controller: controlar,
          obscureText: ispassworld ? ob : false,
          keyboardType: typek,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 16, color: hintColor1, fontWeight: FontWeight.w500),
            errorText: errortext == "" ? null : errortext,
            errorStyle: TextStyle(
                fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500),
            hintTextDirection: TextDirection.rtl,
            border: InputBorder.none,
            suffixIcon: ispassworld
                ? IconButton(
                    icon: Icon(ob ? Icons.visibility_off : icon,
                        color: iconColor1.withOpacity(0.5)),
                    onPressed: () {
                      setState(() {
                        ob = !ob;
                        errorEmail = "";
                        errorPassword = "";
                      });
                    },
                  )
                : Icon(icon, color: iconColor1.withOpacity(0.5)),
          ),
        ));
  }

  Widget mybutton({
    required action,
    required String title,
  }) {
    return MaterialButton(
      onPressed: action,
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 10),
        child: title != ""
            ? Text(title, style: TextStyle(fontSize: 18, color: Colors.black))
            : Icon(Icons.check),
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
