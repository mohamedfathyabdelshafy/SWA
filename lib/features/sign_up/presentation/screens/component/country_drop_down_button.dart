import 'package:flutter/material.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';

class CountryDropDownTextFieldButton extends StatelessWidget {
  final String hintText;
  final ValueChanged<Country> onSelect;
  final List<Country> countries;

  const CountryDropDownTextFieldButton({
    Key? key,
    required this.hintText,
    required this.onSelect,
    required this.countries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<Country?>(
              // Initial Value
              value: null,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white.withOpacity(0.5),
                size: 30.0,
              ),
              // Array list of items
              items: countries.map((item) {
                return DropdownMenuItem<Country>(
                  value: item,
                  child: Text(
                    item.countryName,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
              hint: Text(
                hintText,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (Country? newValue) {
                if (newValue != null) {
                  onSelect(newValue);
                }
              },
              isExpanded: true,
              underline: const SizedBox(height: 0.0, width: 0.0),
              dropdownColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
