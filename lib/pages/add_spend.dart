import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_spend/app_data.dart';
import 'package:money_spend/constants.dart';
import 'package:provider/provider.dart';

class AddSpend extends StatefulWidget {
  final bool isAdd;
  final int? index;

  const AddSpend({Key? key, required this.isAdd, this.index}) : super(key: key);

  @override
  State<AddSpend> createState() => _AddSpendState();
}

class _AddSpendState extends State<AddSpend> {
  TextEditingController titleController = TextEditingController();

  bool isLoaded = false;
  int spend = 0;
  List<int> spendButtons = [250, 500, 1000, 5000, 10000, 25000, 50000, 100000];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context, listen: true);
    if (spend <= 0) {
      spend = 0;
    }
    if (!widget.isAdd && !isLoaded) {
      titleController.text = provider.getListOfSpends()[widget.index!].title;
      spend = provider.getListOfSpends()[widget.index!].spend;
      isLoaded = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isAdd ? 'Add Spend' : 'Edit Spend',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode? null: provider.themeColor[2],
        foregroundColor: provider.themeColor[4],
        centerTitle: true,
        actions: !widget.isAdd
            ? [
                IconButton(
                  onPressed: () {
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
                        content: const Text(
                            "Are you sure you want to delete this spend"),
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
                                    provider.deleteSpend(widget.index!);
                                    provider.saveToMemory();
                                    Navigator.pop(context);
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
                  icon: const Icon(Icons.delete_outline),
                ),
              ]
            : [],
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              const SizedBox(height: 15),
              // spend title
              Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: provider.themeColor[0], width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    controller: titleController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Spend Title',
                      prefixIcon: Icon(
                        Icons.title,
                        color: provider.themeColor[0],
                        size: 30,
                      ),
                      counter: null,
                      counterText: '',
                    ),
                    maxLength: 50,
                  ),
                ),
              ),
              // spend amount
              Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.all(20),
                height: 135,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: provider.themeColor[0].withOpacity(0.9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Spend amount',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          numberFormat(spend.toString()),
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        spend > 0
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    spend = 0;
                                  });
                                },
                                icon: const Icon(Icons.highlight_remove))
                            : const Text(''),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // value buttons
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    for (int i = 0; i < spendButtons.length; i++)
                      ValueButton(
                        spendAmount: numberFormat(spendButtons[i].toString()),
                        onTap: () {
                          setState(() {
                            spend += spendButtons[i];
                          });
                        },
                        onDoubleTap: () {
                          setState(() {
                            spend -= spendButtons[i];
                          });
                        },
                      ),
                  ],
                ),
              )
            ],
          ),
          // add spend / edit spend
          Column(
            children: [
              const Expanded(
                child: SizedBox(),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                child: Container(
                    height: 80,
                    color: spend > 0 ? Colors.green : Colors.grey,
                    child: Center(
                      child: Text(widget.isAdd ? 'Add Spend' : 'Edit Spend',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    )),
                onPressed: () {
                  if (spend > 0) {
                    Spend newSpend = Spend(
                      title: titleController.text,
                      spend: spend,
                      dateTime: widget.isAdd
                          ? DateTime.now()
                          : provider.getListOfSpends()[widget.index!].dateTime,
                    );
                    if (widget.isAdd) {
                      provider.addSpend(newSpend);
                    } else {
                      provider.editSpend(newSpend, widget.index!);
                    }
                    provider.saveToMemory();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ValueButton extends StatelessWidget {
  final String spendAmount;
  final Function onTap;
  final Function onDoubleTap;

  const ValueButton(
      {Key? key,
      required this.onTap,
      required this.spendAmount,
      required this.onDoubleTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: provider.themeColor[0]),
          ),
          child: Center(
            child: Text(
              spendAmount,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * .06,
                color: provider.themeColor[1],
              ),
            ),
          ),
        ),
        onTap: () {
          onTap();
        },
        onLongPress: () {
          onDoubleTap();
        },
      ),
    );
  }
}
