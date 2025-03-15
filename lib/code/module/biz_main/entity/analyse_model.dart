class WeekOnline {
  String date;
  int count;

  WeekOnline(this.date, this.count);
}

class BrowseTrends {
  String hour;
  int count;

  BrowseTrends(this.hour, this.count);
}

class BrowseMonth {
  String month;
  int count;

  BrowseMonth(this.month, this.count);
}

class AccessSource {
  String type;
  int count;
  int color;

  AccessSource(this.type, this.count, this.color);
}

class AccessTrends {
  String type;
  List<AccessTrendsItem> accessTrendsItemList;
  int color;
  bool selected = false;

  AccessTrends(this.type, this.accessTrendsItemList, this.color);
}

class AccessTrendsItem {
  String label;
  int count;

  AccessTrendsItem(this.label, this.count);
}
