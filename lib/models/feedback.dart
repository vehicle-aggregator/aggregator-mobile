class Feed{
  int mark;
  int tripId;
  String content;
  String title;

  Feed({this.title, this.content, this.tripId, this.mark});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Content'] = this.content;
    data['Title'] = this.title;
    data['Mark'] = this.mark;
    data['TripID'] = this.tripId;
    return data;
  }
}