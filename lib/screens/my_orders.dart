import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/shoe.dart';
import 'package:shoe/screens/order_details.dart';
import 'package:shoe/screens/shoe_details.dart';

class MyOrders extends StatefulWidget {
  final String email;
  MyOrders(this.email);
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.email)
            .collection('orders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Text('');
          } else {
            return _getOrderedProductsList(height, width, snapshot);
          }
        },
      ),
    );
  }

  _getOrderedProductsList(
      double height, double width, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Product product = new Product(
              id: snapshot.data.docs[index].get('id'),
              image: snapshot.data.docs[index].get('image'),
              brand: snapshot.data.docs[index].get('brand'),
              name: snapshot.data.docs[index].get('name'),
              price: snapshot.data.docs[index].get('price'),
              category: snapshot.data.docs[index].get('category'),
              productType: snapshot.data.docs[index].get('type'),
              productLink: snapshot.data.docs[index].get('link'),
              description: snapshot.data.docs[index].get('description'),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderDetails(
                        product,
                        snapshot.data.docs[index].get('customername'),
                        snapshot.data.docs[index].get('address'),
                        snapshot.data.docs[index].get('phone'),
                        snapshot.data.docs[index].get('payment'),
                        snapshot.data.docs[index].get('timestamp'))));
          },
          child: Container(
              padding: EdgeInsets.only(
                left: 20,
                top: 40,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data.docs[index].get('name'),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.025,
                                  letterSpacing: 1,
                                ),
                              ),
                              getNoPaddingText(
                                  (snapshot.data.docs[index].get('brand') ==
                                          null)
                                      ? 'NaN'
                                      : snapshot.data.docs[index].get('brand'),
                                  Color(0xff453f3f),
                                  height * 0.018,
                                  FontWeight.w400),
                              getNoPaddingText(
                                  (snapshot.data.docs[index].get('type') ==
                                          null)
                                      ? 'NaN'
                                      : snapshot.data.docs[index].get('type'),
                                  Color(0xff453f3f),
                                  height * 0.018,
                                  FontWeight.w400),
                              getNoPaddingText(
                                  (snapshot.data.docs[index].get('category') ==
                                          null)
                                      ? 'NaN'
                                      : snapshot.data.docs[index]
                                          .get('category'),
                                  Colors.black,
                                  height * 0.018,
                                  FontWeight.w400),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "₹ " +
                                        (snapshot.data.docs[index].get('price'))
                                            .toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: height * 0.022,
                                    ),
                                  ),
                                  getText('Order Details', Colors.black,
                                      height * 0.020, FontWeight.w400)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                snapshot.data.docs[index].get('image'),
                                height: height * 0.080,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Image.network(
                                      'https://stockx-assets.imgix.net/media/New-Product-Placeholder-Default.jpg?fit=fill&bg=FFFFFF&w=140&h=100&auto=format,compress&trim=color&q=90&dpr=2&updated_at=0');
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
