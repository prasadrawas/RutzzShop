import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/searching_provider.dart';
import 'package:shoe/models/shoe.dart';
import 'package:shoe/screens/shoe_details.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool searching = true;
  String _query = '';
  List<Product> searchResults = [];
  Searching searchProvider;
  @override
  void initState() {
    searchProvider = Provider.of<Searching>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: _getAppBar(),
        body: _getShoeCardContainer(height, width, _query, searchResults));
  }

  Future<List<Product>> _getShoesResults(
      String query, List<Product> list) async {
    int i = 0;
    searchResults = [];
    var response = await http.get(
        'http://makeup-api.herokuapp.com/api/v1/products.json?product_type=${query.trim()}');

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

  _getFutureBuilder(
      double height, double width, String query, List<Product> list) {
    return Consumer<Searching>(builder: (context, value, child) {
      return FutureBuilder(
        future: _getShoesResults(query, list),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (value.querySubmitted == true &&
              snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Container(
                height: height * 0.001,
                width: width * 0.25,
                child: LinearProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text('No results found'),
              );
            }
            return GridView.count(
              crossAxisCount: 2,
              physics: BouncingScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              scrollDirection: Axis.vertical,
              childAspectRatio: 0.65,
              children: List.generate(snapshot.data.length, (index) {
                return _getShoeCard(height, width, snapshot.data[index]);
              }),
            );
          }
          return Center();
        },
      );
    });
  }

  _getShoeCardContainer(
      double height, double width, String brand, List<Product> list) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
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
                        maxLines: 2,
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

  Widget _getAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: searching
          ? Consumer<Searching>(builder: (context, value, child) {
              return TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onTap: () {
                  value.updateVarFalse();
                },
                onFieldSubmitted: (String s) {
                  _query = s;
                  FocusScope.of(context).unfocus();
                  value.updateVarTrue();
                },
                autofocus: true,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                  border: InputBorder.none,
                ),
              );
            })
          : Text(
              'Search',
              style: TextStyle(letterSpacing: 1, color: Colors.black),
            ),
      actions: [
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.times,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            _controller.clear();
          },
        ),
      ],
    );
  }
}
