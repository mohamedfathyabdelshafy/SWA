import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? pref;

  static Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  //this method to save any type data in shared
  static Future<bool> setDataToSharedPref({
    required String key,
    required dynamic value,
  }) async {

    if ( pref == null ) {
      init();
    }
    
    if (value is String)
      return await pref!.setString(key, value); //when data string
    if (value is int) return await pref!.setInt(key, value); //when data integer
    if (value is bool) return await pref!.setBool(key, value); //when data boolean
    if (value is List) {
      return await pref!.setStringList(key, value.map((e) => e.toString()).toList());
    }
    return await pref!.setDouble(key, value);//when data Double
  }

  //get dynamic data from shared
  static dynamic getDataToSharedPref({
    required String key,
  })

  {
    if ( pref == null ) {
      init();
    }
    return pref!.get(key);
  }

  //this to remove from shared by key
  static Future<bool> deleteDataToSharedPref({
    required String key,
  }) {
    return pref!.remove(key);
  }

  static Future<void> clearAllData() async {
    pref!.clear();
  }
}
