import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/home/mainscreen.dart';
import 'package:restaurant_almalk_app/product/product.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  double w = 0, h = 0;

  @override
  Widget build(BuildContext context) {
    var searchtext;
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    List<product> list = Provider.of<mainProvider>(context).listsearch;
    List<product> list1 = [], list2 = [];
    for (int i = list.length; i > 0; i--) {
      if (i % 2 != 0)
        list1.add(list[i - 1]);
      else
        list2.add(list[i - 1]);
    }
    ;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios, color: iconColor1)),
        title:TextField(
            controller: searchtext,
            textAlign: TextAlign.end,
            decoration:InputDecoration(
              hintText: "search",
              suffixIcon: Icon(Icons.search, color: iconColor1),),
            onChanged: (s) {
              Provider.of<mainProvider>(context, listen: false).search(s);
            },
          ),
      ),
      body: SingleChildScrollView(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              ...list1
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: minicard(e),
                      ))
                  .toList()
            ],
          ),
          Column(
            children: [
              ...list2
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: minicard(e),
                      ))
                  .toList()
            ],
          ),
        ]),
      ),
    );
  }

  Widget minicard(product p) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          MaterialButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => myproduct(p))),
            height: h / 5,
            child: Container(
              width: 4 * w / 9,
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
}
