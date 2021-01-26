import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/screens/about.dart';
import 'package:shoe/screens/loading.dart';
import 'package:shoe/screens/my_orders.dart';
import 'package:shoe/screens/mycart.dart';
import 'package:shoe/screens/sign_in.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  String _email = '';
  String _name = '';
  Future _getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _email = pref.getString('email');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_email)
        .get()
        .then((value) {
      _name = value.get('name');
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

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
          'Profile',
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
      ),
      body: loading
          ? LoadingScreen()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.userCheck),
                            title: getText(_name, Colors.black, height * 0.030,
                                FontWeight.w600),
                            subtitle: getText(_email, Colors.black,
                                height * 0.022, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyOrders(_email)));
                      },
                      child: _getListTiles(
                        height,
                        'Your Orders',
                        FaIcon(
                          FontAwesomeIcons.clipboard,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCartScreen()));
                      },
                      child: _getListTiles(
                          height,
                          'Your Cart',
                          FaIcon(
                            FontAwesomeIcons.edit,
                            color: Colors.black87,
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutScreen()));
                      },
                      child: _getListTiles(
                          height,
                          'About',
                          FaIcon(
                            FontAwesomeIcons.info,
                            color: Colors.black87,
                          )),
                    ),
                    InkWell(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.clear();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInUserScreen()),
                            (route) => false);
                      },
                      child: _getListTiles(
                          height,
                          'Logout',
                          FaIcon(
                            FontAwesomeIcons.signOutAlt,
                            color: Colors.black87,
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _getListTiles(double height, String name, FaIcon faIcon) {
    return ListTile(
      leading: faIcon,
      title: getText(name, Colors.black, height * 0.025, FontWeight.w400),
    );
  }
}
