// import 'home.dart';
// import 'cadastro.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class TelaDetalhes extends StatelessWidget {
//   final Receita receita;
//
//   const TelaDetalhes({super.key, required this.receita});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           receita.nome,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: topButtons(
//           37.0,
//           Color(0xffF7F8F8),
//           Icon(Icons.close, color: Color(0xffDB402C)),
//               () {
//             FocusScope.of(context).unfocus();
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//           child: Column(
//             children: [
//               if(receita.imagem != null)
//                 SizedBox(
//                   width: double.infinity,
//                   height: 250,
//                   child: Image.file(receita.imagem!, fit: BoxFit.cover,),
//                 )
//               else
//                 Container(
//                   margin: EdgeInsetsGeometry.all(40),
//                   width: double.infinity,
//                   height: 400,
//                   padding: EdgeInsetsGeometry.symmetric(horizontal: 50),
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0xff1D1617).withOpacity(0.11),
//                         blurRadius: 10,
//                       ),
//                     ],
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Stack(
//                     children: [
//                       Align(
//                         alignment: AlignmentGeometry.bottomCenter,
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0),
//                           child: Icon(
//                             shadows: [
//                               BoxShadow(
//                                 color: Color(0xff1D1617).withOpacity(0.15),
//                                 blurRadius: 40,
//                               ),
//                             ],
//                             color: Color(0xff1D1617).withOpacity(0.5),
//                             CupertinoIcons.arrow_up_doc_fill,
//                             size: 50,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//             ],
//           ),
//         ),
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
//
