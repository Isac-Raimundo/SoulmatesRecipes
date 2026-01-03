import 'package:fitness/pages/paginaPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:fitness/main.dart';

class TelaAbertura extends StatefulWidget {
  const TelaAbertura({super.key});

  @override
  State<TelaAbertura> createState() => _TelaAberturaState();
}

// 1. Adicione "with SingleTickerProviderStateMixin"
// Isso permite que o State gerencie a animação de forma eficiente.
class _TelaAberturaState extends State<TelaAbertura>
    with SingleTickerProviderStateMixin {
  // 2. Declare os controladores e as animações
  late AnimationController _controller;
  late Animation<double>
  _fadeAnimation; // Para o efeito de aparecer (opacidade)

  @override
  void initState() {
    super.initState();

    // 3. Inicialize o AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duração da animação
    );

    // 4. Configure as animações que vamos usar
    // Animação de Fade (opacidade de 0.0 a 1.0)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // 5. Inicie a animação
    _controller.forward();

    // A lógica de redirecionamento continua a mesma
    _redirecionarParaHome();
  }

  // 6. Não se esqueça de "limpar" o controlador para economizar recursos
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _redirecionarParaHome() async {
    // Aumentei o tempo para dar tempo da animação acontecer e ser apreciada :)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      // Usaremos uma transição suave para a próxima tela também
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const PaginaPrincipal(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff221910),
      body: Center(
        // 7. Envolva sua imagem com os Widgets de Animação
        child: FadeTransition(
          opacity: _fadeAnimation, // Aplica o efeito de fade
          child: FadeTransition(
            opacity: _fadeAnimation, // Aplica o efeito de deslizar
            child: Image.asset(
              'assets/images/definitivo.png',
              width:
              double.infinity, // Adicionar um tamanho pode ajudar no layout
            ),
          ),
        ),
      ),
    );
  }
}