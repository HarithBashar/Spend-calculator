import 'package:flutter/material.dart';
import 'package:money_spend/constants.dart';
import 'package:money_spend/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  if(pref.getInt('themeColor') != null){
    themeColorInt = pref.getInt('themeColor')! ;
  }
  if(pref.getBool('isDarkMode') != null){
    isDarkMode = pref.getBool('isDarkMode')! ;
  }
  runApp(
    const Main(),
  );
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white, height: 1.2)
          ),
          fontFamily: 'Changa',
          brightness: isDarkMode? Brightness.dark: Brightness.light,
        ),
        home: const HomePage(),
      ),
    );
  }
}
