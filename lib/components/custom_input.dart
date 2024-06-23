import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData prefixIcon;
  final TextEditingController controller;

  const CustomInput({
    super.key,
    required this.label,
    required this.isPassword,
    required this.prefixIcon,
    required this.controller,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: _toggleObscureText,
                )
              : null,
        ),
        obscureText: _obscureText,
      ),
    );
  }
}
