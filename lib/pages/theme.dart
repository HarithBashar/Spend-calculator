import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_data.dart';
import '../constants.dart';

class ChoosingThemeColor extends StatefulWidget {
  const ChoosingThemeColor({Key? key}) : super(key: key);

  @override
  State<ChoosingThemeColor> createState() => _ChoosingThemeColorState();
}

class _ChoosingThemeColorState extends State<ChoosingThemeColor> {
  bool isDarkModeForCurrentPageSwitch = true;

  @override
  void initState() {
    isDarkModeForCurrentPageSwitch = isDarkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Themes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode? null: provider.themeColor[2],
        foregroundColor: provider.themeColor[4],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        children: [
          Row(
            children: [
              Text(
                'Choose a Theme: ',
                style: TextStyle(
                    fontSize: 20,
                    color: isDarkMode ? Colors.white : Colors.black),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Light mode / Dark mode: ',
                style: TextStyle(
                    fontSize: 20,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
              Switch(
                value: isDarkModeForCurrentPageSwitch,
                onChanged: (x) async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  setState(() => isDarkModeForCurrentPageSwitch = x);
                  pref.setBool('isDarkMode', isDarkModeForCurrentPageSwitch);
                  if(mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'You should restart the app to apply the changes',
                        style: TextStyle(color: provider.themeColor[1]),
                      ),
                      backgroundColor: provider.themeColor[2],
                    ));
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 15),
          for (int i = 0; i < provider.changeThemeColor(100).length; i++)
            Column(
              children: [
                CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      provider.changeThemeColor(i);
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      pref.setInt('themeColor', i);
                      setState(() => themeColorInt = i);
                      if(mounted) {
                        //Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Theme Has been changed'))
                        );
                      }

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: themeColorInt == i? Border.all(color: Colors.blue, width: 4): null,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          for (int j = 0; j < provider.themeColor.length; j++)
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                    left: j == 0
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                    right: j == provider.themeColor.length - 1
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                  ),
                                  color: provider.changeThemeColor(100)[i][j],
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
                const SizedBox(height: 10),
              ],
            )
        ],
      ),
    );
  }
}
