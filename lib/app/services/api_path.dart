class FireStorePath {
  //jobs
  static String todo(String uid, String todoId) => 'users/$uid/todos/$todoId';
  static String todos(String uid) => 'users/$uid/todos';
  //durations
  static String duration(String uid, String durationId) =>
      'users/$uid/durations/$durationId';
  static String durations(String uid) => 'users/$uid/durations';

  //folders
  static String folder(String uid, String folderId) =>
      'users/$uid/folders/$folderId';
  static String folders(String uid) => 'users/$uid/folders';

  //notes
  static String note(String uid, String noteId) => 'users/$uid/notes/$noteId';
  static String notes(String uid) => 'users/$uid/notes';

  ///image
  static String image(String uid, String imageId) =>
      'users/$uid/images/$imageId';
  static String images(String uid) => 'users/$uid/images';

  ///mantras
  static String mantra(String uid, String mantraId) =>
      'users/$uid/mantras/$mantraId';
  static String mantras(String uid) => 'users/$uid/mantras';

  ///mantras
  static String quote(String uid, String quoteId) =>
      'users/$uid/quotes/$quoteId';
  static String quotes(String uid) => 'users/$uid/quotes';
}
