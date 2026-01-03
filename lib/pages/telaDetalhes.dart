import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';

class TelaDetalhes extends StatefulWidget {
  // Variável que recebe os dados da receita
  final Map<String, dynamic> receita;
  const TelaDetalhes({super.key, required this.receita});

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

// Função de deletar imagem
Future<void> _deletarImagem(String nomeDoArquivo) async {
  // O metodo remove recebe uma lista de Strings ['caminho1', 'caminho2']
  final List<FileObject> objects = await Supabase.instance.client.storage
      .from('receitas_fotos')
      .remove([nomeDoArquivo]);
}

// Função de deletar receita
Future<void> deletarReceita(int id) async {
  try {
    await Supabase.instance.client.from('notes').delete().eq('id', id);
  } catch (e) {
    print('erro ao deletar: $e');
  }
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  // Apenas a lista de estados dos checkboxes precisa ser uma variável de estado.
  late List<bool> _ingredientesChecados;

  @override
  void initState() {
    super.initState();
    // Primeiro, criamos a lista de ingredientes a partir do widget.
    final linhasIngredientes = widget.receita['ingredientes'].split('\n');
    // Agora, inicializamos a lista de estados dos checkboxes com base nela.
    _ingredientesChecados = List<bool>.filled(linhasIngredientes.length, false);
  }

  @override
  Widget build(BuildContext context) {
    // INICIALIZE AS VARIÁVEIS AQUI:
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final linhasIngredientes = widget.receita['ingredientes'].split('\n');
    return Scaffold(
      backgroundColor: Color(0xff221910),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Imagem da receita
                  Container(
                    color: Color(0xffec7f13).withOpacity(0.2),
                    height: screenHeight * 0.6,
                    width: double.infinity,
                    child: widget.receita['imagem'] != null
                        ? Image.network(
                            widget.receita['imagem'],
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              color: Color(0xffec7f13),
                              size: screenHeight * 0.055,
                            ),
                          ),
                  ),

                  // Fade por cima da imagem
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xff221910).withOpacity(0.7),
                            Color(0xff221910),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.2, 0.7, 5.0],
                        ),
                      ),
                    ),
                  ),

                  // Botão de voltar
                  Positioned(
                    top: screenHeight * 0.05,
                    left: screenHeight * 0.02,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screenHeight * 0.06,
                        width: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadiusGeometry.circular(200),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: screenHeight * 0.03,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Nome da receita + infos
                  Positioned(
                    bottom: screenHeight * 0.02,
                    left: screenHeight * 0.02,
                    right: screenHeight * 0.02,
                    child: Column(
                      // alinhamento à esquerda
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Menor valor vertical possível
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // NOME DA RECEITA
                        Text(
                          widget.receita['nome'],
                          maxLines: 5,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.04,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        Row(
                          children: [
                            // TEMPO
                            _buildInfoWidget(
                              icon: CupertinoIcons.clock_fill,
                              text: widget.receita['tempo'],
                            ),

                            SizedBox(width: screenHeight * 0.02),

                            // // DIFICULDADE
                            _buildInfoWidget(
                              icon: Icons.bar_chart_rounded,
                              text: widget.receita['dificuldade'],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Divider(
                height: screenHeight * 0.001,
                color: Colors.white.withAlpha(20),
                endIndent: screenHeight * 0.02,
                indent: screenHeight * 0.02,
              ),

              // NOME INGREDIENTES E ITENS
              Padding(
                padding: EdgeInsetsGeometry.only(
                  left: screenHeight * 0.02,
                  right: screenHeight * 0.02,
                  top: screenHeight * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ingredientes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                    Text(
                      "${linhasIngredientes.length} itens",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: screenHeight * 0.016,
                      ),
                    ),
                  ],
                ),
              ),

              // LISTA DE INGREDIENTES + CHECKBOX
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: screenHeight * 0.02,
                  vertical: screenHeight * 0.01,
                ),
                child: Container(
                  padding: EdgeInsetsGeometry.all(screenHeight * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadiusGeometry.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 0.8,
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: linhasIngredientes.length,
                    itemBuilder: (context, index) {
                      final ingrediente = linhasIngredientes[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.005,
                        ), // Reduzi um pouco o padding
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Checkbox real e interativo
                                Checkbox(
                                  value: _ingredientesChecados[index],
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _ingredientesChecados[index] = newValue!;
                                    });
                                  },
                                  activeColor: Color(0xffec7f13),
                                  checkColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.7),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.015),
                                // Texto do Ingrediente
                                Flexible(
                                  child: Text(
                                    ingrediente,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: screenHeight * 0.02,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (index < linhasIngredientes.length - 1)
                              Padding(
                                // Adiciona um padding para alinhar com o texto e não com o checkbox
                                padding: EdgeInsets.only(
                                  left: screenWidth * 0.01,
                                  right: screenWidth * 0.01
                                ),
                                child: Divider(
                                  height:
                                      screenHeight * 0.01,
                                  thickness: 0.5,
                                  color: Colors.white.withAlpha(40),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (widget.receita['preparo'].isNotEmpty)
                Padding(
                  padding: EdgeInsetsGeometry.only(
                      left: screenHeight * 0.02
                  ),
                  child: Text(
                    'Modo de Preparo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.025,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                      left: screenHeight * 0.02
                  ),
                  child: Text(
                    widget.receita['preparo'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: screenHeight * 0.018,
                    ),
                  ),
                )



            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoWidget({required IconData icon, required String text}) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenHeight * 0.02,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // Fundo translúcido
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.7),
            size: screenHeight * 0.025,
          ),
          SizedBox(width: screenHeight * 0.01),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: screenHeight * 0.017,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
