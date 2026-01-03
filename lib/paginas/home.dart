// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'cadastro.dart';
// import 'detalhes.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
//
// // PRINCIPAL
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// // Gravar a receita
// class Receita {
//   String nome;
//   String ingredientes;
//   String preparo;
//   File? imagem;
//
//   Receita({
//     required this.nome,
//     required this.ingredientes,
//     required this.preparo,
//     this.imagem,
//   });
// }
//
// class _HomePageState extends State<HomePage> {
//   List<Receita> receitas = []; //cria uma lista "receitas"
//
//   void _adicionarReceita() async {
//     // função de nova receita
//     final novaReceita = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => TelaCadastro()),
//     );
//     if (novaReceita != null && novaReceita is Receita) {
//       setState(() {
//         receitas.add(novaReceita);
//       });
//     }
//   }
//
//   void _abrirReceita(Receita receita) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => TelaDetalhes(receita: receita)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: appBar(),
//         backgroundColor: Colors.white,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           onPressed: _adicionarReceita,
//           child: Icon(Icons.add),
//         ),
//         body: receitas.isEmpty
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _searchFilter(),
//                   SizedBox(height: 40),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20),
//                     child: Text(
//                       'Receitas',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Adicione uma nova receita',
//                       style: TextStyle(color: Colors.black.withOpacity(0.4)),
//                     ),
//                   ),
//                 ],
//               )
//             : ListView.builder(
//                 itemCount: receitas.length,
//                 itemBuilder: (context, index) {
//                   final receita = receitas[index];
//                   return Card(
//                     color: Colors.white,
//                     shadowColor: Colors.black,
//                     margin: const EdgeInsets.only(
//                       left: 30,
//                       right: 30,
//                       top: 10,
//                       bottom: 10,
//                     ),
//                     child: ListTile(
//                       trailing: Icon(Icons.arrow_right_sharp, size: 30,),
//                       leading: receita.imagem != null
//                           ? Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.18),
//                                     blurRadius: 10,
//                                   ),
//                                 ],
//                               ),
//                               child: CircleAvatar(
//                                 backgroundImage: FileImage(receita.imagem!),
//                                 radius: 40,
//                               ),
//                             )
//                           : Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.18),
//                                     blurRadius: 10,
//                                   ),
//                                 ],
//                               ),
//                               child: const CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 radius: 40,
//                                 child: Icon(
//                                   Icons.restaurant_menu,
//                                   color: Colors.black,
//                                   size: 30,
//                                 ),
//                               ),
//                             ),
//                       title: Text(
//                         receita.nome,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 19,
//                         ),
//                       ),
//                       subtitle: Text(
//                         receita.ingredientes
//                                 .split(',')
//                                 .first
//                                 .split('\n')
//                                 .first +
//                             '...',
//                         style: TextStyle(color: Colors.grey[600]),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       onTap: () => _abrirReceita(receita),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
//
// Container _searchFilter() {
//   return Container(
//     margin: EdgeInsets.only(top: 40, left: 20, right: 20),
//     decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xff1D1617).withOpacity(0.11),
//           blurRadius: 40,
//           spreadRadius: 0.0,
//         ),
//       ],
//     ),
//     child: TextField(
//       autofocus: false,
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.all(15),
//         filled: true,
//         fillColor: Colors.white,
//         hintText: 'Search Pancake',
//         hintStyle: TextStyle(color: Color(0xffDDDADA), fontSize: 14),
//         prefixIcon: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Icon(Icons.search_rounded),
//         ),
//         suffixIcon: Container(
//           width: 100,
//           child: IntrinsicHeight(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 const VerticalDivider(
//                   color: Colors.black,
//                   indent: 10,
//                   thickness: 0.18,
//                   endIndent: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsetsGeometry.all(8),
//                   child: Icon(Icons.filter_list),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     ),
//   );
// }
//
// AppBar appBar() {
//   return AppBar(
//     title: Text(
//       "Soulmates Recipes",
//       style: TextStyle(
//         color: Colors.black,
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     backgroundColor: Colors.white,
//     elevation: 0,
//     centerTitle: true,
//   );
// }
//
// GestureDetector topButtons(
//   double largura,
//   Color cor,
//   Icon icone,
//   VoidCallback funcao,
// ) {
//   return GestureDetector(
//     onTap: funcao,
//     child: Container(
//       width: largura,
//       margin: EdgeInsets.all(10),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: cor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: icone,
//     ),
//   );
// }
