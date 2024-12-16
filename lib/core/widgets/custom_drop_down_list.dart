import 'package:flutter/material.dart';
import 'package:swa/core/utils/app_colors.dart';

class CustomDropDownList extends StatefulWidget {
  final String? hint;
  final List<dynamic>? items;

  const CustomDropDownList({super.key, this.hint, this.items});

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
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButton<String>(
              hint: Text(
                widget.hint!,
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              isExpanded: true,
              iconSize: 20,
              icon: const Icon(Icons.arrow_forward_ios_outlined),
              iconEnabledColor: AppColors.primaryColor,
              iconDisabledColor: AppColors.primaryColor,
              value: selectedValue,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: widget.items?.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: AppColors.blackColor,
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}
