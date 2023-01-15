import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_spend/app_data.dart';
import 'package:money_spend/constants.dart';
import 'package:money_spend/pages/today_spend.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Analysis extends StatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  TextEditingController totalMoneyController = TextEditingController();
  late TooltipBehavior tooltipBehavior;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context, listen: true);
    tooltipBehavior = TooltipBehavior(enable: true);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      children: [
        // money you have
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: provider.themeColor[0],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                provider.themeColor[1],
                provider.themeColor[0],
                provider.themeColor[0],
              ],
            ),
          ),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Money you have:',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(thickness: 2),
              Text(
                numberFormat(
                  provider.moneyYouHave().toString(),
                ),
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Spend money
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: provider.themeColor[0],
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                provider.themeColor[1],
                provider.themeColor[0],
                provider.themeColor[0],
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Spend :   ',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(children: [
                Text(
                  numberFormat(
                    provider.totalSpend.toString(),
                  ),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                    '|  ${(provider.totalSpend / (provider.totalMoneyYouHave <= 0 ? 1 : provider.totalMoneyYouHave) * 100).toStringAsFixed(1)} %')
              ])
            ],
          ),
        ),

        // The Circle chart
        SfCircularChart(
          tooltipBehavior: tooltipBehavior,
          series: <CircularSeries>[
            DoughnutSeries<GDPData, String>(
              dataSource: provider.getChartData(),
              xValueMapper: (GDPData data, _) => data.continent,
              yValueMapper: (GDPData data, _) => data.gdp,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
              ),
            ),
          ],
        ),

        // today you pay
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TodaySpend(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: provider.themeColor[0],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  provider.themeColor[1],
                  provider.themeColor[0],
                  provider.themeColor[0],
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today spend:   ',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  numberFormat(
                    provider.getTodaySpendMoney().toString(),
                  ),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(width: 25),
                // Text(
                //     '|  ${(provider.totalSpend / (provider.totalMoneyYouHave <= 0 ? 1 : provider.totalMoneyYouHave) * 100).toInt()} %')
              ],
            ),
          ),
        ),

        // Most three spends
        Container(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: provider.themeColor[0],
            // borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                provider.themeColor[1],
                provider.themeColor[0],
                provider.themeColor[0],
              ],
            ),
          ),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Most three spends: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${provider.getMostThreeSpends()[0].continent}: ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    numberFormat(
                      provider.getMostThreeSpends()[0].gdp.toString(),
                    ),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${provider.getMostThreeSpends()[1].continent}: ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    numberFormat(
                      provider.getMostThreeSpends()[1].gdp.toString(),
                    ),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${provider.getMostThreeSpends()[2].continent}: ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.0
                      ),

                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    numberFormat(
                      provider.getMostThreeSpends()[2].gdp.toString(),
                    ),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // total money you have
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.55,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: provider.themeColor[0],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Enter total money you have: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      TextField(
                        controller: totalMoneyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(provider.themeColor[0]),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(provider.themeColor[0]),
                            ),
                            onPressed: () {
                              provider.addTotalMoneyYouHave(
                                int.parse(totalMoneyController.text),
                              );
                              provider.saveToMemory();
                              Navigator.pop(context);
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: provider.themeColor[0],
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  provider.themeColor[1],
                  provider.themeColor[0],
                  provider.themeColor[0],
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total money :   ',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  numberFormat(
                    provider.totalMoneyYouHave.toString(),
                  ),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
