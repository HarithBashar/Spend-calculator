import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_spend/app_data.dart';
import 'package:money_spend/constants.dart';
import 'package:money_spend/pages/add_spend.dart';
import 'package:money_spend/pages/analysis.dart';
import 'package:money_spend/pages/settings.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;
  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context, listen: true);

    if (!isLoaded) {
      Future.delayed(Duration.zero, () {
        provider.changeThemeColor(themeColorInt);
      });
      provider.loadFromMemory();
      isLoaded = true;
    }

    return Scaffold(
      floatingActionButton: pageNumber == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddSpend(isAdd: true),
                  ),
                );
              },
              backgroundColor: provider.themeColor[4],
              foregroundColor: provider.themeColor[2],
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        onTap: (x) {
          setState(() => pageNumber = x);
        },
        icons: const [Icons.home, Icons.analytics_outlined],
        activeIndex: pageNumber,
        backgroundColor:
            isDarkMode ? const Color(0xFF424242) : provider.themeColor[2],
        activeColor: provider.themeColor[4],
        inactiveColor: Colors.white,
        splashColor: provider.themeColor[4],
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.smoothEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        shadow: const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 0.5,
        ),
      ),
      appBar: AppBar(
        title: Text(
          pageNumber == 0 ? 'Home' : 'Analysis',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: provider.themeColor[4],
        centerTitle: true,
        backgroundColor: isDarkMode ? null : provider.themeColor[2],
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: pageNumber == 0 ? const Home() : const Analysis(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context, listen: true);
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 015),
      children: [
        const SizedBox(height: 15),

        // First container for total spend
        Container(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          height: 150,
          decoration: BoxDecoration(
            color: provider.themeColor[0],
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  provider.themeColor[2],
                  provider.themeColor[2],
                  provider.themeColor[1]
                ]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total Spend',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(thickness: 2),
              Text(
                numberFormat(
                  provider.totalSpend.toString(),
                ),
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Spend containers
        for (int i = 0; i < provider.listOfSpends.length; i++)
          GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Delete",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: provider.themeColor[0]),
                  ),
                  content:
                      const Text("Are you sure you want to delete this spend"),
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
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  provider.themeColor[0]),
                            ),
                            onPressed: () {
                              provider.deleteSpend(i);
                              provider.saveToMemory();
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSpend(
                    isAdd: false,
                    index: i,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    provider.themeColor[0],
                    provider.themeColor[0],
                    provider.themeColor[3],
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          provider.getListOfSpends()[i].title,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        numberFormat(
                          provider.getListOfSpends()[i].spend.toString(),
                        ),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat(provider.getListOfSpends()[i].dateTime),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
