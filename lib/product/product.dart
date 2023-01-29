import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/category/categories.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';
import 'package:restaurant_almalk_app/home/allfoods.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/shopping_bag/shopping_bag.dart';

class myproduct extends StatefulWidget {
  product p;

  myproduct(product this.p);

  @override
  _myproductState createState() => _myproductState(p);
}

class _myproductState extends State<myproduct> {
  product p;

  _myproductState(product this.p);

  void refresh() {
    setState(() {
      p = p;
    });
  }

  bool notclick = true;
  double w = 0, h = 0;

  @override
  Widget build(BuildContext context) {
    List<product> list = Provider.of<mainProvider>(context)
        .listproduct
        .where((element) =>
            element.categoryid == p.categoryid && element.id != p.id)
        .toList();
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            height: h / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(p.image),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => shopping_bag()))
                      .then((_) => refresh()),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: primaryColor,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -3,
                          left: 0,
                          child: Icon(Icons.shopping_bag_outlined,
                              color: iconColor1, size: 25),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 2, right: 2),
                            decoration: BoxDecoration(
                              color: buttonColor3,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              Provider.of<mainProvider>(context)
                                  .count
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, right: 8, bottom: 8),
                  padding: EdgeInsets.only(bottom: 2, left: 2, top: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: primaryColor,
                  ),
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: iconColor1,
                      )),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () =>
                    Provider.of<mainProvider>(context, listen: false)
                        .addProductCount(p.id),
                child: Container(
                  alignment: Alignment.center,
                  width: w / 5,
                  height: h / 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),
                  child: Text("+",
                      style: TextStyle(
                          color: textColor3,
                          fontWeight: FontWeight.w700,
                          fontSize: 20)),
                ),
              ),
              Text(p.countitem.toString(),
                  style: TextStyle(
                      color: textColor3,
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
              MaterialButton(
                onPressed: () =>
                    Provider.of<mainProvider>(context, listen: false)
                        .subProductCount(p.id),
                child: Container(
                  alignment: Alignment.center,
                  width: w / 5,
                  height: h / 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),
                  child: Text("-",
                      style: TextStyle(
                          color: textColor3,
                          fontWeight: FontWeight.w700,
                          fontSize: 20)),
                ),
              ),
            ],
          ),
          Container(
            height: 5 * h / 9,
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(p.name,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor3)),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              p.rating.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor3),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.star, size: 35, color: iconColor2),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 13),
                        child: p.istrender == false
                            ? Text(
                                p.price.toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor1),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    p.newprice.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textColor1),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    p.price.toString(),
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor: lineThroughColor1,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: hintColor1),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(":" + "عن الوجبة",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textColor3)),
                      SizedBox(height: 5),
                      Text(p.detels,
                          style: TextStyle(fontSize: 16, color: textColor3)),
                      SizedBox(height: 5),
                      p.istrender
                          ? Text(":" + "تفاصيل العرض",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: textColor3))
                          : Text(""),
                      SizedBox(height: 5),
                      p.istrender
                          ? Text("by 7000 6",
                              style: TextStyle(fontSize: 16, color: textColor3))
                          : Text(""),
                      SizedBox(height: 5),
                      p.istrender
                          ? Text(":" + "بداية العرض",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: textColor3))
                          : Text(""),
                      SizedBox(height: 5),
                      p.istrender
                          ? Text("2022/11/13",
                              style: TextStyle(fontSize: 16, color: textColor3))
                          : Text(""),
                      SizedBox(height: 5),
                      p.istrender
                          ? Text(":" + "نهاية العرض",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: textColor3))
                          : Text(""),
                      SizedBox(height: 5),
                      p.istrender
                          ? Text("2022/12/12",
                              style: TextStyle(fontSize: 16, color: textColor3))
                          : Text(""),
                      SizedBox(height: 10),
                    ],
                  ),
                  list.length > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                                onPressed: () => Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            Zoom(mycategory()))),
                                child: Text(
                                  "<" + "عرض المزيد ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: hintColor1),
                                )),
                            Text(
                              ":" + "وجبات مشابهة",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor3),
                            ),
                          ],
                        )
                      : SizedBox(width: 0, height: 0),
                  SizedBox(height: 10),
                  list.length > 0
                      ? Container(
                          width: w,
                          height: h / 4,
                          child: ListView.builder(
                              reverse: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: minicard(list[index]),
                                );
                              }),
                        )
                      : SizedBox(width: 0, height: 0),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: null,
                child: Container(
                  alignment: Alignment.center,
                  width: w / 5,
                  height: h / 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),
                  child: Text("3D show",
                      style: TextStyle(
                          color: iconColor1,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
              ),
              Container(
                width: w / 5,
                height: h / 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                ),
                child: IconButton(
                    onPressed: null,
                    icon: p.countitem > 0
                        ? Icon(Icons.shopping_bag, color: Colors.red, size: 25)
                        : Icon(Icons.shopping_bag_outlined,
                            color: iconColor1, size: 25)),
              ),
              Container(
                width: w / 5,
                height: h / 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                ),
                child: notclick
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            notclick = !notclick;
                          });
                        },
                        icon: p.isfavorite
                            ? Icon(Icons.favorite, color: Colors.red, size: 25)
                            : Icon(Icons.favorite_border,
                                color: iconColor1, size: 25))
                    : FutureBuilder(
                        future:
                            Provider.of<mainProvider>(context, listen: false)
                                .switchfavorite(p.id),
                        builder: (ctx, v) {
                          notclick=!notclick;
                          return Text("");

                        }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget minicard(product p) {
    return Container(
      height: h / 5,
      child: Stack(
        children: [
          MaterialButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => myproduct(p)))
                .then((_) => refresh()),
            height: h / 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: w / 4),
              height: h / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(p.image)),
              ),
              child: Text(""),
            ),
          ),
          Positioned(
            left: 9,
            top: h / 5 - h / 11,
            child: Container(
              width: w / 2,
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
}
