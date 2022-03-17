class VideoContentModel{
  String id,asset_id,passthrough_id,stream_url,upload_url;
  bool is_processed;
  String status;
  int profile;

  VideoContentModel({this.id="",
  this.asset_id="",this.passthrough_id="",
    this.stream_url="",this.is_processed=false,
  this.status="",this.profile=0,this.upload_url=""});

  factory VideoContentModel.fromMap(Map<String,dynamic>? snapshot){
    if(snapshot==null)
      return new VideoContentModel(id: "",
          asset_id: "",
          passthrough_id: "",
          stream_url: "",
          is_processed: false,
          status: "",
          profile: 0);
    return new VideoContentModel(id: snapshot["id"],
        asset_id: snapshot["asset_id"],
        passthrough_id: snapshot["passthrough_id"],
        stream_url: snapshot["stream_url"],
        is_processed: snapshot["is_processed"],
        status: snapshot["status"],
        profile: snapshot["profile"]);
  }
}