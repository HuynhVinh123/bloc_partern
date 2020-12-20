class LuckyWheelSetting {
  LuckyWheelSetting(
      {this.hasOrder = false,
      this.hasComment = false,
      this.isPriorityComment = false,
      this.isPriorityShare = false,
      this.isIgnorePriorityWinner = false,
      this.hasShare = false,
      this.isPriorityShareGroup = false,
      this.isPrioritySharePersonal = false,
      this.isSkipWinner = false,
      this.numberSkipDays = 1,
      this.timeInSecond = 5, this.isPriority = true});

  bool hasComment;
  bool hasShare;
  bool hasOrder;
  bool isSkipWinner;
  bool isPriority;
  bool isPriorityShare;
  bool isPriorityShareGroup;
  bool isPrioritySharePersonal;
  bool isPriorityComment;
  bool isIgnorePriorityWinner;
  int numberSkipDays;
  int timeInSecond;
}
