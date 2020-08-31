import 'dart:async';
import 'package:iMomentum/app/models/duration_model.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/models/image_model_NOTUSED.dart';
import 'package:iMomentum/app/models/mantra_model.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:iMomentum/app/models/quote_model.dart';
import 'package:iMomentum/app/models/todo.dart';
import 'package:meta/meta.dart';

import 'api_path.dart';
import 'firestore_service.dart';

//if we need to create multiple implications for those class, then having an
// abstract class is valuable ??
abstract class Database {
//  readData();
//  readDataStreamListen();

  //todo
  Future<void> setTodo(Todo todo); //create/update a job
  Future<void> deleteTodo(Todo todo); //delete a job
  Stream<Todo> todoStream({@required String todoId}); //read one jobs
  Stream<List<Todo>> todosStream(); //read all jobs

  //duration
  Future<void> setDuration(DurationModel duration);
  Future<void> deleteDuration(DurationModel duration);
  Stream<List<DurationModel>> durationsStream({Todo todo});

  //folder
  Future<void> setFolder(Folder folder); //create/update a job
  Future<void> deleteFolder(Folder folder); //delete a job
  Stream<Folder> folderStream({@required String folderId});
  Stream<List<Folder>> foldersStream(); //read all jobs

  //note
  Future<void> setNote(Note note); //create/update a job
  Future<void> updateNote(Note note); //to update isDone
  Future<void> deleteNote(Note note); //delete a job
  Stream<List<Note>> notesStream(); //read all jobs
  Stream<Note> noteStream({@required String noteId}); //read one jobs

  // //images
  // Future<void> setImage(ImageModel image); //create/update a job
  // Future<void> deleteImage(ImageModel image); //delete a job
  // Stream<List<ImageModel>> imagesStream(); //read all jobs
  // Stream<ImageModel> imageStream({@required String imageId});

  //mantras
  Future<void> setMantra(MantraModel mantra); //create/update a job
  Future<void> deleteMantra(MantraModel mantra); //delete a job
  Stream<List<MantraModel>> mantrasStream(); //read all jobs
  Stream<MantraModel> mantraStream({@required String mantraId});

  //quotes
  Future<void> setQuote(QuoteModel quote); //create/update a job
  Future<void> deleteQuote(QuoteModel quote); //delete a job
  Stream<List<QuoteModel>> quotesStream(); //read all jobs
  Stream<QuoteModel> quoteStream({@required String quoteId});
}

//we use time as Id
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  //ensure only one object of FirestoreService is create
  final _service = FirestoreService.instance;

  /// job
  @override //create or update job
  Future<void> setTodo(Todo todo) async => await _service.setData(
        path: APIPath.todo(uid, todo.id),
        data: todo.toMap(),
      );

  @override // delete job
  Future<void> deleteTodo(Todo todo) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await durationsStream(todo: todo).first;
    for (DurationModel entry in allEntries) {
      if (entry.todoId == todo.id) {
        await deleteDuration(entry);
      }
    }
    await _service.deleteData(path: APIPath.todo(uid, todo.id));
  }

  @override //read a job
  Stream<Todo> todoStream({@required String todoId}) => _service.documentStream(
        path: APIPath.todo(uid, todoId),
        builder: (data, documentId) => Todo.fromMap(data, documentId),
      );
  @override //read jobs
  Stream<List<Todo>> todosStream() => _service.collectionStream(
      path: APIPath.todos(uid),
      builder: (data, documentId) => Todo.fromMap(data, documentId),
//        queryBuilder: (query) => query.orderBy('category'),
      //to make the most recently edited one show first
      //e.g. messageList.sort((m, m2) => int.parse(m.id).compareTo(int.parse(m2.id)));
      //this will not work well because when we update, we use the same id, or use date
      sort: (lhs, rhs) => rhs.id.compareTo(lhs.id),
      sortIsDone: (lhs, rhs) => (rhs.isDone.toString().length)
          .compareTo(lhs.isDone.toString().length),
      sortCategory: (lhs, rhs) {
        //add this because previous todo item does not have category
        if ((lhs.category != null) && (rhs.category != null)) {
          return lhs.category.compareTo(rhs.category); //this way is from 0 to 4
        } else
          return null;
      });

  /// duration
  @override
  Future<void> setDuration(DurationModel duration) async =>
      await _service.setData(
        path: APIPath.duration(uid, duration.id),
        data: duration.toMap(),
      );

  @override
  Future<void> deleteDuration(DurationModel duration) async =>
      await _service.deleteData(path: APIPath.duration(uid, duration.id));

  @override
  Stream<List<DurationModel>> durationsStream({Todo todo}) =>
      _service.collectionStream<DurationModel>(
        path: APIPath.durations(uid),
        queryBuilder: todo != null
            ? (query) => query.where('todoId', isEqualTo: todo.id)
            : null,
        builder: (data, documentID) => DurationModel.fromMap(data, documentID),
//        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  /// folder
  @override //create or update job
  Future<void> setFolder(Folder folder) async => await _service.setData(
        path: APIPath.folder(uid, folder.id),
        data: folder.toMap(),
      );

  @override // delete job
  Future<void> deleteFolder(Folder folder) async {
    // delete where entry.jobId == job.jobId
    final allNotes = await notesStream(folder: folder).first;
    for (Note note in allNotes) {
      if (note.folderId == folder.id) {
        await deleteNote(note);
      }
    }
    await _service.deleteData(path: APIPath.folder(uid, folder.id));
  }

  @override //read a job
  Stream<Folder> folderStream({@required String folderId}) =>
      _service.documentStream(
        path: APIPath.folder(uid, folderId),
        builder: (data, documentId) => Folder.fromMap(data, documentId),
      );
  @override //read jobs
  Stream<List<Folder>> foldersStream() => _service.collectionStream(
        path: APIPath.folders(uid),
        builder: (data, documentId) => Folder.fromMap(data, documentId),
        //to make the most recently edited one show first
        sort: (lhs, rhs) => rhs.id.compareTo(lhs.id),
      );

  /// note
  @override //create or update job
  Future<void> setNote(Note note) async => await _service.setData(
        path: APIPath.note(uid, note.id),
        data: note.toMap(),
      );

  @override //create or update job
  Future<void> updateNote(Note note) async => await _service.updateData(
        path: APIPath.note(uid, note.id),
        data: note.toMap(),
      );

  //TODO delete all entries for a particular job??
  @override // delete job
  Future<void> deleteNote(Note note) async {
    await _service.deleteData(
      path: APIPath.note(uid, note.id),
    );
  }

  @override //read a job
  Stream<Note> noteStream({@required String noteId}) => _service.documentStream(
        path: APIPath.note(uid, noteId),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );
  @override //read jobs
  Stream<List<Note>> notesStream({Folder folder}) =>
      _service.collectionStream<Note>(
        path: APIPath.notes(uid),
        queryBuilder: folder != null
            ? (query) => query.where('folderId', isEqualTo: folder.id)
            : null,
        builder: (data, documentId) => Note.fromMap(data, documentId),
        //to make the most recently edited one show first
        sort: (lhs, rhs) => rhs.date.compareTo(lhs.date),
      );

  ///for image
  // //create or update job
  // Future<void> setImage(ImageModel image) async => await _service.setData(
  //       path: APIPath.image(uid, image.id),
  //       data: image.toMap(),
  //     );
  //
  // //TODO delete all entries for a particular job??
  // @override // delete job
  // Future<void> deleteImage(ImageModel image) async {
  //   await _service.deleteData(
  //     path: APIPath.image(uid, image.id),
  //   );
  // }
  //
  // @override //read a job
  // Stream<ImageModel> imageStream({@required String imageId}) =>
  //     _service.documentStream(
  //       path: APIPath.image(uid, imageId),
  //       builder: (data, documentId) => ImageModel.fromMap(data, documentId),
  //     );
  // @override //read jobs
  // Stream<List<ImageModel>> imagesStream() => _service.collectionStream(
  //       path: APIPath.images(uid),
  //       builder: (data, documentId) => ImageModel.fromMap(data, documentId),
  //     );

  ///for mantras
  //create or update job
  Future<void> setMantra(MantraModel mantra) async => await _service.setData(
        path: APIPath.mantra(uid, mantra.id),
        data: mantra.toMap(),
      );

  @override // delete job
  Future<void> deleteMantra(MantraModel mantra) async {
    await _service.deleteData(
      path: APIPath.mantra(uid, mantra.id),
    );
  }

  @override //read a job
  Stream<MantraModel> mantraStream({@required String mantraId}) =>
      _service.documentStream(
        path: APIPath.mantra(uid, mantraId),
        builder: (data, documentId) => MantraModel.fromMap(data, documentId),
      );
  @override //read jobs
  Stream<List<MantraModel>> mantrasStream() => _service.collectionStream(
        path: APIPath.mantras(uid),
        builder: (data, documentId) => MantraModel.fromMap(data, documentId),
        //to make the most recently edited one show first
        sort: (lhs, rhs) => rhs.date.compareTo(lhs.date),
      );

  ///for quotes
  //create or update job
  Future<void> setQuote(QuoteModel quote) async => await _service.setData(
        path: APIPath.quote(uid, quote.id),
        data: quote.toMap(),
      );

  @override // delete job
  Future<void> deleteQuote(QuoteModel quote) async {
    await _service.deleteData(
      path: APIPath.quote(uid, quote.id),
    );
  }

  @override //read a job
  Stream<QuoteModel> quoteStream({@required String quoteId}) =>
      _service.documentStream(
        path: APIPath.quote(uid, quoteId),
        builder: (data, documentId) => QuoteModel.fromMap(data, documentId),
      );
  @override //read jobs
  Stream<List<QuoteModel>> quotesStream() => _service.collectionStream(
        path: APIPath.quotes(uid),
        builder: (data, documentId) => QuoteModel.fromMap(data, documentId),
        //to make the most recently edited one show last
        sort: (lhs, rhs) => rhs.date.compareTo(lhs.date),
      );
}

/// for firebase note:
//@override
//List<TodoModel> readData() {
//  List<TodoModel> todos = [];
//  Firestore.instance
//      .collection(APIPath.todos(uid))
//  //Type: Future<QuerySnapshot> Function({Source source})
//      .getDocuments()
//      .then((querySnapshot) {
//    //List<DocumentSnapshot> get documents
////      print(querySnapshot.documents); //flutter: [Instance of 'DocumentSnapshot', Instance of 'DocumentSnapshot']
//    querySnapshot.documents.forEach((result) {
////        //Map<String, dynamic> get data
////        print(
////            'result.data: ${result.data}'); //flutter: {date: 1592507007465, is_done: false, title: test}
////        print(
////            'result.documentID: ${result.documentID}'); //flutter: result.documentID: 2020-06-20T01:54:27.319274
//      todos.add(TodoModel.fromMap(result.data, result.documentID));
//    });
////      print('from database: $todos');
//    //flutter: from database: [id: 2020-06-20T01:54:27.319274, title: only tap to see, id: 2020-06-20T10:49:18.994399, title: add new, id: 2020-06-20T13:25:56.691867, title: add new on 24, null, null, id: 2020-06-20T14:33:58.357978, title: add new 30, id: 2020-06-20T20:59:47.190562, title: update, id: 2020-06-20T21:03:12.415300, title: still not right, id: 2020-06-20T21:04:03.499955, title: how to do it?, id: 2020-06-20T21:53:25.176339, title: add to today]
//  });
////    print('from database: $todos')
//  return todos; // this returns []
//}
//
//Map<DateTime, List<dynamic>> groupEvents(List<TodoModel> todos) {
//  Map<DateTime, List<dynamic>> map = {};
//  todos.forEach((todo) {
//    DateTime date =
//    DateTime(todo.date.year, todo.date.month, todo.date.day, 12);
//    if (map[date] == null) map[date] = [];
//    map[date].add(todo);
//  });
//  return map;
//}
//
////https://stackoverflow.com/questions/54405293/how-to-get-data-from-firestore-and-refresh-the-state-automatically-without-click
//@override
//readDataStreamListen() {
//  List<TodoModel> todos = [];
//  Map<DateTime, List<dynamic>> map = {};
//  final Stream<QuerySnapshot> snapshots = Firestore.instance
//      .collection(APIPath.todos(uid))
//  //Type: Stream<QuerySnapshot> Function({bool includeMetadataChanges})
//      .snapshots();
//
//  snapshots.listen((result) {
//    //List<DocumentSnapshot> get documents
//    result.documents.forEach((doc) {
//      todos.add(TodoModel.fromMap(doc.data, doc.documentID));
////        print('stream.listen: ${doc.data}');
////        //flutter: stream.listen: {date: 1592930773069, is_done: false, title: test 3}
//    });
//    todos.forEach((todo) {
//      DateTime date =
//      DateTime(todo.date.year, todo.date.month, todo.date.day, 12);
//      if (map[date] == null) map[date] = [];
//      map[date].add(todo);
//    });
//    print('1st: $map');
//    return map;
//  });
//  print('2nd: $map'); //flutter: 2nd: {}
//}
////when add new, this got printed:
////users/zZaqiMzqGchd4bJTJ4M6ZO8PPJs1/todos/2020-06-19T12:08:18.058366: {title: add new, date: 1592593688271, is_done: false}
