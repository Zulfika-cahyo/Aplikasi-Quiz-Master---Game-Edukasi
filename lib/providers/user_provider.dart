import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  String? name;

  bool get hasName => name != null && name!.isNotEmpty;

  Future<void> loadUser() async {
    name = await StorageService.getName();
    notifyListeners();
  }

  Future<void> setName(String newName) async {
    await StorageService.saveName(newName);
    name = newName;
    notifyListeners();
  }
}
