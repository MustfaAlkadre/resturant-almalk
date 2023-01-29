import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/category/changedata.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mysetting extends StatefulWidget {
  @override
  _mysettingState createState() => _mysettingState();
}

class _mysettingState extends State<mysetting> {
  double w = 0, h = 0;
  bool notclick = true;

  logout1(BuildContext context) async {
    await logoutuser(Provider.of<mainProvider>(context).user1.token);
    Provider.of<mainProvider>(context).user1.token = "";
    var s = await SharedPreferences.getInstance();
    Provider.of<mainProvider>(context, listen: false).RemoveUserDataUser(s);
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: backgroundColor2,
        appBar: AppBar(
          leading: Text(""),
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: iconColor1,
                ))
          ],
          title: Center(
              child: Text(
            "الاعادات",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: textColor3),
          )),
          backgroundColor: backgroundColor2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(Provider.of<mainProvider>(context).user1.name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: textColor3)),
                    Text(
                      Provider.of<mainProvider>(context).user1.email,
                      style: TextStyle(color: textColor3.withOpacity(0.5)),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.account_circle,
                  color: iconColor1,
                )),
            Divider(color: dividerColor2, thickness: 1.0, height: 1.0),
            SizedBox(height: 10),
            mylisttitle(title:"تغيير الاسم" , index:1),
            SizedBox(height: 15),
            mylisttitle(title:"تغيير رقم الهاتف" , index:2),
            SizedBox(height: 15),
            mylisttitle(title:"تغيير الايميل", index: 3),
            SizedBox(height: 15),
            mylisttitle(title:"تغيير كلمة السر" , index: 4),
            Divider(color: dividerColor2, thickness: 1.0, height: 1.0),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(value: true, onChanged: null),
                  Text("الاشعارات",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 18,
                          color: textColor3,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  notclick
                      ? Switch(
                          value: isdark,
                          onChanged: (bool v) {
                            setState(() {
                              isdark = v;
                              Provider.of<mainProvider>(context, listen: false)
                                  .switchtheme();
                              notclick = !notclick;
                            });
                          })
                      : FutureBuilder(
                          future:
                              Provider.of<mainProvider>(context, listen: false)
                                  .switchthemedata(),
                          builder: (ctx, v) {
                            notclick = !notclick;
                            if (v.connectionState == ConnectionState.done)
                              return Switch(
                                  value: isdark,
                                  onChanged: (bool v) {
                                    setState(() {
                                      isdark = v;
                                      notclick = !notclick;
                                    });
                                  });
                            return Switch(value: isdark, onChanged: null);
                          }),
                  Text("وضع الدارك",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 18,
                          color: textColor3,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(height: 15),
            ListTile(
                title: Text("الخروج",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 20,
                        color: textColor3,
                        fontWeight: FontWeight.w700)),
                trailing: Icon(
                  Icons.logout,
                  color: iconColor1,
                )),
            Divider(color: dividerColor2, thickness: 1.0, height: 1.0),
            SizedBox(height: 10),
            ListTile(
              trailing: Text(
                "تسجيل خروج",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor3),
              ),
              onTap: () {
                logout1(context);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => register()));
              },
            ),
          ]),
        ));
  }

  Widget mylisttitle({required String title,required int index}){
    return ListTile(
      trailing:Text(title,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor3),
      ),
      leading:Icon(Icons.arrow_back_ios,color: iconColor1),
      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>changedata(index))).then((value) {setState(() {
      });}),
    );
  }

}
