import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/styles.dart';

class CustomizedField extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  bool obscureText;
  final bool isPassword;
  final bool readonly;

  final Color color;
  final String? labelText;
  final Color colorText;
  final Color? bordercolor;
  final Color? labelcolor;
  Widget? prefixIcon;
  double? borderradias;
  final int? maxLength;
  final bool? expanded;

  final ontap;

  final onchange;

  CustomizedField({
    Key? key,
    this.hintText,
    this.onchange,
    this.borderradias,
    this.ontap,
    this.labelcolor,
    this.expanded,
    required this.controller,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.readonly = false,
    this.isPassword = false,
    required this.color,
    this.labelText,
    this.prefixIcon,
    required this.colorText,
    this.maxLength,
    this.bordercolor,
  }) : super(key: key);

  @override
  State<CustomizedField> createState() => _CustomizedFieldState();
}

class _CustomizedFieldState extends State<CustomizedField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderradias ?? 0)),
          ),
          child: TextFormField(
            maxLength: widget.maxLength,
            readOnly: widget.readonly,
            expands: widget.expanded ?? false,
            onChanged: (v) {
              widget.onchange == null ? () {} : widget.onchange(v);
            },

            onTap: widget.ontap ?? () {}, // and this

            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,

            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,

            style: fontStyle(
                color: widget.colorText,
                fontSize: 18.sp,
                fontFamily: FontFamily.medium,
                fontWeight: FontWeight.w500),
            cursorColor: Color(0xffA2A2A2),
            decoration: InputDecoration(
              fillColor: widget.color,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderradias ?? 0),
                  borderSide: BorderSide(
                      color: widget.bordercolor ?? Colors.white, width: 0)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderradias ?? 0),
                  borderSide: BorderSide(color: Colors.white, width: 0)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderradias ?? 0),
                  borderSide: BorderSide(color: Colors.white, width: 0)),
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        widget.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xff898989),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                    )
                  : null,
              labelText: widget.labelText,
              labelStyle: fontStyle(
                color: widget.labelcolor ?? AppColors.blackColor,
                fontSize: 16,
                fontFamily: FontFamily.bold,
              ),
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              errorStyle: fontStyle(
                  fontSize: 10.sp,
                  fontFamily: FontFamily.regular,
                  fontWeight: FontWeight.w500,
                  color: Colors.red),
              hintStyle: fontStyle(
                color: Color(0xffA2A2A2),
                fontFamily: FontFamily.medium,
                height: 1.2,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
