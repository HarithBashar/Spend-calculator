import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_spend/pages/theme.dart';
import 'package:provider/provider.dart';

import '../app_data.dart';
import '../constants.dart';
import 'about.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode? null: provider.themeColor[2],
        foregroundColor: provider.themeColor[4],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 25),
          ListTile(
            title: const Text('Change theme', style: TextStyle(fontSize: 20),),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < provider.themeColor.length; i++)
                  Container(
                    height: 20,
                    width: 20,
                    color: provider.themeColor[i],
                  )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ChoosingThemeColor(),
                ),
              );
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text('Reset data', style: TextStyle(fontSize: 20),),
            trailing: const Icon(Icons.warning_amber),
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Delete all data',
                      style: TextStyle(
                        fontSize: 30,
                        color: provider.themeColor[0],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: const Text(
                        "Are you sure you want to delete all the spend data?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    provider.themeColor[0]),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    provider.themeColor[0]),
                              ),
                              onPressed: () {
                                provider.deleteAllData();
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            },
          ),
          ListTile(
            title: const Text('About app', style: TextStyle(fontSize: 20),),
            trailing: const Icon(Icons.help_outline),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const About(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
