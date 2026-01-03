import 'dart:io';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'paginaPrincipal.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  // Informações que serão inseridas pelo usuário
  final _nomeController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _preparoController = TextEditingController();
  final _tempoPreparoController = TextEditingController();
  File? _imagemSelecionada;

  double _valorDificuldade = 0;
  final List<String> _niveisDificuldade = ['Fácil', 'Médio', 'Difícil'];
  final List<Color> _coresDificuldade = [
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  // Função de pega imagem da galeria
  Future<void> _escolherImagem() async {
    // Dá a opção de pegar a imagem da galeria
    final arquivo = await ImagePicker().pickImage(source: ImageSource.gallery);

    // Se não estiver vazio, atribuo a imagem pegada da galeria na variavel _imagemSelecionada
    if (arquivo != null) {
      setState(() {
        _imagemSelecionada = File(arquivo.path);
      });
    }
  }

  // Função para enviar à base de dados
  Future<void> _enviarParaSupabase() async {
    // Coloquei dentro de outras variáveis para ficar mais fácil de se achar
    final _nomeSupaBase = _nomeController.text;
    final _ingredientesSupaBase = _ingredientesController.text;
    final _preparoSupaBase = _preparoController.text;
    final _dificuldadeSupaBase = _niveisDificuldade[_valorDificuldade.round()];
    final _tempoPreparoSupabase = _tempoPreparoController.text;

    /*
    Só duas coisas são obrigatórias: o nome da receita e os ingredientes.
    Então eu verifico se essas duas possuem informação. Se sim, eu subo
    o nome, ingrediente, modo de preparo e a imagem para o banco de dados.
    Senão, envio tudo, menos a imagem.
    */

    if (_nomeSupaBase.isNotEmpty && _ingredientesSupaBase.isNotEmpty) {
      try {
        // throw Exception('Teste de erro');
        if (_imagemSelecionada != null) {
          // Criando a url da imagem
          final _fotoParaUrl =
              'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
          // Envia o arquivo para o bucket
          await Supabase.instance.client.storage
              .from('receitas_fotos') // nome do bucket
              .upload(
                _fotoParaUrl,
                _imagemSelecionada!,
              ); // nome da imagem e o arquivo
          // Pega o link da foto
          final urlPublica = Supabase.instance.client.storage
              .from('receitas_fotos') // nome do bucket
              .getPublicUrl(_fotoParaUrl); // link da imagem
          // Aqui eu subo tudo para o meu table no SupaBase
          await Supabase.instance.client.from('notes').insert({
            'nome': _nomeSupaBase,
            'ingredientes': _ingredientesSupaBase,
            'preparo': _preparoSupaBase,
            'imagem': urlPublica,
            'dificuldade': _dificuldadeSupaBase,
            'tempo': _tempoPreparoSupabase
          });
        } else {
          // Aqui eu subo algumas infos para o meu table no SupaBase
          await Supabase.instance.client.from('notes').insert({
            'nome': _nomeSupaBase,
            'ingredientes': _ingredientesSupaBase,
            'preparo': _preparoSupaBase,
            'dificuldade': _dificuldadeSupaBase,
            'tempo': _tempoPreparoSupabase
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao enviar: $e',
              style: TextStyle(color: Colors.white),
            ),
            elevation: 4,
            backgroundColor: Color(0xffec7f13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff221910),
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: Color(0xff221910),

        actions: [
          // Botão "cancelar"
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color?>((
                Set<MaterialState> states,
              ) {
                // Se o botão estiver sendo pressionado (pressed)
                if (states.contains(MaterialState.pressed)) {
                  // Retorna a sua cor laranja com um pouco de transparência
                  return Colors.white.withOpacity(0.2);
                }
                // Em outros estados (hover, focused), não faz nada
                return null;
              }),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: screenHeight * 0.018,
              ),
            ),
          ),
        ],

        titleSpacing: screenHeight * 0.02,
        title: Text(
          textAlign: TextAlign.start,
          'Nova Receita',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenHeight * 0.030,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo da imagem
            Padding(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                right: screenHeight * 0.02,
              ),
              child: GestureDetector(
                onTap: _escolherImagem,
                child: ClipRRect(
                  // cortar o conteúdo
                  borderRadius: BorderRadius.circular(11),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      // [tamanho dos traços, espaço entre os traços]
                      dashPattern: [8, 3],
                      // largura dos traços
                      strokeWidth: 2,
                      radius: Radius.circular(11),
                      padding: EdgeInsets.all(0),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Container(
                      height: screenHeight * 0.35,
                      width: double.infinity,
                      color: Colors.deepPurpleAccent.withOpacity(0.04),
                      child: _imagemSelecionada != null
                          ? Image.file(
                              _imagemSelecionada!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Icon(
                              Icons.add_a_photo_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ),

            // Texto nome da receita
            Padding(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                top: screenHeight * 0.03,
              ),
              child: Text(
                'Nome da receita',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            // caixa de texto nome da receita
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenHeight * 0.02,
                screenHeight * 0.01,
                screenHeight * 0.02,
                0,
              ),
              child: TextField(
                minLines: 1,
                maxLines: null,
                controller: _nomeController,
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),

                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  hintText: 'Ex.: Lasanha à bolonhesa',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1D1617),
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Texto ingredientes
            Padding(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                top: screenHeight * 0.03,
              ),
              child: Text(
                'Ingredientes',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            // caixa de texto nome da receita
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenHeight * 0.02,
                screenHeight * 0.01,
                screenHeight * 0.02,
                0,
              ),
              child: TextField(
                minLines: 1,
                maxLines: null,
                controller: _ingredientesController,
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),

                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  hintText: 'Ex.: 1x ovo...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1D1617),
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Texto modo de preparo
            Padding(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                top: screenHeight * 0.03,
              ),
              child: Text(
                'Modo de preparo',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            // caixa de texto modo de preparo
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenHeight * 0.02,
                screenHeight * 0.01,
                screenHeight * 0.02,
                0,
              ),
              child: TextField(
                minLines: 1,
                maxLines: null,
                controller: _preparoController,
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),

                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  hintText: 'Ex.: Em uma panela coloque...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1D1617),
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // INÍCIO DO NOVO WIDGET DE DIFICULDADE
            // Texto "Dificuldade"
            Padding(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                right: screenHeight * 0.02,
                top: screenHeight * 0.03,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os itens no topo
                children: [
                  // COLUNA DA DIFICULDADE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Texto "Dificuldade"
                        Text(
                          'Dificuldade: ${_niveisDificuldade[_valorDificuldade.round()]}',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        // Slider de Dificuldade
                        Slider(
                          value: _valorDificuldade,
                          min: 0,
                          max: 2,
                          divisions: 2,
                          activeColor:
                          _coresDificuldade[_valorDificuldade.round()],
                          inactiveColor: Colors.white.withOpacity(0.3),
                          thumbColor:
                          _coresDificuldade[_valorDificuldade.round()],
                          onChanged: (novoValor) {
                            setState(() {
                              _valorDificuldade = novoValor;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenHeight * 0.02,
                  ), // Espaçamento entre os widgets
                  // COLUNA DO TEMPO DE PREPARO
                  SizedBox(
                    width:
                    screenHeight *
                        0.15, // Define uma largura fixa para o campo
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Texto "Tempo"
                        Text(
                          'Tempo',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ), // Espaço para alinhar com o slider
                        // Caixa de texto do tempo
                        SizedBox(
                          height:
                          screenHeight * 0.05, // Altura para a caixa de texto
                          child: TextField(
                            controller: _tempoPreparoController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.1),
                              filled: true,
                              hintText: 'Ex: 30 min',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                              ),
                              contentPadding:
                              EdgeInsets.zero, // Remove padding interno
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Botão de salvar
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenHeight * 0.02,
                screenHeight * 0.03,
                screenHeight * 0.02,
                screenHeight * 0.02,
              ),
              child: GestureDetector(
                onTap: () {
                  if (_nomeController.text.isEmpty ||
                      _ingredientesController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Adicione o nome da receita e os ingredientes!',
                          style: TextStyle(color: Colors.white),
                        ),
                        elevation: 4,
                        backgroundColor: Color(0xffec7f13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                    _enviarParaSupabase();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffec7f13),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: screenHeight * 0.06,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        size: screenHeight * 0.025,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      Text(
                        '  Salvar Receita',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
