import 'package:flutter/material.dart';

class ComponenteCampoTexto extends StatelessWidget {
  final String rotulo;
  final String? Function(String?)? validador;
  final void Function(String?)? aoSalvar;
  final TextEditingController? controlador;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? tipoTeclado;

  const ComponenteCampoTexto({
    super.key,
    required this.rotulo,
    this.validador,
    this.aoSalvar,
    this.controlador,
    this.obscureText = false,
    this.suffixIcon,
    this.tipoTeclado,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      obscureText: obscureText,
      keyboardType: tipoTeclado,
      decoration: InputDecoration(
        labelText: rotulo,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        suffixIcon: suffixIcon,
      ),
      validator: validador,
      onSaved: aoSalvar,
    );
  }
}



