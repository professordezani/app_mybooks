import 'package:flutter/material.dart';
import 'package:my_books/blocs/book_bloc.dart';
import 'package:my_books/models/book.model.dart';
import 'package:my_books/pages/add_book_page.dart';
import 'package:my_books/pages/book_page.dart';
import 'package:my_books/widgets/alert_dialog.dart';
import 'package:my_books/widgets/app_bar.dart';
import 'package:basic_utils/basic_utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _bookBloc = new BookBloc();
  // final _bookCtrl = StreamController<List<BookModel>>();
  @override
  Widget build(BuildContext context) {
    return appBar(
      _body(context),
      "Meus Livros",
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBookPage()));
          _getBooks();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getBooks();
    //_bookCtrl.add(await _bookBloc.getAll());
  }

  @override
  void dispose() async {
    super.dispose();
    // _bookBloc.
    _bookBloc.dispose();
  }

  _getBooks() {
    _bookBloc.getAll();
  }

  Widget _body(BuildContext context) {
    return StreamBuilder(
      stream: _bookBloc.out,
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
          List<BookModel> books = snapshot.data;
          return _listView(books);
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

  Widget _listView(List<BookModel> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        final book = books[index];
        return Dismissible(
          key: Key(book.id.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            var opcaoUser = await alertDialogPadrao(context, "Confirmação",
                "Deseja realmente excluir esse livro?", Colors.blue[700],
                icone: Icons.warning);
            if (opcaoUser) {
              var resultDelete = await _bookBloc.delete(book.id);
              if (resultDelete) {
                return Future.value(true);
              } else {
                await alertDialogPadrao(context, "Erro",
                    "Erro ao tentar excluir livro", Colors.red[700],
                    ok: true, icone: Icons.error_outline, textButtonOk: "OK");
                return Future.value(false);
              }
            } else {
              return Future.value(false);
            }
          },
          onDismissed: (direction) {
            setState(() {
              books.removeAt(index);
            });
          },
          background: Container(
            color: Colors.red,
            child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "Excluir Livro",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          child: GestureDetector(
            onTap: () async {
              var b = await _bookBloc.getBook(book.id);
              if (b.status == "Não lido") {
                _bookBloc.updateBookStatus(book.id, "Lendo");
              }
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookPage(
                        id: book.id,
                        evalCurrent: book.evaluation,
                      )));
              _getBooks();
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        Icon(_iconEvaluation(book.evaluation),
                            size: 42, color: Colors.blue),
                        VerticalDivider(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              StringUtils.capitalize(book.title),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              book.status,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 8,
                  )
                ]),
          ),
        );
      },
    );
  }

  IconData _iconEvaluation(int evaluation) {
    switch (evaluation) {
      case 1:
        return Icons.star_border;
        break;
      case 2:
        return Icons.star_half;
        break;
      case 3:
        return Icons.star;
        break;
      default:
        return Icons.star_border;
        break;
    }
  }
}
