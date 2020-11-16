class FeedData {
  final String guid;
  final String title;
  final String url;
  final String details;
  // final List<LocationFact> facts;

  FeedData(this.guid, this.title, this.url, this.details);

  static List<FeedData> fetchAll() {
    return [
      FeedData('234fe2', 'Kiyomizu-dera', 'assets/images/kiyomizu-dera.jpg',
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sodales vulputate libero, vitae porta neque ultricies non. Quisque porta in velit ac venenatis. Ut gravida tellus at sapien feugiat, id eleifend urna faucibus. Phasellus eu vulputate tellus, eu pellentesque nisl. Phasellus viverra blandit erat, sed bibendum lectus tempus id. Duis volutpat cursus metus, in tempor risus condimentum a. Fusce gravida viverra ipsum. Duis eget ante varius ex vulputate efficitur a ac augue. Nulla dapibus bibendum congue.'),
      FeedData('664f32', 'Mount Fuji', 'assets/images/fuji.jpg',
          'Mauris laoreet tempor eleifend. Suspendisse turpis erat, luctus consequat tristique eu, sodales quis mauris. Proin justo felis, auctor ut nisi in, dictum luctus sapien. Sed pretium ipsum sit amet enim tincidunt facilisis. Ut a ex porttitor, pulvinar dui id, fermentum augue. Integer sed libero lacus. Proin lobortis id nunc nec finibus. Fusce libero massa, posuere vitae consectetur at, fermentum vitae tortor. Praesent non nisi lacus. Sed volutpat dui in elit dignissim, a congue elit maximus.'),
      FeedData(
          '234j32',
          'Arashiyama Bamboo Grove',
          'assets/images/arashiyama.jpg',
          'Cras fermentum feugiat risus, eu mattis velit ullamcorper nec. Mauris ultrices ultricies tortor eget condimentum. Sed rutrum sem id erat elementum facilisis. Nunc et enim enim. Proin congue tortor at nunc dictum, sit amet suscipit urna dapibus. Morbi sed erat metus. Quisque quis malesuada sem, ac faucibus odio. Donec porta tellus sem, vitae lacinia neque malesuada ac. Sed sagittis dictum bibendum. Integer pulvinar vehicula fermentum. Morbi maximus suscipit tortor at cursus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;'),
    ];
  }

  static FeedData fetchByID(int locationID) {
    // NOTE: this will replaced by a proper API call
    return null;
  }
}
