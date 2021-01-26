import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/shoe.dart';
import 'package:shoe/screens/address.dart';
import 'package:shoe/screens/mycart.dart';
import 'package:shoe/screens/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class ShoeDetailsScreen extends StatefulWidget {
  final Product product;
  ShoeDetailsScreen(this.product);
  @override
  _ShoeDetailsScreenState createState() => _ShoeDetailsScreenState();
}

class _ShoeDetailsScreenState extends State<ShoeDetailsScreen> {
  List<int> size = [10, 12, 14, 16, 18, 20, 22];
  int selectedSize = 0;
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
          'ORDER',
          style: TextStyle(color: Colors.black87, letterSpacing: 2),
        ),
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.shoppingBag,
                size: height * 0.030,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyCartScreen()));
              }),
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.userCircle,
                size: height * 0.030,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              }),
        ],
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: height * 0.35,
                  child: Center(
                    child: Image.network(
                      widget.product.image,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Image.network(
                            'https://stockx-assets.imgix.net/media/New-Product-Placeholder-Default.jpg?fit=fill&bg=FFFFFF&w=140&h=100&auto=format,compress&trim=color&q=90&dpr=2&updated_at=0');
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.productHunt,
                    size: height * 0.020,
                  ),
                  title: getText(
                      'Name', Colors.black, height * 0.022, FontWeight.w600),
                  subtitle: getText(widget.product.name, Color(0xff453f3f),
                      height * 0.018, FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.ad,
                    size: height * 0.020,
                  ),
                  title: getText(
                      'Brand', Colors.black, height * 0.022, FontWeight.w600),
                  subtitle: getText(
                      (widget.product.brand == null)
                          ? 'NaN'
                          : widget.product.brand,
                      Color(0xff453f3f),
                      height * 0.018,
                      FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.moneyCheck,
                    size: height * 0.020,
                  ),
                  title: getText(
                      'Price', Colors.black, height * 0.022, FontWeight.w600),
                  subtitle: getText("₹ " + widget.product.price.toString(),
                      Color(0xff453f3f), height * 0.018, FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.typo3,
                    size: height * 0.020,
                  ),
                  title: getText('Category', Colors.black, height * 0.022,
                      FontWeight.w600),
                  subtitle: getText(
                      (widget.product.category == null)
                          ? 'NaN'
                          : widget.product.category,
                      Color(0xff453f3f),
                      height * 0.018,
                      FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.info,
                    size: height * 0.020,
                  ),
                  title: getText(
                      'Type', Colors.black, height * 0.022, FontWeight.w600),
                  subtitle: getText(
                      (widget.product.productType == null)
                          ? 'NaN'
                          : widget.product.productType,
                      Color(0xff453f3f),
                      height * 0.018,
                      FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.link,
                    size: height * 0.020,
                  ),
                  title: getText('Official Link', Colors.black, height * 0.022,
                      FontWeight.w600),
                  subtitle: InkWell(
                    onTap: () async {
                      var url = widget.product.productLink.toString();
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Could not launch URL',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                    child: getText(
                        (widget.product.productLink == null)
                            ? 'NaN'
                            : widget.product.productLink,
                        Colors.blue,
                        height * 0.018,
                        FontWeight.w400),
                  ),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.clipboard,
                    size: height * 0.020,
                  ),
                  title: getText('Description', Colors.black, height * 0.022,
                      FontWeight.w600),
                  subtitle: getText(
                      (widget.product.description == null)
                          ? 'NaN'
                          : widget.product.description,
                      Color(0xff453f3f),
                      height * 0.018,
                      FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Ink(
                height: height * 0.065,
                width: width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    _addToCart();
                  },
                  child: Center(
                      child: Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
              Ink(
                height: height * 0.065,
                width: width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressScreen(
                                <Product>[widget.product],
                                pref.getString('email'))));
                  },
                  child: Center(
                    child: Text(
                      'Buy now',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addToCart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(pref.getString('email'))
          .collection('cart')
          .doc(widget.product.name)
          .set({
        'id': widget.product.id,
        'image': widget.product.image,
        'name': widget.product.name,
        'price': widget.product.price,
        'brand': widget.product.brand,
        'category': widget.product.category,
        'link': widget.product.productLink,
        'type': widget.product.productType,
        'description': widget.product.description,
      });
      Fluttertoast.showToast(
        msg: "Added to Cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Can't Add",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
