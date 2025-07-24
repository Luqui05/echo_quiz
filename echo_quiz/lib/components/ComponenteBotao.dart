import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComponenteBotao extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final Color? cor;
  final Color? corTexto;
  final IconData? icone;
  final bool carregando;
  final double? largura;

  const ComponenteBotao({
    super.key,
    required this.texto,
    this.onPressed,
    this.cor,
    this.corTexto,
    this.icone,
    this.carregando = false,
    this.largura,
  });

  @override
  Widget build(BuildContext context) {
    Widget botao = ElevatedButton(
      onPressed: carregando ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: cor ?? Colors.deepPurpleAccent,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
      ),
      child: carregando
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icone != null) ...[
                  Icon(icone, color: corTexto ?? Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  texto,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: corTexto ?? Colors.white,
                  ),
                ),
              ],
            ),
    );

    return largura != null
        ? SizedBox(width: largura, child: botao)
        : botao;
  }
}