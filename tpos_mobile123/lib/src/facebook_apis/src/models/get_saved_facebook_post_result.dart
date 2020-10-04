/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class SavedFacebookPost {
  String id;
  DateTime lastUpdated;
  String liveCampaignId;
  String liveCampaignName;

  SavedFacebookPost(
      {this.id, this.lastUpdated, this.liveCampaignId, this.liveCampaignName});

  SavedFacebookPost.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    lastUpdated = DateTime.tryParse("LastUpdated");
    liveCampaignId = jsonMap["LiveCampaignId"];
    liveCampaignName = jsonMap["LiveCampaignName"];
  }
}
