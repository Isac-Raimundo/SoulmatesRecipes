// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'home.dart';
// import 'detalhes.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class TelaCadastro extends StatefulWidget {
//   const TelaCadastro({super.key});
//
//   @override
//   State<TelaCadastro> createState() => _novaTelaState();
// }
//
// class _novaTelaState extends State<TelaCadastro> {
//   final _nomeController = TextEditingController();
//   final _ingredientesController = TextEditingController();
//   final _preparoController = TextEditingController();
//   File? _imagemSelecionada;
//
//   void _salvarReceita() {
//     if (_nomeController.text.isEmpty) return;
//
//     final novaReceita = Receita(
//       nome: _nomeController.text,
//       ingredientes: _ingredientesController.text,
//       preparo: _preparoController.text,
//       imagem: _imagemSelecionada,
//     );
//     Navigator.pop(context, novaReceita);
//   }
//
//
//   Future<void> salvarReceitaNoSupabase() async {
//     if (_imagemSelecionada == null) return;
//
//     try {
//       // 1. Enviar o ARQUIVO para o Storage (Nuvem)
//       final String nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.png';
//
//       await Supabase.instance.client.storage
//           .from('arquivos') // Nome do Bucket que você criou no Passo 1.2
//           .upload(nomeArquivo, _imagemSelecionada!);
//
//       // 2. Pegar o LINK que o Storage criou
//       final String publicUrl = Supabase.instance.client.storage
//           .from('arquivos')
//           .getPublicUrl(nomeArquivo);
//
//       // 3. Salvar os TEXTOS e o LINK na Tabela
//       await Supabase.instance.client.from('receitas').insert({
//         'nome': _nomeController.text,
//         'ingredientes': _ingredientesController.text,
//         'preparo': _preparoController.text,
//         'imagem_url': publicUrl, // Salvamos o link, não o arquivo
//       });
//
//       print("Sucesso! Sua namorada já pode ver.");
//     } catch (e) {
//       print("Erro ao salvar: $e");
//     }
//   }
//
//   Future<void> _pickImageFromGallery() async {
//     final pickedFIle = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFIle != null) {
//       setState(() {
//         _imagemSelecionada = File(pickedFIle.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           "Nova Receita",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           topButtons(
//             37.0,
//             Color(0xffF7F8F8),
//             Icon(Icons.check, color: Color(0xff00D584)),
//             () {
//               _salvarReceita();
//             },
//           ),
//         ],
//         leading: topButtons(
//           37.0,
//           Color(0xffF7F8F8),
//           Icon(Icons.close, color: Color(0xffDB402C)),
//           () {
//             FocusScope.of(context).unfocus();
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsetsGeometry.all(40),
//                 width: double.infinity,
//                 height: 400,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0xff1D1617).withOpacity(0.11),
//                       blurRadius: 10,
//                     ),
//                   ],
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: _imagemSelecionada != null
//                     ? Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadiusGeometry.circular(20),
//                             child: Image.file(
//                               _imagemSelecionada!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               height: double.infinity,
//                             ),
//                           ),
//                           Align(
//                             alignment: AlignmentGeometry.bottomCenter,
//                             child: IconButton(
//                               onPressed: () {
//                                 _pickImageFromGallery();
//                               },
//                               icon: Icon(
//                                 shadows: [
//                                   BoxShadow(
//                                     color: Color(0xff1D1617).withOpacity(0.4),
//                                     blurRadius: 40,
//                                   ),
//                                 ],
//                                 color: Colors.white,
//                                 CupertinoIcons.checkmark_rectangle_fill,
//                                 size: 50,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Stack(
//                             children: [
//                               Align(
//                                 alignment: AlignmentGeometry.bottomCenter,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 8.0),
//                                   child: IconButton(
//                                     onPressed: () {
//                                       _pickImageFromGallery();
//                                     },
//                                     icon: Icon(
//                                       shadows: [
//                                         BoxShadow(
//                                           color: Color(
//                                             0xff1D1617,
//                                           ).withOpacity(0.15),
//                                           blurRadius: 40,
//                                         ),
//                                       ],
//                                       color: Color(0xff1D1617).withOpacity(0.5),
//                                       CupertinoIcons.arrow_up_doc_fill,
//                                       size: 50,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//               ),
//               infos('Nome da receita', _nomeController),
//               infos('Receita', _ingredientesController),
//               infos('Modo de preparo', _preparoController),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Container infos(String infosNome, TextEditingController infosController) {
//   return Container(
//     width: double.infinity,
//     margin: EdgeInsetsGeometry.only(top: 30, left: 40, right: 40),
//     decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(color: Color(0xff1D1617).withOpacity(0.11), blurRadius: 40),
//       ],
//     ),
//     child: TextField(
//       controller: infosController,
//       minLines: 1,
//       maxLines: null,
//       keyboardType: TextInputType.multiline,
//       decoration: InputDecoration(
//         labelText: infosNome,
//         labelStyle: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Color(0xff1D1617),
//           fontSize: 20,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide.none,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     ),
//   );
// }
