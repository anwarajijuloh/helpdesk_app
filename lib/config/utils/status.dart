
import 'package:flutter/material.dart';
import 'package:helpdesk_app/config/constants.dart';

class MyStatus{
  static getColor(String myStatus){
    switch(myStatus){
      case "Diterima":
        return myblue;
      case "Progress":
        return myorange;
      case "Selesai":
        return mygreen;
      default:
        return grey1;
    }
  }
  static getColorSub(String myStatus){
    switch(myStatus){
      case "Terkirim":
        return myblue;
      case "Ditolak":
        return myorange;
      case "Disetujui":
        return mygreen;
      default:
        return grey1;
    }
  }
  static getIcon(String myStatus){
    switch(myStatus){
      case "Diterima":
        return Icons.open_in_browser;
      case "Progress":
        return Icons.work_history_outlined;
      case "Selesai":
        return Icons.done_all_rounded;
      default:
        return grey1;
    }
  }
}