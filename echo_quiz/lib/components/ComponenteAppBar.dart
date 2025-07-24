import 'package:flutter/material.dart';

class ComponenteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final List<Widget>? acoes;

  const ComponenteAppBar({
    super.key,
    required this.titulo,
    this.acoes,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 0,
      actions: acoes,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}