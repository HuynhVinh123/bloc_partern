class LuckyWheelSetting {
  LuckyWheelSetting({
    this.hasOrder = false,
    this.isPriorityComment = false,
    this.isPriorityShare = false,
    this.isIgnorePriorityWinner = false,
    this.isPriorityShareGroup = false,
    this.isPrioritySharePersonal = false,
    this.isSkipWinner = false,
    this.numberSkipDays = 1,
    this.timeInSecond = 5,
    this.isPriority = true,
    this.useShareApi = false,
    this.minNumberComment = 0,
    this.minNumberShare = 0,
    this.minNumberShareGroup = 0,
    this.isPriorityUnWinner = false,
    this.isMinComment = false,
    this.isMinShare = false,
    this.isMinShareGroup = false,
  });


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
  int minNumberComment;
  int minNumberShare;
  int minNumberShareGroup;
  bool useShareApi;
  bool isPriorityUnWinner;
  bool isMinShare;
  bool isMinShareGroup;
  bool isMinComment;
}
