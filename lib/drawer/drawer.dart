import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/category/aboutus.dart';
import 'package:restaurant_almalk_app/category/categories.dart';
import 'package:restaurant_almalk_app/category/favorite.dart';
import 'package:restaurant_almalk_app/category/request.dart';
import 'package:restaurant_almalk_app/category/setting.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/home/mainscreen.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/register/register.dart';
import 'package:restaurant_almalk_app/shopping_bag/shopping_bag.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

final ZoomDrawerController z = ZoomDrawerController();
class Zoom extends StatefulWidget {
  Widget mscreen;
  Zoom(Widget this.mscreen);
  @override
  _ZoomState createState() => _ZoomState(mscreen);
}

class _ZoomState extends State<Zoom> {
  Widget mscreen;
  _ZoomState(Widget this.mscreen);
  double w=0,h=0;

  logout1(BuildContext context)async{
    await logoutuser(Provider.of<mainProvider>(context).user1.token);
    Provider.of<mainProvider>(context).user1.token="";
    var s=await SharedPreferences.getInstance();
    Provider.of<mainProvider>(context,listen: false).RemoveUserDataUser(s);
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
    return ZoomDrawer(
      controller: z,
      borderRadius: 24,
      style: DrawerStyle.defaultStyle,
      isRtl: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 500),
      // angle: 0.0,
      menuBackgroundColor: primaryColor,
      mainScreen: mscreen,
      menuScreen: Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: Padding(
            padding: EdgeInsets.only(left: 10,top: 10,bottom: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                     ListTile(
                    onTap:null,
                    title: Text(Provider.of<mainProvider>(context).user1.name,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: textColor3)),
                    trailing:Container(
                      width:50,
                      height:50,
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(10000),
                        image:Provider.of<mainProvider>(context).user1.image==""?null:
                        DecorationImage(fit: BoxFit.fill, image: FileImage(new File(Provider.of<mainProvider>(context).user1.image))),
                      ) ,
                     child:Provider.of<mainProvider>(context).user1.image==""?
                         Icon(Icons.account_circle):
                     Text(""),
                    ),
                  ),
                     Column(
                      children: [
                        zoomitem(titel:"الرئيسية" , icon: Icons.home_outlined, nav:  () { index=3 ; Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Zoom(mianscreen())));}),
                        zoomitem(titel:"طلباتي" , icon: Icons.request_page_outlined, nav:  ()=>Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => myrequest()))),
                        zoomitem(titel:"السلة" , icon: Icons.shopping_bag_outlined, nav:()=>Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => shopping_bag()))),
                        zoomitem(titel:"الفئات" , icon: Icons.category_outlined, nav:()=>Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Zoom(mycategory())))),
                        zoomitem(titel:"المفضلة" , icon: Icons.favorite_border, nav:()=> Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Zoom(myfavorite())))),
                        zoomitem(titel:"حسابي" , icon: Icons.account_circle_outlined, nav: () { index=0 ; Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Zoom(mianscreen())));}),
                        zoomitem(titel:"حول مطعمنا" , icon: Icons.info_outline, nav:()=>Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AboutUs()))),
                        zoomitem(titel:"اتصل بنا" , icon: Icons.phone_forwarded_outlined, nav:() async {
                          String num="0987237799";
                          String url="tel:$num";
                          if(await canLaunchUrlString(url))
                            await launchUrlString(url);
                        }),
                        zoomitem(titel:"الاعدادات" , icon: Icons.settings_outlined, nav:()=>Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => mysetting())).then((_) => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Zoom(mscreen))))),
                        zoomitem(titel:"تسجيل خروج" , icon: Icons.logout, nav:(){
                          logout1(context);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>register()));
                        }),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(onPressed: null, icon: Icon(Icons.facebook_outlined,size: w/12,color: iconColor1)),
                      IconButton(onPressed: null, icon: Icon(Icons.telegram_outlined,size: w/12,color: iconColor1)),
                      IconButton(onPressed: null, icon: Icon(Icons.whatsapp_outlined,size: w/12,color: iconColor1,)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget zoomitem({required String titel,required IconData icon,required Function() nav}){
    return Column(
      children:[
      ListTile(
        onTap: nav,
        title: Text(titel,
            textAlign: TextAlign.right,
            style: TextStyle(color: textColor3)),
        trailing: Icon(
          icon,
          color: iconColor1,
        ),
      ),
        SizedBox(
          width: w/3,
          child: Divider(
            color: dividerColor2,
            height: 2,
            thickness: 1,
          ),
        )
      ],
    ) ;
  }
}
