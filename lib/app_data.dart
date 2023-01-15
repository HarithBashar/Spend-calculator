import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GDPData {
  GDPData(this.continent, this.gdp);

  final String continent;
  final int gdp;
}

class Spend {
  String title;
  int spend;
  DateTime dateTime;

  Spend({required this.title, required this.dateTime, required this.spend});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'spend': spend,
      'dateTime': {
        'year': dateTime.year,
        'month': dateTime.month,
        'day': dateTime.day,
        'hour': dateTime.hour,
        'minute': dateTime.minute
      }
    };
  }
}

class AppData extends ChangeNotifier {
  List<GDPData> charData = [];
  List<Spend> listOfSpends = [];
  int totalSpend = 0;
  int totalMoneyYouHave = 0;
  List<Color> themeColor = const [
    Color(0xFFCC527A),
    Color(0xFFE6ABBE),
    Color(0xFFE8175D),
    Color(0xFFF388AC),
    Color(0xFFE6ABBE),
  ];

  List<Spend> getListOfSpends() => listOfSpends.reversed.toList();

  void addTotalMoneyYouHave(int number) {
    totalMoneyYouHave = number;
    notifyListeners();
  }

  int moneyYouHave() {
    return totalMoneyYouHave - totalSpend < 0
        ? 0
        : totalMoneyYouHave - totalSpend;
  }

  changeThemeColor(int colorIndex) {
    // heavy 2, heavy 4, heavy 1, heavy 3, heavy 5
    List<List<Color>> themeColors = [
      const [
        Color(0xFFCC527A),
        Color(0xFFE6ABBE),
        Color(0xFFE8175D),
        Color(0xFFF388AC),
        Color(0xFFE6ABBE),
      ],
      const [
        Color(0xFF144272),
        Color(0xFF2C74B3),
        Color(0xFF0A2647),
        Color(0xFF205295),
        Color(0xFF6698C2),
      ],
      const [
        Color(0xFF61876E),
        Color(0xFFEAE7B1),
        Color(0xFF3C6255),
        Color(0xFFA6BB8D),
        Color(0xFFEAE7B1),
      ],
      const [
        Color(0xFF735438),
        Color(0xFFBF9D7E),
        Color(0xFF40301C),
        Color(0xFFA67B56),
        Color(0xFFF2D5BB),
      ],
      const [
        Color(0xFF54B435),
        Color(0xFFF0FF42),
        Color(0xFF379237),
        Color(0xFFA6BB8D),
        Color(0xFF82CD47),
      ],
      const [
        Color(0xFF404040),
        Color(0xFFBFBFBF),
        Color(0xFF0D0D0D),
        Color(0xFF8C8C8C),
        Color(0xFFF2F2F2),
      ],

      const [
        Color(0xFF3F4E4F),
        Color(0xFFD9C794),
        Color(0xFF2C3639),
        Color(0xFFA27B5C),
        Color(0xFFDCD7C9),
      ],
      const [
        Color(0xFF9D3C72),
        Color(0xFFFFBABA),
        Color(0xFF7B2869),
        Color(0xFFC85C8E),
        Color(0xFFFFBABA),
      ],
      const [
        Color(0xFF790252),
        Color(0xFFFFBABA),
        Color(0xFF4C0033),
        Color(0xFFAF0171),
        Color(0xFFE80F88),
      ],
      const [
        Color(0xFF395B64),
        Color(0xFFB9E7DA),
        Color(0xFF2C3333),
        Color(0xFFA5C9CA),
        Color(0xFFE7F6F2),
      ],
      const [
        Color(0xFF474E68),
        Color(0xFF59648F),
        Color(0xFF404258),
        Color(0xFF888EAD),
        Color(0xFFB1B7D2),
      ],
      const [
        Color(0xFFFF78F0),
        Color(0xFF39B5E0),
        Color(0xFFA31ACB),
        Color(0xFFF5EA5A),
        Color(0xFF79C4DE),
      ],
      const [
        Color(0xFF3F72AF),
        Color(0xFFF6D9D9),
        Color(0xFF112D4E),
        Color(0xFFDBE2EF),
        Color(0xFFF9F7F7),
      ],
      const [
        Color(0xFF005C53),
        Color(0xFFDBF227),
        Color(0xFF042940),
        Color(0xFF9FC131),
        Color(0xFFD6D58E),
      ],
      const [
        Color(0xFF00747C),
        Color(0xFF878787),
        Color(0xFF202022),
        Color(0xFF00BBC9),
        Color(0xFFCACACA),
      ],
      const [
        Color(0xFF08403E),
        Color(0xFF962B09),
        Color(0xFF520120),
        Color(0xFF706513),
        Color(0xFFB57114),
      ],
      const [
        Color(0xFF930A96),
        Color(0xFFF2B90C),
        Color(0xFFBF0B3B),
        Color(0xFF238C2A),
        Color(0xFFF27405),
      ],
      const [
        Color(0xFFD9436B),
        Color(0xFFF277A4),
        Color(0xFF8C0327),
        Color(0xFF732240),
        Color(0xFFB3ECF2),
      ],
      const [
        Color(0xFF0597F2),
        Color(0xFF49D907),
        Color(0xFF970FF2),
        Color(0xFFF24607),
        Color(0xFFEAF205),

      ],
    ];
    if (colorIndex != 100) {
      themeColor = themeColors[colorIndex];
      notifyListeners();
    }
    return themeColors;
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [];

    final List<String> tempStringList = [];
    final List<int> tempIntList = [];

    for (int i = 0; i < listOfSpends.length; i++) {
      if (tempStringList.contains(listOfSpends[i].title)) {
        int index = tempStringList.indexOf(listOfSpends[i].title);
        tempIntList[index] += listOfSpends[i].spend;
      } else {
        tempStringList.add(listOfSpends[i].title);
        tempIntList.add(listOfSpends[i].spend);
      }
    }
    for (int i = 0; i < tempStringList.length; i++) {
      chartData.add(GDPData(tempStringList[i], tempIntList[i]));
    }
    return chartData;
  }

  List<GDPData> getMostThreeSpends() {
    List<GDPData> spends = getChartData();
    List<GDPData> mostThreeSpends = [
      GDPData('empty', 0),
      GDPData('empty', 0),
      GDPData('empty', 0),
    ];

    for (int i = 0; i < spends.length; i++) {
      GDPData spend = spends[i];

      if (spend.gdp >= mostThreeSpends[0].gdp) {
        mostThreeSpends[1] = mostThreeSpends[0];
        mostThreeSpends[0] = spend;
      } else if (spend.gdp >= mostThreeSpends[1].gdp) {
        mostThreeSpends[2] = mostThreeSpends[1];
        mostThreeSpends[1] = spend;
      } else if (spend.gdp >= mostThreeSpends[2].gdp) {
        mostThreeSpends[2] = spend;
      } else {}
    }

    return mostThreeSpends;
  }

  void addSpend(Spend spend) {
    listOfSpends.add(spend);
    calculateTotalSpend();
    notifyListeners();
  }

  void editSpend(Spend spend, int index) {
    listOfSpends[(listOfSpends.length - 1) - index] = spend;
    calculateTotalSpend();
    notifyListeners();
  }

  void deleteSpend(int index) {
    listOfSpends.removeAt((listOfSpends.length - 1) - index);
    calculateTotalSpend();
    notifyListeners();
  }

  void calculateTotalSpend() {
    totalSpend = 0;
    for (Spend i in listOfSpends) {
      totalSpend += i.spend;
    }
    notifyListeners();
  }

  void deleteAllData() {
    listOfSpends.clear();
    calculateTotalSpend();
    saveToMemory();
    notifyListeners();
  }

  void saveToMemory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<String> tempList = [];
    for (int i = 0; i < listOfSpends.length; i++) {
      tempList.add(jsonEncode(listOfSpends[i]));
    }
    pref.remove('spendList');
    pref.remove('totalMoneyYouHave');
    pref.setStringList('spendList', tempList);
    pref.setInt('totalMoneyYouHave', totalMoneyYouHave);
  }

  void loadFromMemory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<String> tempList = [];
    if (pref.getStringList('spendList') != null) {
      listOfSpends.clear();
      tempList = pref.getStringList('spendList')!;
      for (int i = 0; i < tempList.length; i++) {
        Map<String, dynamic> temp = jsonDecode(tempList[i]);
        addSpend(
          Spend(
            title: temp['title'],
            spend: temp['spend'],
            dateTime: DateTime(
              temp['dateTime']['year'],
              temp['dateTime']['month'],
              temp['dateTime']['day'],
              temp['dateTime']['hour'],
              temp['dateTime']['minute'],
            ),
          ),
        );
      }
    }
    if (pref.getInt('totalMoneyYouHave') != null) {
      addTotalMoneyYouHave(pref.getInt('totalMoneyYouHave')!);
    }
    notifyListeners();
  }

  int getTodaySpendMoney() {
    String todayDate =
        '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}';
    String spendDate;
    DateTime dateTime;
    int todaySpend = 0;
    for (int i = 0; i < getListOfSpends().length; i++) {
      dateTime = getListOfSpends()[i].dateTime;
      spendDate = '${dateTime.year}/${dateTime.month}/${dateTime.day}';
      if (spendDate == todayDate) {
        todaySpend += getListOfSpends()[i].spend;
      }
    }
    return todaySpend;
  }

  List<Spend> getTodaySpendList() {
    String todayDate =
        '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}';
    String spendDate;
    DateTime dateTime;
    List<Spend> todaySpend = [];
    for (int i = 0; i < getListOfSpends().length; i++) {
      dateTime = getListOfSpends()[i].dateTime;
      spendDate = '${dateTime.year}/${dateTime.month}/${dateTime.day}';
      if (spendDate == todayDate) {
        todaySpend.add(getListOfSpends()[i]);
      }
    }
    return todaySpend;
  }
}
