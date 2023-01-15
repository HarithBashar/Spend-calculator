
// Color titleColor = const Color(0xFFCC527A);
// Color titleColorToWhite = const Color(0xFFE6ABBE);
// Color noteColor  = const Color(0xFFE8175D);
// Color noteColorToWhite  = const Color(0xFFF388AC);

int themeColorInt = 0;
bool isDarkMode = true;

String numberFormat(String number) {
  String formatNumber = '';
  if (number.length > 3) {
    String temp = number.split('').reversed.join('');
    for (int i = 0; i < temp.length; i++) {
      if ((i) % 3 == 0 && i != 0) {
        formatNumber += ',';
      }
      formatNumber += temp[i];
    }
    formatNumber = formatNumber.split('').reversed.join('');
    return formatNumber;
  }
  return number;
}

String dateFormat(DateTime dateTime){
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();
  return "$year/$month/$day     ${dateTime.hour}:${dateTime.minute}";
}