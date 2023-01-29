import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/home/mainscreen.dart';
import 'package:restaurant_almalk_app/home/myaccount.dart';
import 'package:restaurant_almalk_app/home/allfoods.dart';
import 'package:restaurant_almalk_app/category/categories.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';
import 'package:restaurant_almalk_app/models/category.dart';
import 'package:restaurant_almalk_app/product/product.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myhome extends StatefulWidget {
  @override
  _myhomeState createState() => _myhomeState();
}

class _myhomeState extends State<myhome> {
  double w = 0,
      h = 0;

  List<product> list1 = [];
  List<product> listn = [];
  List<product> listp = [];


  getcat(BuildContext context)async{
    var t=Provider.of<mainProvider>(context).user1.token;
    Provider.of<mainProvider>(context).listcategory=await getcategories(t);
  }

   gotofood() {
    index=1;
    return Zoom(mianscreen());}

  @override
  Widget build(BuildContext context) {
    List<String> list = ["images/images1.jpg", "images/images.jpg"];
    w = MediaQuery
        .of(context)
        .size
        .width;
    h = MediaQuery
        .of(context)
        .size
        .height;
    list1 = Provider.of<mainProvider>(context).listproduct.where((element) => element.categoryid != 0 ||
        element.categoryid != 1).toList();
    return ListView(
      children: [
        Padding(
            child: Text("اكتشف اطباقنا الجديدة:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: textColor3),
                textAlign: TextAlign.right),
            padding: EdgeInsets.only(bottom: 10, right: 10)),
        Container(
          color: backgroundColor1.withOpacity(0.1),
          child: CarouselSlider(
            options: CarouselOptions(
              height: h / 4,
              autoPlayCurve: Curves.decelerate,
              autoPlay: true,
            ),
            items: list
                .map((item) =>
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        image: AssetImage(item), fit: BoxFit.cover),
                  ),
                  child: Text(""),
                ))
                .toList(),
          ),
        ),
        Provider.of<mainProvider>(context).listcategory.isEmpty?FutureBuilder(
            future: getcat(context),
            builder:(context,v){
              return parts(categories(context), "الفئات", "كل الفئات");
            }):parts(categories(context), "الفئات", "كل الفئات"),
        SizedBox(height: 10),
        parts(wenew(), "جديدنا", "كل المأكولات"),
        SizedBox(height: 10),
        parts(wepopular(), "رائج لدينا", "كل المأكولات"),
        SizedBox(height: 10),
        parts(maxrating(context), "الاعلى تقييما", "كل المأكولات"),
      ],
    );
  }

  Widget parts(Widget w, String title, String button) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) =>
                          button == "كل الفئات"
                              ? Zoom(mycategory())
                              : gotofood())
                      ),
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: buttonColor3[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "<" + button,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor2),
                      ))),
              Text(
                ":" + title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: textColor3),
              ),
            ],
          ),
          w,
        ],
      ),
    );
  }

  Widget categories(BuildContext context) {
    List<category> listc=Provider.of<mainProvider>(context).listcategory;
    return Container(
      width: w,
      height: h / 9,
      child: ListView.builder(
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: listc.length,
          itemBuilder: (context, index) {
            return  categoryitem(context, listc[listc.length-index-1]);
          }),
    );
  }

  Widget categoryitem(BuildContext context,category c) {
    return Column(
      children: [
        MaterialButton(
          onPressed: () {
            Provider.of<mainProvider>(context,listen: false).categoryselected(c.categoryid);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Zoom(mycategory())));
          },
          child:
          Image(height: w / 9, width: w / 9,fit: BoxFit.fill, image: NetworkImage(c.image)),
        ),
        Text(
          c.name,
          style: TextStyle(color: hintColor1, fontSize: 12),
        ),
      ],
    );
  }

  Widget minicard(product p) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          MaterialButton(
            onPressed: () =>
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => myproduct(p))),
            height: h / 5,
            child: Container(
              width: 4 * w / 9,
              height: h / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image:
                DecorationImage(fit: BoxFit.fill, image: NetworkImage(p.image)),
              ),
              child: Text(""),
            ),
          ),
          Positioned(
            left: 9,
            top: h / 5 - h / 11,
            child: Container(
              width: 4 * w / 9 - 10,
              height: h / 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black38,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      p.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 13),
                    child: p.newprice == 0
                        ? Text(
                      p.price.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.newprice.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellowAccent),
                        ),
                        Text(
                          p.price.toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.rating.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.star, color: Colors.yellowAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int compareDate(product p1, product p2) {
    return p1.insertdate.year > p2.insertdate.year ? -1 : 1;
    return 0;
  }

  Widget wenew() {
    listn = Provider.of<mainProvider>(context).listproduct.where((element) =>
    element.insertdate.year > 2016 && element.categoryid != 0).toList();
    listn.sort(compareDate);
    for (int i = listn.length; i > 4; i--) {
      listn.removeLast();
    };
    return Container(
      width: w,
      height: h / 4,
      child: ListView.builder(
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: listn.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: minicard(listn[index]),
            );
          }),
    );
  }

  Widget wepopular() {
    listp = Provider.of<mainProvider>(context).listproduct.where((element) =>
    element.istrender == true).toList();
    for (int i = listp.length; i > 4; i--) {
      listp.removeLast();
    };
    return Container(
      width: w,
      height: h / 4,
      child: ListView.builder(
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: listp.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: minicard(listp[listp.length-index-1]),
            );
          }),
    );}


  Widget largcard(product p) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              width: w -40,
              height: h / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cardColor2,
                boxShadow:[
                  BoxShadow(offset:Offset(-4, 10),color: shadowColor,blurRadius: 7),
                ] ,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right:w/2+10),
                    child: Text(
                      p.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right:w/2+ 10),
                    child: Text(
                      p.detels,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: hintColor1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right:w/2+ 13),
                    child: p.newprice == 0
                        ? Text(
                      p.price.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor1),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.newprice.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor1),
                        ),
                        Text(
                          p.price.toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: lineThroughColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: hintColor1),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right:w/2+ 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.rating.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor3),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.star, color:iconColor2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: Container(
              child: MaterialButton(
                onPressed: ()=>Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>myproduct(p))),
                height: h / 5,
                child: Container(
                  width: w / 2 - 20,
                  height: h / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image:
                    DecorationImage(fit: BoxFit.fill, image: NetworkImage(p.image)),
                  ),
                  child: Text(""),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int compareRating(product p1, product p2) {
    return p1.rating > p2.rating ? -1 : 1;
    return 0;
  }

  Widget maxrating(BuildContext context) {
    List<product> list = Provider.of<mainProvider>(context).listproduct.where((element) => element.rating >= 4.5)
        .toList();
    list.sort(compareRating);
    for (int i = list.length; i > 4; i--) {
      list.removeLast();
    };
    return Column(
      children: [
        ...list
            .map((e) =>
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: largcard(e),
            ))
            .toList(),
      ],
    );
  }
}
