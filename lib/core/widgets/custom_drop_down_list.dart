import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/styles.dart';

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
                style: fontStyle(
                    color: AppColors.blackColor,
                    fontSize: 20.sp,
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w500),
              ),
              isExpanded: true,
              iconSize: 20,
              icon: const Icon(Icons.arrow_forward_ios_outlined),
              iconEnabledColor: AppColors.primaryColor,
              iconDisabledColor: AppColors.primaryColor,
              value: selectedValue,
              style: fontStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  height: 1.2,
                  fontFamily: FontFamily.medium),
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
                        style: fontStyle(
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontFamily: FontFamily.regular,
                            fontWeight: FontWeight.w400),
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
