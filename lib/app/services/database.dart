import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iMomentum/app/models/duration_model.dart';
import 'package:iMomentum/app/models/todo_model.dart';
import 'package:meta/meta.dart';

import 'api_path.dart';
import 'firestore_service.dart';

//if we need to create multiple implications for those class, then having an
// abstract class is valuable ??
abstract class Database {
  readData();
  readDataStreamListen();

  //job
  Future<void> setTodo(TodoModel job); //create/update a job
  Future<void> updateTodo(TodoModel todo); //to update isDone
  Future<void> deleteTodo(TodoModel job); //delete a job
  Stream<List<TodoModel>> todosStream(); //read all jobs
  Stream<TodoModel> todoStream({@required String todoId}); //read one jobs

  //duration
  Future<void> setDuration(DurationModel duration);
  Future<void> deleteDuration(DurationModel duration);
  Stream<List<DurationModel>> durationsStream({TodoModel todo});
}

//we use time as Id
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  //ensure only one object of FirestoreService is create
  final _service = FirestoreService.instance;

  //job
  @override //create or update job
  Future<void> setTodo(TodoModel todo) async => await _service.setData(
        path: APIPath.todo(uid, todo.id),
        data: todo.toMap(),
      );

  //job
  @override //create or update job
  Future<void> updateTodo(TodoModel todo) async => await _service.updateData(
        path: APIPath.todo(uid, todo.id),
        data: todo.toMap(),
      );

  //TODO delete all entries for a particular job??
  @override // delete job
  Future<void> deleteTodo(TodoModel todo) async {
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
  Stream<TodoModel> todoStream({@required String todoId}) =>
      _service.documentStream(
        path: APIPath.todo(uid, todoId),
        builder: (data, documentId) => TodoModel.fromMap(data, documentId),
      );
  @override //read jobs
  Stream<List<TodoModel>> todosStream() => _service.collectionStream(
        path: APIPath.todos(uid),
        builder: (data, documentId) => TodoModel.fromMap(data, documentId),
      );

  @override
  List<TodoModel> readData() {
    List<TodoModel> todos = [];
    Firestore.instance
        .collection(APIPath.todos(uid))
        //Type: Future<QuerySnapshot> Function({Source source})
        .getDocuments()
        .then((querySnapshot) {
      //List<DocumentSnapshot> get documents
//      print(querySnapshot.documents); //flutter: [Instance of 'DocumentSnapshot', Instance of 'DocumentSnapshot']
      querySnapshot.documents.forEach((result) {
//        //Map<String, dynamic> get data
//        print(
//            'result.data: ${result.data}'); //flutter: {date: 1592507007465, is_done: false, title: test}
//        print(
//            'result.documentID: ${result.documentID}'); //flutter: result.documentID: 2020-06-20T01:54:27.319274
        todos.add(TodoModel.fromMap(result.data, result.documentID));
      });
//      print('from database: $todos');
      //flutter: from database: [id: 2020-06-20T01:54:27.319274, title: only tap to see, id: 2020-06-20T10:49:18.994399, title: add new, id: 2020-06-20T13:25:56.691867, title: add new on 24, null, null, id: 2020-06-20T14:33:58.357978, title: add new 30, id: 2020-06-20T20:59:47.190562, title: update, id: 2020-06-20T21:03:12.415300, title: still not right, id: 2020-06-20T21:04:03.499955, title: how to do it?, id: 2020-06-20T21:53:25.176339, title: add to today]
    });
//    print('from database: $todos')
    return todos; // this returns []
  }

  Map<DateTime, List<dynamic>> groupEvents(List<TodoModel> todos) {
    Map<DateTime, List<dynamic>> map = {};
    todos.forEach((todo) {
      DateTime date =
          DateTime(todo.date.year, todo.date.month, todo.date.day, 12);
      if (map[date] == null) map[date] = [];
      map[date].add(todo);
    });
    return map;
  }

  //https://stackoverflow.com/questions/54405293/how-to-get-data-from-firestore-and-refresh-the-state-automatically-without-click
  @override
  readDataStreamListen() {
    List<TodoModel> todos = [];
    Map<DateTime, List<dynamic>> map = {};
    final Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection(APIPath.todos(uid))
        //Type: Stream<QuerySnapshot> Function({bool includeMetadataChanges})
        .snapshots();

    snapshots.listen((result) {
      //List<DocumentSnapshot> get documents
      result.documents.forEach((doc) {
        todos.add(TodoModel.fromMap(doc.data, doc.documentID));
//        print('stream.listen: ${doc.data}');
//        //flutter: stream.listen: {date: 1592930773069, is_done: false, title: test 3}
      });
      todos.forEach((todo) {
        DateTime date =
            DateTime(todo.date.year, todo.date.month, todo.date.day, 12);
        if (map[date] == null) map[date] = [];
        map[date].add(todo);
      });
      print('1st: $map');
      return map;
    });
    print('2nd: $map'); //flutter: 2nd: {}
  }
  //when add new, this got printed:
  //users/zZaqiMzqGchd4bJTJ4M6ZO8PPJs1/todos/2020-06-19T12:08:18.058366: {title: add new, date: 1592593688271, is_done: false}

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
  Stream<List<DurationModel>> durationsStream({TodoModel todo}) =>
      _service.collectionStream<DurationModel>(
        path: APIPath.durations(uid),
        queryBuilder: todo != null
            ? (query) => query.where('todoId', isEqualTo: todo.id)
            : null,
        builder: (data, documentID) => DurationModel.fromMap(data, documentID),
//        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
