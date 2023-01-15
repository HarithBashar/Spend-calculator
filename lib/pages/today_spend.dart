import 'package:flutter/material.dart';
import 'package:money_spend/app_data.dart';
import 'package:money_spend/constants.dart';
import 'package:provider/provider.dart';

class TodaySpend extends StatelessWidget {
  const TodaySpend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today Spends',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? null : provider.themeColor[2],
        foregroundColor: provider.themeColor[4],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          const SizedBox(height: 15),
          // First container for today spend
          GestureDetector(
            child: Container(
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
                    'Today Spends',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(thickness: 2),
                  Text(
                    numberFormat(
                      provider.getTodaySpendMoney().toString(),
                    ),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // spends of today
          for (int i = 0; i < provider.getTodaySpendList().length; i++)
            Container(
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
                          provider.getTodaySpendList()[i].title,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        numberFormat(
                          provider.getTodaySpendList()[i].spend.toString(),
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
                        dateFormat(provider.getTodaySpendList()[i].dateTime),
                      ),
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
