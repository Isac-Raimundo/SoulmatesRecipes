import 'dart:io';
import 'dart:math';

import 'package:fitness/pages/telaCadastros.dart';
import 'package:fitness/pages/telaDetalhes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum estadoDaImagemDestaque { carregando, sucesso, erro }

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

// Aqui eu crio um objeto de modelo para as receitas do aplicativo
class modeloReceita {
  // Aqui eu chamo as variaveis que serão usadas no meu objeto.
  String nome;
  String ingredientes;
  Map<String, dynamic> preparo;
  File? imagem; // "?" indica que o valor pode ser nulo.
  String dificuldade;
  String tempo;

  modeloReceita({
    // Construtor: Ele que define as propriedades;
    // Aqui eu especifico quais das propriedades são obrigatórias ou não.
    // required: obriga que seja fornecido este parâmetro.
    // this: atalho do dart.
    required this.nome,
    required this.ingredientes,
    required this.preparo,
    required this.dificuldade,
    required this.tempo,
    this.imagem,
  });
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  String _urlDaImagemDestaque = '';
  estadoDaImagemDestaque _estadoImagemDestaque =
      estadoDaImagemDestaque.carregando;
  Object erro = {};

  late final screenHeight = MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    // Não colocamos a lógica diretamente aqui para manter o código organizado.
    buscarImagemDestaque();
  }

  // FUNÇÃO PARA RECEITA DO DIA
  Future<void> buscarImagemDestaque() async {
    try {
      // o .list() retorna lista de objetos do tipo FileObject
      final List<FileObject> listaBruta = await Supabase.instance.client.storage
          .from('receitas_fotos') // nome do bucket
          .list(); // listar todos os arquivos

      // filtrando a lista para não aparecer o arquivo oculto do bucket
      final List<FileObject> listaImagens = listaBruta
          .where((listaBruta) => listaBruta.name != '.emptyFolderPlaceholder')
          .toList();

      if (listaImagens.isNotEmpty) {
        // sorteio de um item da lista
        final imagemAleatoria =
            listaImagens[Random().nextInt(listaImagens.length)];

        // montando URl com o arquivo sorteado
        final urlPublica = Supabase.instance.client.storage
            .from('receitas_fotos') // nome do bucket
            .getPublicUrl(
              imagemAleatoria.name,
            ); // pegar a imagem da url específica

        // Atualização da tela
        setState(() {
          _urlDaImagemDestaque = urlPublica;
          _estadoImagemDestaque = estadoDaImagemDestaque.sucesso;
        });
      }
    } catch (e) {
      setState(() {
        erro = e;
        _estadoImagemDestaque = estadoDaImagemDestaque.erro;
      });
    }
  }

  // Função de construir erro, mas retorna um widget porque a lógica já está dentro do buscar imagem.
  Widget construirErroDestaque() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons
              .cloud_off_rounded, // Ícone que representa erro de conexão/imagem
          color: Colors.white60,
          size: screenHeight*0.1,
        ),
        SizedBox(height: screenHeight*0.001),
        Text(
          'Falha ao carregar.\nErro: ${erro}',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: screenHeight*0.018),
        ),
        SizedBox(height: screenHeight*0.001),
        // Botão para o usuário tentar novamente
        TextButton(
          style: ButtonStyle(
            // Define a cor do efeito de clique (splash e highlight)
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                // Se o botão estiver sendo pressionado (pressed)
                if (states.contains(MaterialState.pressed)) {
                  // Retorna a sua cor laranja com um pouco de transparência
                  return const Color(0xffec7f13).withOpacity(0.2);
                }
                // Em outros estados (hover, focused), não faz nada
                return null;
              },
            ),
          ),
          onPressed: buscarImagemDestaque, // Chama a função de busca novamente
          child: Text(
            'TENTAR NOVAMENTE',
            style: TextStyle(color: Color(0xffec7f13), fontSize: screenHeight*0.018),
          ),
        ),
      ],
    );
  }



  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xff221910),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xff221910),
      ),
      child: Scaffold(
        backgroundColor: Color(0xff221910), // Cor geral do fundo
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight*0.025, left: screenHeight*0.025, right: screenHeight*0.025),
                    child: Container(
                      // Esse aqui é o bloco da receita do dia, receitadestaque
                      decoration: BoxDecoration(
                        color: Color(0xff221910),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            blurRadius: 40,
                          ),
                        ],
                      ),
                      height: screenHeight * 0.4,
                      width: double.infinity,
                      //Filho do container da receita do dia
                      child: ClipRRect(
                        // cliprrect ajusta as bordas arredondadas com a imagem
                        borderRadius: BorderRadius.circular(25.0),
                        // se a url estiver vazia, constoi a tela contruirErroDestaque
                        // Senão, vai mostrar uma imagem
                        child: _urlDaImagemDestaque.isEmpty
                            ? construirErroDestaque()
                            : Image.network(
                                _urlDaImagemDestaque, // Imagem
                                fit: BoxFit
                                    .cover, // Imagem preeche inteira o container.
                              ),
                      ),
                    ),
                  ),

                  Padding(
                    //Icone do aplicativo
                    padding: EdgeInsetsGeometry.only(left: screenHeight*0.025, top: screenHeight*0.025),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffC16910).withOpacity(0.1),
                                spreadRadius: 0.2,
                                blurRadius: 25,
                              ),
                            ],
                            border: Border.all(
                              color: Color(0xffC16910).withOpacity(0.8),
                              width: 1.5,
                            ),
                            color: Color(0xffC16910).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffec7f13).withOpacity(0.2),
                                  spreadRadius: 0.2,
                                  blurRadius: 25,
                                ),
                              ],
                            ),
                            // margin: EdgeInsetsGeometry.only(right: 20),
                            padding: EdgeInsetsGeometry.only(
                              top: 5,
                              left: 6,
                              right: 3.2,
                              bottom: 5,
                            ),
                            child: Image.asset(
                              'assets/icons/poele.png',
                              color: Color(0xffec7f13),
                              scale: screenHeight*0.016,
                            ),
                          ),
                        ),

                        Text(
                          textAlign: TextAlign.end,
                          '  Receita do dia',
                          style: TextStyle(
                            color: Color(0xffEEF0F7),
                            fontSize: screenHeight*0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    // divisória
                    height: screenHeight*0.03,
                    color: Colors.white.withAlpha(50),
                    endIndent: screenHeight*0.035,
                    indent: screenHeight*0.035,
                  ),
                ],
              ),
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              // Widget que se conecta a uma fonte de dados continua e se reocntrói sozinha
              // A fonte de dados do widget
              stream: Supabase.instance.client
                  .from('notes')
                  .stream(primaryKey: ['id']),
              // É o que será desenhado na tela
              builder: (context, snapshot /*estado atual do streaming*/) {
                if (!snapshot.hasData) {
                  // O uso do SliverFillRemaining garante que o indicador ocupe o espaço disponível na área rolável.
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final dados = snapshot.data!;

                if (dados.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Adicione uma nova receita!')),
                  );
                }
                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(screenHeight*0.025, 0, screenHeight*0.025, screenHeight*0.050),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final receita = dados[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Card(
                              color: Color(0xff221910),
                              // Bordas arredondadas para o Card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenHeight*0.025),
                              ),
                              // Elevação para criar o efeito de sombra (profundidade)
                              elevation: 4,
                              // Usamos ClipRRect para garantir que o conteúdo interno (ListTile)
                              // respeite as bordas arredondadas do Card.
                              clipBehavior:
                                  Clip.antiAlias, // seleção arredondada
                              child: InkWell(
                                // Adicionamos InkWell para manter o efeito de toque (splash)
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TelaDetalhes(receita: receita),
                                    ),
                                  );
                                },
                                child:
                                    // Imagem do card
                                    (receita['imagem'] != null &&
                                        receita['imagem'].isNotEmpty)
                                    ? Image.network(
                                        receita['imagem'],
                                        height: double
                                            .infinity, // Altura fixa para a imagem
                                        width: double
                                            .infinity, // Ocupa toda a largura do card
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        // Placeholder caso não haja imagem
                                        height: double.infinity,
                                        width: double.infinity,
                                        color: Color(
                                          0xffec7f13,
                                        ).withOpacity(0.2),
                                        child: Icon(
                                          Icons.restaurant_menu,
                                          color: Color(0xffec7f13),
                                          size: screenHeight*0.055,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(top: screenHeight*0.002, left: screenHeight*0.0099, right: screenHeight*0.0099),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      receita['nome'],
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenHeight * 0.018,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.only(top: screenHeight*0.007),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.clock_fill,
                                          color: Color(0xffec7f13),
                                            size: screenHeight * 0.023,
                                        ),
                                        SizedBox(width: screenHeight*0.009,),
                                        Text(
                                            receita['tempo'],
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: screenHeight * 0.018
                                          ),
                                        ),
                                        SizedBox(width: screenHeight*0.005),
                                        Icon(Icons.circle, size: screenHeight*0.0085, color: Colors.white.withOpacity(0.7),),
                                        SizedBox(width: screenHeight*0.005),
                                        Text(
                                          receita['dificuldade'],
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: screenHeight * 0.018
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }, childCount: dados.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: screenHeight*0.01,
                      mainAxisSpacing: screenHeight*0.01,
                      childAspectRatio: screenHeight*0.00075,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: screenHeight*0.0650,
          height: screenHeight*0.0650,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaCadastro()),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(200),
              side: BorderSide(color: Color(0xffec7f13), width: 2.0),
            ),
            backgroundColor: Color(0xffec7f13),
            foregroundColor: Colors.white,
            splashColor: Color(0xffec7f13),
            child: Icon(
              Icons.add,
              size: screenHeight*0.0450,
            ),
          ),
        ),
      ),
    );
  }
}
