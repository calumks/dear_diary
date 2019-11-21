import 'dart:convert';

import 'package:dear_diary/models/entry.dart';
import 'package:dear_diary/services/diary_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;

class EntryModel with ChangeNotifier {
  bool _isLoading = false;
  bool _isFetching = false;
  List<Entry> _entries = [];
  String _message;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  String get message => _message;

  List<Entry> get entries => _entries;

  DiaryService diaryService = DiaryService();

  getEntries() async {
    _isFetching = true;
    try {
      Response response = await diaryService.getEntries();
      _isFetching = false;
      var resBody = jsonDecode(response.body);
      if (response.statusCode != 200) {
        _message = resBody['message'];
      } else {
        final List<dynamic> data = resBody['data'] ?? [];
        _entries = List<Entry>.from(data.map((entry) => Entry.fromJson(entry)));
      }
    } catch (e) {
      _isFetching = false;
      _message = "Something went wrong! Try again later.";
    }
    notifyListeners();
  }

  create(Map<String, String> formData) async {
    _isLoading = true;
    notifyListeners();
    Response response = await diaryService.addEntry(formData);
    _isLoading = false;
    notifyListeners();
    var resBody = jsonDecode(response.body);
    if (response.statusCode != 201) {
      _message = resBody['message'];
    }
    return response.statusCode;
  }

  update(Map<String, dynamic> formData) async {
    _isLoading = true;
    notifyListeners();
    Response response = await diaryService.updateEntry(formData);
    _isLoading = false;
    notifyListeners();
    var resBody = jsonDecode(response.body);
    print(resBody['message']);
    debugPrint('${response.statusCode}');
    if (response.statusCode != 200) {
      _message = resBody['message'];
    }
    return response.statusCode;
  }
}