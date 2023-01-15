import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_data.dart';
import '../constants.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<AppData>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('About', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: isDarkMode? null: provider.themeColor[2],
        foregroundColor: provider.themeColor[4],
      ),

      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * 0.5,),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.175),
                    child: Divider(color: provider.themeColor[2], thickness: 1),
                  ),
                  const SizedBox(height: 20,),
                   Text('This app developed by:', style: TextStyle(fontSize: 20, color: isDarkMode? Colors.white: Colors.black), textAlign: TextAlign.center,),
                  const SizedBox(height: 5,),
                  Text('Harith Bashar', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,  color: isDarkMode? provider.themeColor[1]: provider.themeColor[0]), textAlign: TextAlign.center,),
                  const SizedBox(height: 10,),
                   Text('for contacting on:\nHarithBashar@gmail.com', style: TextStyle(fontSize: 15, color: isDarkMode? Colors.white: Colors.black), textAlign: TextAlign.center,),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.175),
                    child: Divider(color: provider.themeColor[2], thickness: 1),
                  ),
                ],
              ),

            ],
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

