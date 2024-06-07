import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(AppLivros());
}

class AppLivros extends StatelessWidget {
  const AppLivros({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaginaInicial(),
    );
  }
}

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({Key? key}) : super(key: key);

  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final TextEditingController _controller = TextEditingController();
  int _quantidadeLivros = 0;

  Future<void> _pesquisarLivros() async {
    final termoPesquisa = _controller.text;
    final url = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': termoPesquisa},
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _quantidadeLivros = jsonResponse['totalItems'];
      });
      print('Número de livros sobre $termoPesquisa: $_quantidadeLivros');
    } else {
      print('Requisição falhou com status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busca de Livros'),
        backgroundColor: Colors.teal, // Cor de fundo da barra de aplicativo
        elevation: 0, // Removendo sombra da barra de aplicativo
      ),
      backgroundColor: Colors.grey[200], // Cor de fundo do Scaffold
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Buscar livros',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pesquisarLivros,
                icon: Icon(Icons.search),
                label: Text('Pesquisar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Cor de fundo do botão
                  elevation: 0, // Removendo sombra do botão
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Foram encontrados $_quantidadeLivros livros sobre "${_controller.text}".',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
