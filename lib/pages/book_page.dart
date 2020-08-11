import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_books/blocs/book_bloc.dart';
import 'package:my_books/models/book.model.dart';
import 'package:my_books/widgets/app_bar.dart';

class BookPage extends StatefulWidget {
  final int id;
  final int evalCurrent;
  BookPage({Key key, @required this.id, @required this.evalCurrent})
      : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  ScrollController _controller;
  final _bookBloc = new BookBloc();
  int id;
  int evalCurrent;
  @override
  Widget build(BuildContext context) {
    return appBar(_body(context), "Livro");
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    id = this.widget.id;
    evalCurrent = this.widget.evalCurrent;
  }

  @override
  void dispose() async {
    super.dispose();
    _bookBloc.dispose();
  }

  Widget _body(BuildContext context) {
    return FutureBuilder(
      future: _bookBloc.generatePgs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AlertDialog(
              title: Text("Erro"),
              content: Center(
                child: Text(
                    "Infelizmente ocorreu um erro ao carregar a lista de livros," +
                        " por favor tente novamente dentro de alguns segundos"),
              ));
        } else if (snapshot.hasData) {
          String text = snapshot.data;
          return _singleChildScrollView(text);
        } else {
          return Center(
            child: CircularProgressIndicator(
              semanticsLabel: "Carregando...",
            ),
          );
        }
      },
    );
  }

  Widget _singleChildScrollView(String text) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          return false;
        } else if (scrollNotification is ScrollUpdateNotification) {
          return false;
        } else if (scrollNotification is ScrollEndNotification) {
          if (_controller.position.pixels ==
              _controller.position.maxScrollExtent) {
            _bookBloc.updateBookStatus(id, "Lido");
          }
          return true;
        }
      },
      child: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            Text(text),
            Divider(),
            Text("Avalie esse livro"),
            Container(
                child: RatingBar(
              initialRating: evalCurrent.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 3,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.blue,
              ),
              onRatingUpdate: (rating) {
                _bookBloc.updateBookEvaluation(id, rating.toInt());
              },
            ))
          ],
        ),
      ),
    );
  }
}
