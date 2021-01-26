import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/data.dart';
import 'package:shoe/models/homepage_provider.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/searching_provider.dart';
import 'dart:convert';
import 'package:shoe/screens/mycart.dart';
import 'package:shoe/screens/profile.dart';
import 'package:shoe/screens/search.dart';
import 'package:shoe/screens/shoe_details.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Future<List<Product>> _getShoeDataByType(
      String type, List<Product> list) async {
    if (list.isNotEmpty) return list;
    int i = 0;
    var response = await http.get(
        'https://makeup-api.herokuapp.com/api/v1/products.json?product_type=$type');

    var jsonData = json.decode(response.body);

    for (var json in jsonData) {
      Product product = new Product(
        id: json['id'],
        brand: json['brand'],
        name: json['name'],
        price: (Random().nextInt(1000) + 100),
        image: json['image_link'],
        productLink: json['product_link'],
        description: json['description'],
        category: json['category'],
        productType: json['product_type'],
      );
      list.add(product);
      if (++i >= 50) break;
    }

    return list;
  }

  List<List<Product>> list = [];

  List<String> productTypes = [
    "Blush",
    "Bronzer",
    "Eyebrow",
    "Eyeliner",
    "Eyeshadow",
    "Foundation",
    "Lip liner",
    "Lipstick",
    "Mascara",
    "Nail polish",
  ];
  HomepageProvider homepageProvider;
  @override
  void initState() {
    homepageProvider = Provider.of<HomepageProvider>(context, listen: false);
    list.add(blush);
    list.add(bronzer);
    list.add(eyebrow);
    list.add(eyeliner);
    list.add(eyeshadow);
    list.add(foundation);
    list.add(lipLiner);
    list.add(lipstick);
    list.add(mascara);
    list.add(nailPolish);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getHeader(height, width),
              _getBrandContainer(height),
              Expanded(
                child: Consumer<HomepageProvider>(
                    builder: (context, value, child) {
                  return _getShoeCardContainer(
                      height,
                      width,
                      productTypes[value.selectedIndex],
                      list[value.selectedIndex]);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getBrandContainer(double height) {
    return Container(
      height: height * 0.05,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: productTypes.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Consumer<HomepageProvider>(builder: (context, value, child) {
            return Ink(
              decoration: BoxDecoration(
                color:
                    value.selectedIndex == index ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () {
                  value.updateIndex(index);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Consumer<HomepageProvider>(
                        builder: (context, value, child) {
                      return Text(
                        productTypes[index],
                        style: TextStyle(
                          color: value.selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: height * 0.022,
                          letterSpacing: 1,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  _getFutureBuilder(
      double height, double width, String brand, List<Product> list) {
    return FutureBuilder(
      future: _getShoeDataByType(brand, list),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Container(
              height: height * 0.001,
              width: width * 0.25,
              child: LinearProgressIndicator(),
            ),
          );
        }
        if (snapshot.data == null) {
          return Center(
            child: Text(
              'No results found',
            ),
          );
        } else {
          return GridView.count(
            crossAxisCount: 2,
            physics: BouncingScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            scrollDirection: Axis.vertical,
            childAspectRatio: 0.62,
            children: List.generate(snapshot.data.length, (index) {
              return _getShoeCard(height, width, snapshot.data[index]);
            }),
          );
        }
      },
    );
  }

  _getShoeCardContainer(
      double height, double width, String brand, List<Product> list) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _getFutureBuilder(height, width, brand, list),
          ),
        ],
      ),
    );
  }

  _getShoeCard(double height, double width, Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShoeDetailsScreen(product)));
      },
      child: Container(
        height: height * 0.35,
        width: width * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey)],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Image.network(
                    product.image,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Image.network(
                          'https://stockx-assets.imgix.net/media/New-Product-Placeholder-Default.jpg?fit=fill&bg=FFFFFF&w=140&h=100&auto=format,compress&trim=color&q=90&dpr=2&updated_at=0');
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        product.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: height * 0.020,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    getText((product.brand == null) ? 'Product' : product.brand,
                        Colors.black87, height * 0.017, FontWeight.w500),
                    getText("₹ " + ((product.price).toString()), Colors.black87,
                        height * 0.017, FontWeight.w500),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getHeader(double height, double width) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.only(top: height * 0.013, bottom: height * 0.050),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our',
                style: TextStyle(
                  fontSize: height * 0.035,
                  color: Colors.black87,
                  letterSpacing: 1,
                ),
              ),
              Row(
                children: [
                  IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.shoppingBag,
                        size: height * 0.030,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCartScreen()));
                      }),
                  IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.userCircle,
                        size: height * 0.030,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      }),
                ],
              )
            ],
          ),
          Text(
            'Products',
            style: TextStyle(
              fontSize: height * 0.035,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          SizedBox(
            height: height * 0.016,
          ),
          Center(
            child: Container(
              height: height * 0.070,
              width: width * 0.95,
              decoration: BoxDecoration(
                color: Color(0xFFebe8e8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => Searching(),
                          child: SearchScreen(),
                        ),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search product e.g. Eyeliner',
                        style: TextStyle(
                          fontSize: height * 0.019,
                          letterSpacing: 1,
                        ),
                      ),
                      FaIcon(
                        FontAwesomeIcons.search,
                        size: height * 0.019,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
