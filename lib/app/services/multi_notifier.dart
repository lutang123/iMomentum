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

class RandomNotifier with ChangeNotifier {
//  String _imageUrl;
  bool _randomOn;

  RandomNotifier(this._randomOn);

//  getImage() => _imageUrl;
  getRandom() => _randomOn;

//  setImage(String imageUrl) async {
//    _imageUrl = imageUrl;
//    notifyListeners();
//  }

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
//  bool _randomOn;

  ImageNotifier(this._imageUrl);

  getImage() => _imageUrl;
//  getRandom() => _randomOn;

  setImage(String imageUrl) async {
    _imageUrl = imageUrl;
    notifyListeners();
  }

//  setRandom(bool randomOn) async {
//    _randomOn = randomOn;
//    notifyListeners();
//  }
}

class MantraNotifier with ChangeNotifier {
  bool _useMyMantra;
  int _index;

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

class UserNameNotifier with ChangeNotifier {
  String _imageUrl;

  UserNameNotifier(_imageUrl);

  getUserName() => _imageUrl;

  setUserName(String imageUrl) async {
    _imageUrl = imageUrl;
    notifyListeners();
  }
}
