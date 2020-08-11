class BookModel {
  int id;
  String title;
  String status;
  int pgs;
  int evaluation;

  BookModel({this.id, this.title, this.status, this.pgs, this.evaluation});

  BookModel.fromMap(Map<String, dynamic> ma) {
    id = ma['id'];
    title = ma['title'];
    status = ma['status'];
    pgs = ma['pgs'];
    evaluation = ma['evaluation'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'status': status,
      'pgs': pgs,
      'evaluation': evaluation,
    };
  }
}

enum Status { lido, lendo, naoLido }
