import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/shoe.dart';
import 'package:shoe/screens/address.dart';
import 'package:shoe/screens/homepage.dart';
import 'package:shoe/screens/loading.dart';
import 'package:shoe/screens/sign_in.dart';

class AddAddressScreen extends StatefulWidget {
  final List<Product> product;
  AddAddressScreen(this.product);
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _roadController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;

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
          'Address Details',
          style: TextStyle(color: Colors.black87, letterSpacing: 2),
        ),
      ),
      key: _scaffoldKey,
      body: loading
          ? LoadingScreen()
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: height,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Enter address details !',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.025,
                                  ),
                                ),
                              ),
                              getTextField(
                                  height, 'Name', _nameController, false),
                              getTextField(
                                  height, 'Phone', _phoneController, false),
                              getTextField(
                                  height, 'Pincode', _pincodeController, false),
                              getTextField(
                                  height, 'City', _cityController, false),
                              getTextField(height, 'House No., Building Name',
                                  _houseController, false),
                              getTextField(height, 'Road name, Area, Colony',
                                  _roadController, false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: _getFloatingActionButton(height, width),
    );
  }

  Widget getTextField(double height, String labelText,
      TextEditingController controller, bool obsecureText) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.015, bottom: height * 0.015),
      height: height * (0.068),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: Colors.black,
          letterSpacing: 2,
        ),
        cursorColor: Colors.black54,
        obscureText: obsecureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.black54,
              width: 2.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: TextStyle(
            color: Colors.black54,
            letterSpacing: 2,
          ),
          labelText: labelText,
        ),
      ),
    );
  }

  bool _validateInformation() {
    if (_nameController.text.trim().length == 0 ||
        _phoneController.text.trim().length == 0 ||
        _pincodeController.text.trim().length == 0 ||
        _cityController.text.trim().length == 0 ||
        _houseController.text.trim().length == 0 ||
        _roadController.text.trim().length == 0) {
      return false;
    }
    return true;
  }

  _storeAddress(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(pref.getString('email'))
          .collection('address')
          .add({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'pincode': _pincodeController.text.trim(),
        'city': _cityController.text.trim(),
        'house': _houseController.text.trim(),
        'road': _roadController.text.trim(),
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddressScreen(widget.product, pref.getString('email'))));
    } catch (FirebaseAuthException) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      Fluttertoast.showToast(
        msg: FirebaseAuthException.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  _getFloatingActionButton(double height, double width) {
    return Ink(
      height: height * 0.065,
      width: width * 0.93,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (_validateInformation()) {
            _storeAddress(context);
          } else {
            Fluttertoast.showToast(
              msg: 'Please enter valid details',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
        child: Center(
          child: Text(
            'Save Address',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
