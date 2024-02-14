import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class GlobalTextField extends StatefulWidget {
  GlobalTextField({
    Key? key,
    required this.hintText,
    required this.keyboardType,
    required this.textInputAction,
    this.isPassword = false,
    this.maxLine = 1,
    required this.caption,
    required this.onChanged,
    this.isPhone = false,
    this.readOnly = false,
    this.focusNode,
    this.controller
  }) : super(key: key);

  final String hintText;
  bool isPassword;
  final String caption;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final ValueChanged onChanged;
  final int maxLine;
  final FocusNode? focusNode;
  final bool isPhone;
  final bool readOnly;

  @override
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.caption,style: const TextStyle(color: Color(0xFF232638),fontWeight: FontWeight.w400,fontSize: 12,fontFamily: 'Mulish'),),
          TextField(
            readOnly: widget.readOnly,
            controller: widget.controller,
            cursorColor: const Color(0xFF4F8962),
            maxLines: widget.maxLine,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF949CA9),
                fontFamily: "Mulish"),
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            inputFormatters: widget.isPhone? [
              MaskTextInputFormatter(
                  mask: '(##)-###-##-##',
                  filter: {"#": RegExp(r'[0-9]')},
                  type: MaskAutoCompletionType.lazy)
            ] :[] ,
            focusNode: widget.focusNode,

            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF949CA9),
                  fontFamily: "Mulish"),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFE7ECF3), width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color:  Color(0xFFE7ECF3), width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color:  Color(0xFFE7ECF3), width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              border: OutlineInputBorder(
                borderSide:const  BorderSide(color:  Color(0xFFE7ECF3), width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}