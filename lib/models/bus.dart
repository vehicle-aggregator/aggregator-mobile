class Bus {
  List<Line> lines;

  Bus(this.lines);
}

class Line {
  List<Place> places;

  Line({this.places});
}

class Place {
  int number;
  String status;

  Place({this.number, this.status});
}

