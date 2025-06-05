import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

Widget iconBack (BuildContext context){
  return  InkWell(
    onTap: (){
      Navigator.pop(context);
    },
    child: Icon(
      Icons.arrow_back,
      color: AppColors.primaryColor,
      size: 34,
    ),
  );
}
