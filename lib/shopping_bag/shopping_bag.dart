import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/models/bill.dart';
import 'package:restaurant_almalk_app/models/detailbill.dart';
import 'package:restaurant_almalk_app/product/product.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/shopping_bag/mymap.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart';

class shopping_bag extends StatefulWidget {
  @override
  _shopping_bagState createState() => _shopping_bagState();
}

class _shopping_bagState extends State<shopping_bag> {
  double w = 0, h = 0;
  var compname;
  TimeOfDay time = TimeOfDay.now();
  List<product> list1 = [];
  int indexpage = 0;
  int idcompainy = 0;
  bool isinsertdata = false;
  bool status = false;

  bill mybill = bill(
      id: 0,
      status: 0,
      long: 0,
      lat: 0,
      deliverycomid: 0,
      deliveryid: 0,
      address: "",
      regdate: DateTime.now());
  List<detailbill> listdetail = [];

  insertbilldata() {
    if (list1.length > 0) {
      mybill.deliverycomid = idcompainy;
      list1.forEach((element) {
        listdetail.add(detailbill(
            id: 0,
            billid: 0,
            foodid: element.id,
            foodcount: element.countitem));
      });
      mybill.listdetailbill = listdetail;
      setState(() {
        isinsertdata = true;
      });
    }
  }

  sendbill(BuildContext context) async {
    mybill.id =
        await setbill(Provider.of<mainProvider>(context).user1.token, mybill);
  }

  senddetailbill(BuildContext context, detailbill d) async {
    d.billid = mybill.id;
    await setdetailbill(Provider.of<mainProvider>(context).user1.token, d);
  }

  getdeliverycomp(BuildContext context) async {
    var t = Provider.of<mainProvider>(context).user1.token;
    Provider.of<mainProvider>(context).listcompanies =
        await getdeliverycompanies(t);
  }

  changepage(int i) {
    setState(() {
      indexpage = i;
    });
  }

  String gettotalprice() {
    int total = 0;
    list1.forEach((element) {
      total = element.istrender
          ? total + element.countitem * element.newprice
          : total + element.countitem * element.price;
    });
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
   // time.replacing(hour: time.hour + 1);
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    list1 = Provider.of<mainProvider>(context)
        .listproduct
        .where((element) => element.inshpping_bag == true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        shadowColor: shadowColor,
        leading: Text(""),
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
          "سلة التسوق",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: textColor3),
        )),
        backgroundColor: backgroundColor1,
      ),
      backgroundColor: backgroundColor1,
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(bottom: h / 3),
            itemCount: list1.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: largcard(list1[index]),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: indexpage == 0
                ? Container(
                    width: w,
                    height: h / 6,
                    decoration: BoxDecoration(
                        color: backgroundColor3,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25))),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: w / 10, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(gettotalprice(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: textColor1)),
                              Text(":" + "المبلغ الاجمالي",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: textColor2)),
                            ],
                          ),
                        ),
                        mybutton(
                            action: () => changepage(1),
                            title: "الحصول على الطلبية"),
                      ],
                    ),
                  )
                : indexpage == 1
                    ? buyscreen1()
                    : indexpage == 2
                        ? buyscreen2()
                        : indexpage == 3
                            ? buyscreen3()
                            : buyscreen4(),
          ),
        ],
      ),
    );
  }

  Widget largcard(product p) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              width: w - 40,
              height: h / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cardColor1,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(2, -5), color: shadowColor, blurRadius: 7),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: w / 2 + 10),
                    child: Text(
                      p.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w / 2 + 13),
                    child: p.newprice == 0
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
                              Text(
                                p.price.toString(),
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationColor: lineThroughColor1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: hintColor1),
                              ),
                            ],
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w / 2 - 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.rating.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor3),
                        ),
                        Icon(Icons.star, color: iconColor2),
                        MaterialButton(
                          minWidth: w / 15,
                          onPressed: () =>
                              Provider.of<mainProvider>(context, listen: false)
                                  .addProductCount(p.id),
                          child: Container(
                            alignment: Alignment.center,
                            width: w / 15,
                            height: h / 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: buttonColor3,
                            ),
                            child: Text("+",
                                style: TextStyle(
                                    color: textColor2,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18)),
                          ),
                        ),
                        Text(p.countitem.toString(),
                            style: TextStyle(
                                color: textColor3,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        MaterialButton(
                          minWidth: w / 15,
                          onPressed: () =>
                              Provider.of<mainProvider>(context, listen: false)
                                  .subProductCount(p.id),
                          child: Container(
                            alignment: Alignment.center,
                            width: w / 15,
                            height: h / 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: buttonColor3,
                            ),
                            child: Text("-",
                                style: TextStyle(
                                    color: textColor2,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 10,
            child: Container(
              child: MaterialButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => myproduct(p))),
                height: h / 5 - 20,
                child: Container(
                  width: w / 2 - 20,
                  height: h / 5 - 20,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage(p.image)),
                  ),
                  child: Text(""),
                ),
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -10,
            child: Container(
              child: MaterialButton(
                onPressed: () {
                  Provider.of<mainProvider>(context, listen: false)
                      .removeProduct(p.id);
                },
                child: Container(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: buttonColor3),
                      child:
                          Icon(Icons.close, color: iconColor3, size: w / 20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
          width: title.length > 20 ? w - 20 : 3 * w / 4,
          height: h / 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ));
  }

  Widget buyscreen1() {
    return Container(
        width: w,
        height: h / 2,
        decoration: BoxDecoration(
            color: backgroundColor3,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(Icons.check, color: Colors.tealAccent, size: 35),
              SizedBox(
                width: w / 2 - 60,
              ),
              IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => changepage(0)),
            ]),
            Text("شكرا لطلبك",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            mybutton(
                action: () => changepage(2),
                title: "توصيل الطلبية عبر موظفينا"),
            mybutton(
                action: () => changepage(3),
                title: "توصيل الطلبية عبر شركة توصيل خاصة"),
            mybutton(
                action: () => changepage(4),
                title: "القدوم الى مطعمنا والحصول على الطلبية"),
          ],
        ));
  }

  Widget buyscreen2() {
    return Container(
      width: w,
      height: h / 2,
      decoration: BoxDecoration(
          color: backgroundColor3,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: ListView(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              alignment: Alignment.centerRight,
              onPressed: () => changepage(1)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
                onPressed: () => showtimepicker(1),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Text(
                      time.hour.toString() + ":" + time.minute.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                  ),
                )),
            SizedBox(
              width: 30,
            ),
            Text("تحديد وقت الطلبية:",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                        .push(
                            MaterialPageRoute(builder: (_) => mymap()))
                        .then((value) {
                      mybill.lat = value[0];
                      mybill.long = value[1];
                    }),
                icon: Icon(Icons.map)),
            SizedBox(width: 10),
            Text("تحديد موقع الطلبية:",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ]),
          SizedBox(height: 10),
          isinsertdata
              ? FutureBuilder(
                  future: sendbill(context),
                  builder: (context, v) {
                    if (v.connectionState == ConnectionState.waiting)
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          child: CircularProgressIndicator(),
                          width: 3 * w / 4,
                          height: h / 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      );
                    if (v.connectionState == ConnectionState.done) {
                      mybill.listdetailbill.forEach((element) {
                        FutureBuilder(
                            future: senddetailbill(context, element),
                            builder: (context, v) {
                              return Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: CircularProgressIndicator(),
                                  width: 3 * w / 4,
                                  height: h / 18,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              );
                            });
                      });
                    }
                    isinsertdata = false;
                    return mybutton(action: null, title: "");
                  })
              : mybutton(action: insertbilldata, title: "تابع انهاء الطلبية"),
        ],
      ),
    );
  }

  Widget buyscreen3() {
    return Container(
      width: w,
      height: h / 2 + 30,
      decoration: BoxDecoration(
          color: backgroundColor3,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: ListView(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              alignment: Alignment.centerRight,
              onPressed: () => changepage(1)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
                onPressed: () => showtimepicker(2),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Text(
                      time.hour.toString() + ":" + time.minute.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                  ),
                )),
            SizedBox(
              width: 30,
            ),
            Text("تحديد وقت الطلبية:",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                        .push(
                            MaterialPageRoute(builder: (_) => mymap()))
                        .then((value) {
                      mybill.lat = value[0];
                      mybill.long = value[1];
                    }),
                icon: Icon(Icons.map)),
            SizedBox(width: 10),
            Text("تحديد موقع الطلبية:",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Provider.of<mainProvider>(context).listcompanies.isEmpty
                  ? FutureBuilder(
                      future: getdeliverycomp(context),
                      builder: (context, v) {
                        if (v.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return DropdownButton(
                          value: compname,
                          hint: Text("اختر شركة"),
                          items: Provider.of<mainProvider>(context)
                              .listcompanies
                              .map((e) {
                            return DropdownMenuItem<String>(
                                child: Text(e.name), value: e.name);
                          }).toList(),
                          onChanged: (newv) {
                            setState(() {
                              compname = newv.toString();
                            });
                          },
                        );
                      })
                  : DropdownButton(
                      value: compname,
                      hint: Text("اختر شركة"),
                      items: Provider.of<mainProvider>(context)
                          .listcompanies
                          .map((e) {
                        return DropdownMenuItem<String>(
                            child: Text(e.name, style: TextStyle(fontSize: 16)),
                            value: e.name);
                      }).toList(),
                      onChanged: (newv) {
                        setState(() {
                          compname = newv;
                        });
                      },
                    ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Text("تحديد شركة التوصيل:",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ]),
          SizedBox(height: 10),
          isinsertdata
              ? FutureBuilder(
                  future: sendbill(context),
                  builder: (context, v) {
                    if (v.connectionState == ConnectionState.waiting)
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          child: CircularProgressIndicator(),
                          width: 3 * w / 4,
                          height: h / 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      );
                    if (v.connectionState == ConnectionState.done) {
                      mybill.listdetailbill.forEach((element) {
                        FutureBuilder(
                            future: senddetailbill(context, element),
                            builder: (context, v) {
                              return Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: CircularProgressIndicator(),
                                  width: 3 * w / 4,
                                  height: h / 18,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              );
                            });
                      });
                    }
                    isinsertdata = false;
                    return mybutton(action: null, title: "");
                  })
              : mybutton(action: insertbilldata, title: "تابع انهاء الطلبية"),
        ],
      ),
    );
  }

  Widget buyscreen4() {
    return Container(
      width: w,
      height: h / 3,
      decoration: BoxDecoration(
          color: backgroundColor3,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: ListView(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              alignment: Alignment.centerRight,
              onPressed: () => changepage(1)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
                onPressed: () => showtimepicker(3),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Text(
                      time.hour.toString() + ":" + time.minute.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                  ),
                )),
            SizedBox(
              width: 30,
            ),
            Text("تحديد وقت الطلبية:",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ]),
          SizedBox(height: 10),
          isinsertdata
              ? FutureBuilder(
                  future: sendbill(context),
                  builder: (context, v) {
                    if (v.connectionState == ConnectionState.waiting)
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          child: CircularProgressIndicator(),
                          width: 3 * w / 4,
                          height: h / 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      );
                    mybill.listdetailbill.forEach((element) {
                      FutureBuilder(
                          future: senddetailbill(context, element),
                          builder: (context, v) {
                            return Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 20, bottom: 10),
                                child: CircularProgressIndicator(),
                                width: 3 * w / 4,
                                height: h / 18,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            );
                          });
                    });
                    isinsertdata = false;
                    return mybutton(action: null, title: "");
                  })
              : mybutton(action: insertbilldata, title: "تابع انهاء الطلبية"),
        ],
      ),
    );
  }

  void showtimepicker(int i) {
    showTimePicker(
      context: context,
      initialTime: time,
    ).then((value) {
      setState(() {
        time = value != null ? value : time;
      });
    });
  }
}
