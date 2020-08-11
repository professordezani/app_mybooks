import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_books/blocs/book_bloc.dart';
import 'package:my_books/models/book.model.dart';
import 'package:my_books/widgets/app_bar.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  BookBloc _bookBloc;
  var _form = GlobalKey<FormState>();

  var _keyTitle = GlobalKey<FormFieldState>();
  var _keyPgs = GlobalKey<FormFieldState>();

  final _ctrTitle = TextEditingController();
  final _ctrPgs = TextEditingController();

  var evaluation = 3;

  @override
  void initState() {
    super.initState();
    _bookBloc = BookBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bookBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return appBar(_body(context), "Adcionar Livro");
  }

  Widget _body(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                _buildInput("Title", _keyTitle, _ctrTitle),
                _buildInput("Quantidade de Páginas", _keyPgs, _ctrPgs),
                Divider(),
                Text("Avalie esse livro"),
                Container(
                    child: RatingBar(
                  initialRating: 3,
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
                    evaluation = rating.toInt();
                  },
                )),
                Divider(
                  height: MediaQuery.of(context).size.height * 0.04,
                  color: Colors.transparent,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      onPressed: () {
                        if (_form.currentState.validate()) {
                          _bookBloc.addBook(BookModel(
                              evaluation: evaluation,
                              pgs: int.parse(_ctrPgs.text),
                              title: _ctrTitle.text,
                              status: "Não lido"));
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue),
                )
              ],
            )));
  }

  _buildInput(String s, GlobalKey<FormFieldState> keyTitle,
      TextEditingController ctrTitle,
      {InputDecoration inputDecoration,
      TextInputAction textInputAction,
      TextInputType keyboardType,
      Function validator}) {
    return TextFormField(
        key: keyTitle,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: inputDecoration ?? InputDecoration(labelText: s),
        controller: ctrTitle,
        validator: _validator);
  }

  String _validator(String value) {
    if (value.isEmpty) {
      return "Campo não pode ser nulo";
    } else {
      return null;
    }
  }
}
