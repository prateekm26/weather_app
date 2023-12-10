import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data_layer/city_model.dart';

class CommonDropDownField extends StatelessWidget {
  CityDataModel cityDataModel = CityDataModel.fromJson(cityJson);
  Cities? selectedValue;
  Function(Cities?)? onChange;

  CommonDropDownField({super.key, this.onChange, this.selectedValue});
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Cities>(
          isExpanded: true,
          alignment: AlignmentDirectional.center,
          iconStyleData: const IconStyleData(
              icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 25,
            color: Colors.white,
          )),
          dropdownStyleData: DropdownStyleData(
              maxHeight: 400,
              elevation: 0,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10))),
          buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 0.5),
                  //color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10))),
          items: cityDataModel.cities!
              .map((Cities item) => DropdownMenuItem<Cities>(
                    alignment: AlignmentDirectional.center,
                    value: item,
                    child: Text(
                      item.name ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          hint: const Text(
            "Select City",
            style: TextStyle(color: Colors.white),
          ),
          onChanged:
              onChange /*(Cities? value) {
            setState(() {
              selectedValue = value;
            });
          }*/
          ),
    );
  }
}
