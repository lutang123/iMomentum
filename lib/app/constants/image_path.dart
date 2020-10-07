// https://source.unsplash.com/daily?nature
//'https://source.unsplash.com/random?nature'
//https://source.unsplash.com/random?nature/$counter

class ImagePath {
  ///todo: how to filter good photo, order_by=popular seems no use
  static String randomImageUrl =
      'https://source.unsplash.com/random?nature&wallpaper&travel&landscape&mountain&ocean/';
  static String randomImageUrlFirstPart =
      'https://source.unsplash.com/random?nature&wallpaper&travel&landscape&mountain&ocean/';

  // the two are the same
  static String fixedImageUrl =
      'https://images.unsplash.com/photo-1582108529822-5258e7be743f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2775&q=80';
  static String fixedImagePath = 'assets/images/main5.jpg';

  static String startImage = 'assets/images/main5.jpg';
  static String introImage = 'assets/images/main5.jpg';
  static String startImage1 = 'assets/images/landscape.jpg';
  static String startImage2 = 'assets/images/waterfall.jpg';
  static String startImage3 = 'assets/images/landscape2.jpg';
  static String signInImage = 'assets/images/mountain_new.jpg';

  static String loadingImage = 'assets/images/cloud.jpg';
}
