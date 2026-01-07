import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/telaDeAbertura.dart';
import 'supabase_options.dart';

void main() async {
  // Garante que flutter está pronto para rodar códigos assíncronos (internet)
  WidgetsFlutterBinding.ensureInitialized();

  //Conexão com o supabase
  await Supabase.initialize(
    url:
        supabaseUrl, // endereço do meu banco de dados
    anonKey:
        supabaseAnonKey, // chave para abrir a porta do banco
  );

  runApp(const MyApp()); // Inicia o app visualmente
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffec7f13), // Sua cor laranja principal
            // Opcional: Defina um brilho escuro para o tema geral do app
          )
      ),
      title: 'Soulmates Recipes',
      home: const TelaAbertura(),
    );
  }
}
