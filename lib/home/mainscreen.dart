import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/home/myaccount.dart';
import 'package:restaurant_almalk_app/home/search.dart';
import 'package:restaurant_almalk_app/home/tender.dart';
import 'package:restaurant_almalk_app/home/allfoods.dart';
import 'package:restaurant_almalk_app/home/home.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/shopping_bag/shopping_bag.dart';
import 'package:shared_preferences/shared_preferences.dart';

int index = 3;

class mianscreen extends StatefulWidget {
  @override
  _mianscreenState createState() => _mianscreenState();
}

class _mianscreenState extends State<mianscreen> {
  List<String> title = ["حسابي", "اكتشف", "العروض", ""];
  List<Widget> pages = [myaccount(), AllFoods(), tender(), myhome()];

  void changescreen(int a) {
    setState(() {
      index = a;
    });
  }

  getuserdata(BuildContext context) async {
    var s=await SharedPreferences.getInstance();
    await Provider.of<mainProvider>(context,listen: false).LoadUserData(s);
    }

  getdata(BuildContext context) async {
    var t=Provider.of<mainProvider>(context).user1.token;
    Provider.of<mainProvider>(context).listproduct = await getproducts(t);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawerScrimColor: backgroundColor1,
        appBar: AppBar(
          foregroundColor: backgroundColor1,
          title: Text(
            title[index],
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: textColor3),
          ),
          /*Container(
            child: Stack(
              children: [
                Row(
                  children: [
                    index != 0
                        ? MaterialButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => search())),
                      child:Padding(
                        padding: EdgeInsets.only(right: w/2),
                        child: Icon(Icons.search, color: iconColor1),
                      ),
                    )
                        : Text(""),
                  ],
                ),
                Positioned(
                  right: w/4,
                  child: Text(
                    title[index],
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: textColor3),
                  ),
                )
              ],
            ),
          ),*/
          leadingWidth: 120,
          leading: Container(
            child: Row(
                children:[
                  IconButton(
                    iconSize: 30,
                    onPressed: null,
                    icon: Container(
                      child: Stack(
                        children: [
                          Positioned(
                            top: -10,
                            left: -10,
                            child: Container(
                              margin: EdgeInsets.only(left: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10) ,
                              ),
                              child: IconButton(onPressed:()=> Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>shopping_bag())
                              ),
                                icon: Icon(Icons.shopping_bag_outlined,color: iconColor1),),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 2 , right: 2),
                              decoration: BoxDecoration(
                                color:buttonColor3 ,
                                borderRadius: BorderRadius.circular(10) ,
                              ),
                              child: Text(Provider.of<mainProvider>(context).count.toString(),style: TextStyle(color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed:() => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>search())),
                      child: Container(child: Icon(Icons.search,color: iconColor1)),
                    ),
                  ),
                ]
            ),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: backgroundColor1.withOpacity(0),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5, top: 5),
              child: IconButton(
                icon: Icon(Icons.menu, color: iconColor1),
                onPressed: () {
                  z.toggle!();
                },
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor1,
        body: Provider.of<mainProvider>(context).user1.token==""
            ? FutureBuilder(
            future: getuserdata(context),
            builder: (context, v) {
              if (v.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Provider.of<mainProvider>(context).listproduct.isEmpty
                  ? FutureBuilder(
                  future: getdata(context),
                  builder: (context, v) {
                    if (v.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return pages[index];
                  }): pages[index];
            }): Provider.of<mainProvider>(context).listproduct.isEmpty
            ? FutureBuilder(
            future: getdata(context),
            builder: (context, v) {
              if (v.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return pages[index];
            }): pages[index],
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: TextStyle(color: textColor3),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: changescreen,
          backgroundColor: backgroundColor1,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: title[index]),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: title[index]),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant), label: title[index]),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "الرئيسية"),
          ],
          iconSize: w / 15,
          selectedItemColor: buttonColor3,
          unselectedItemColor: hintColor1,
        ),
      ),
    );
  }
}
