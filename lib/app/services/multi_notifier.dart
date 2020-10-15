import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;
  ThemeNotifier(this._themeData);
  getTheme() => _themeData;
  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

class FocusNotifier with ChangeNotifier {
  bool _focusModeOn;
  FocusNotifier(this._focusModeOn);
  getFocus() => _focusModeOn;
  setFocus(bool focusModeOn) async {
    _focusModeOn = focusModeOn;
    notifyListeners();
  }
}

class BalanceNotifier with ChangeNotifier {
  bool _focusModeOn;
  BalanceNotifier(this._focusModeOn);
  getBalance() => _focusModeOn;
  setBalance(bool focusModeOn) async {
    _focusModeOn = focusModeOn;
    notifyListeners();
  }
}

class WeekDayNotifier with ChangeNotifier {
  bool _isWeekDay;
  WeekDayNotifier(this._isWeekDay);
  getWeekDay() => _isWeekDay;
  setWeekDay(bool focusModeOn) async {
    _isWeekDay = focusModeOn;
    notifyListeners();
  }
}

class StartHourNotifier with ChangeNotifier {
  int _startHour;
  StartHourNotifier(this._startHour);
  getStartHour() => _startHour;
  setStartHour(int startHour) async {
    _startHour = startHour;
    notifyListeners();
  }
}

class EndHourNotifier with ChangeNotifier {
  int _startHour;
  EndHourNotifier(this._startHour);
  getEndHour() => _startHour;
  setEndHour(int startHour) async {
    _startHour = startHour;
    notifyListeners();
  }
}

class RandomNotifier with ChangeNotifier {
  bool _randomOn;
  RandomNotifier(this._randomOn);
  getRandom() => _randomOn;
  setRandom(bool randomOn) async {
    _randomOn = randomOn;
    notifyListeners();
  }
}

class MetricNotifier with ChangeNotifier {
  bool _metricUnitOn;
  MetricNotifier(this._metricUnitOn);
  getMetric() => _metricUnitOn;
  setMetric(bool focusModeOn) async {
    _metricUnitOn = focusModeOn;
    notifyListeners();
  }
}

class ImageNotifier with ChangeNotifier {
  String _imageUrl;
  ImageNotifier(this._imageUrl);
  getImage() => _imageUrl;
  setImage(String imageUrl) async {
    _imageUrl = imageUrl;
    notifyListeners();
  }
}

class MantraNotifier with ChangeNotifier {
  bool _useMyMantra;
  int _index; //not in use
  MantraNotifier(this._useMyMantra, this._index);
  getMantra() => _useMyMantra;
  getMantraIndex() => _index;
  setMantra(bool useMyMantra) async {
    _useMyMantra = useMyMantra;
    notifyListeners();
  }

  setMantraIndex(int index) async {
    _index = index;
    notifyListeners();
  }
}

class QuoteNotifier with ChangeNotifier {
  bool _quoteOn;
  QuoteNotifier(this._quoteOn);
  getQuote() => _quoteOn;
  setQuote(bool focusModeOn) async {
    _quoteOn = focusModeOn;
    notifyListeners();
  }
}
