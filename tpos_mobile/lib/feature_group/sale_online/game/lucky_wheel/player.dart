class Player {
  Player(
      {this.name,
      this.picture,
      this.commentCount = 0,
      this.shareCount = 0,
      this.id,
      this.hasOrder = false,
      this.groupShareCount = 0,
      this.lastWinDate,
      this.personalShareCount = 0,
      this.isWinner = false,
      this.uId,
      this.asuId,
      this.totalDays,
      this.dateCreated});

  String name;
  String picture;
  int shareCount;
  int commentCount;
  int id;
  String uId;
  String asuId;
  double totalDays;
  bool hasOrder;
  bool isWinner;
  int groupShareCount;
  int personalShareCount;

  DateTime lastWinDate;
  DateTime dateCreated;
}
