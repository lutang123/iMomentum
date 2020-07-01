class APIPath {
  //jobs
  static String todo(String uid, String todoId) => 'users/$uid/todos/$todoId';
  static String todos(String uid) => 'users/$uid/todos';
  //durations
  static String duration(String uid, String durationId) =>
      'users/$uid/durations/$durationId';
  static String durations(String uid) => 'users/$uid/durations';

  //entries
  static String note(String uid, String noteId) => 'users/$uid/notes/$noteId';
  static String notes(String uid) => 'users/$uid/notes';
}
