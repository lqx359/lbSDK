///
/// @ProjectName:    lblelink_plugin
/// @ClassName:      tv_list
/// @Description:    dart类作用描述
/// @Author:         孙浩
/// @QQ:             243280864
/// @CreateDate:     2020/5/15 15:35

class TvListResult {
  List<TvData> tvList;

  void getResultFromMap(data) {
    tvList = List();
    data.forEach((info) {
      tvList.add(TvData()
        ..name = info["tvName"]
        ..uId = info["tvUID"]
        ..ipAddress = info["ipAddress"]);
    });
  }
}

class TvData {
  String name;
  String uId;
  String ipAddress;
}
