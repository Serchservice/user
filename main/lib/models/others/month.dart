class Month{
  String currentMonth;
  String lastMonth;
  String lastTwoMonths;

  Month({
    required this.currentMonth,
    required this.lastMonth,
    required this.lastTwoMonths
  });

  static Month getMonths() {
    var now = DateTime.now();
    int currentMonth = now.month;

    switch (currentMonth) {
      case 1:
        return Month(
          currentMonth: "JAN",
          lastMonth: "DEC",
          lastTwoMonths: "NOV"
        );
      case 2:
        return Month(
          currentMonth: "FEB",
          lastMonth: "JAN",
          lastTwoMonths: "DEC"
        );
      case 3:
        return Month(
          currentMonth: "MAR",
          lastMonth: "FEB",
          lastTwoMonths: "JAN"
        );
      case 4:
        return Month(
          currentMonth: "APR",
          lastMonth: "MAR",
          lastTwoMonths: "FEB"
        );
      case 5:
        return Month(
          currentMonth: "MAY",
          lastMonth: "APR",
          lastTwoMonths: "MAR"
        );
      case 6:
        return Month(
          currentMonth: "JUN",
          lastMonth: "MAY",
          lastTwoMonths: "APR"
        );
      case 7:
        return Month(
          currentMonth: "JUL",
          lastMonth: "JUN",
          lastTwoMonths: "MAY"
        );
      case 8:
        return Month(
          currentMonth: "AUG",
          lastMonth: "JUL",
          lastTwoMonths: "JUN"
        );
      case 9:
        return Month(
          currentMonth: "SEP",
          lastMonth: "AUG",
          lastTwoMonths: "JUL"
        );
      case 10:
        return Month(
          currentMonth: "OCT",
          lastMonth: "SEP",
          lastTwoMonths: "AUG"
        );
      case 11:
        return Month(
          currentMonth: "NOV",
          lastMonth: "OCT",
          lastTwoMonths: "SEP"
        );
      default:
        return Month(
          currentMonth: "DEC",
          lastMonth: "NOV",
          lastTwoMonths: "OCT"
        );
    }
  }

  static String getCurrentMonth() {
    var now = DateTime.now();
    int month = now.month;
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      default:
        return "December";
    }
  }
}