import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swa/core/utilts/My_Colors.dart';
import 'package:swa/core/utilts/styles.dart';

class CustomDropDownList extends StatefulWidget {
  String? hint;
  final List<dynamic>? items;

  CustomDropDownList({super.key, required this.hint,  this.items});

  @override
  State<CustomDropDownList> createState() => _CustomDropDownListState();
}

class _CustomDropDownListState extends State<CustomDropDownList> {
  String selectedValue = 'Select an option'; // Set initial value to the hint

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(

        width: double.infinity,
        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text(
                widget.hint!,
                style: TextStyle(
                  color: MyColors.white,
                ),
              ),
              isExpanded: true,
              iconSize: 20,
              icon: Icon(Icons.arrow_forward_ios_outlined),
              iconEnabledColor: MyColors.primaryColor,
              iconDisabledColor: MyColors.primaryColor,
              value: selectedValue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: widget.items
                  ?.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: TextStyle(
                    color: MyColors.white,
                  ),),
                );
              }).toList()??[],
            ),
          ],
        ),
      ),
    );
  }
}
