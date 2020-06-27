class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _color;

  Note(this._title, this._date, this._color, [this._description]);

  Note.withId(this._id, this._title, this._date, this._color,
      [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get color => _color;
  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 100) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 300) {
      this._description = newDescription;
    }
  }

//  set priority(int newPriority) {
//    if (newPriority >= 1 && newPriority <= 3) {
//      this._priority = newPriority;
//    }
//  }

  set color(int newColor) {
    if (newColor >= 0 && newColor <= 9) {
      this._color = newColor;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['color'] = _color;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._color = map['color'];
    this._date = map['date'];
  }
}
