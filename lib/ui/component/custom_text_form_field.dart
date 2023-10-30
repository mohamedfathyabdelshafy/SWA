import 'package:flutter/material.dart';
import '../../core/utilts/My_Colors.dart';

class CustomizedField extends StatefulWidget {
  CustomizedField({
    Key? key,
    this.hintText,
    required this.controller,
    required this.validator,
    this.keyboardType,
    this.obsecureText = false,
    this.ispassword = false,
    required this.color,
    this.labelText,
    required this.colorText,
    this.maxLength,
  }) : super(key: key);

  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  bool obsecureText;
  bool ispassword;
  Color color;
  String? labelText;
  Color colorText;
  int? maxLength;

  @override
  State<CustomizedField> createState() => _CustomizedFieldState();
}

class _CustomizedFieldState extends State<CustomizedField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TextFormField(

            maxLength: widget.maxLength,

            controller: widget.controller,
            obscureText: widget.obsecureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: TextStyle(color: widget.colorText, fontSize: 18),
            cursorColor: MyColors.white,

            decoration: InputDecoration(

              suffixIcon: widget.ispassword
                  ? IconButton(
                icon: Icon(
                  widget.obsecureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: MyColors.yellow,
                ),
                onPressed: () {
                  setState(() {
                    widget.obsecureText = !widget.obsecureText;
                  });
                },
              )
                  : null,
              labelText: widget.labelText,
              labelStyle: TextStyle(
                color: MyColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              hintText: widget.hintText,
              errorStyle: TextStyle(color:MyColors.white,fontSize: 10),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: MyColors.white,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
