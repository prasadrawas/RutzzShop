import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoe/custom_widgets.dart';

class AboutScreen extends StatelessWidget {
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
          'About',
          style: TextStyle(letterSpacing: 1, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: FaIcon(FontAwesomeIcons.mobile),
                title: getText('App Version', Colors.black, height * 0.025,
                    FontWeight.w600),
                subtitle: getText(
                    '1.0.0', Colors.black, height * 0.020, FontWeight.w400),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.dev),
                title: getText('App Developer', Colors.black, height * 0.025,
                    FontWeight.w600),
                subtitle: getText('Prasad Rawas', Colors.black, height * 0.020,
                    FontWeight.w400),
              )
            ],
          ),
        ),
      ),
    );
  }
}
