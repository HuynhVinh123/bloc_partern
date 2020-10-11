Future<void> downloadFile(String url,
    {Map<String, dynamic> param,
    String body,
    String method = "POST",
    String fileName,
    Map<String, dynamic> header}) async {
//  var storagePermissionStatus = await Permission.storage.status;
//
//  if (storagePermissionStatus.isUndetermined) {
//    await Permission.storage.request();
//    storagePermissionStatus = await Permission.storage.status;
//  }
//
//  if (storagePermissionStatus.isGranted) {
//    String savePath = "";
//    if (Platform.isAndroid) {
//      var downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
//      savePath = downloadsDirectory.path;
//    } else {
//      savePath = (await getApplicationDocumentsDirectory()).path;
//    }
//
//    fileName =
//        fileName ?? '${DateFormat("ddMMyyyyHHmmss").format(DateTime.now())}';
//    FileUtils.mkdir([savePath]);
//    await Dio().download(
//      url,
//      "$savePath/$fileName",
//      options: Options(
//        method: method,
//        headers: header,
//      ),
//    );
//  } else {
//    throw new Exception('Permission Denied');
//  }
}
