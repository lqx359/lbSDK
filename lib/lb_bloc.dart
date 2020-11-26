import 'package:lb_flutter/lblelinkplugin.dart';

///
/// @ProjectName:    lblelink_plugin
/// @ClassName:      lb_bloc
/// @Description:    dart类作用描述
/// @Author:         孙浩
/// @QQ:             243280864
/// @CreateDate:     2020/5/19 9:45
class LBbloc with LbCallBack {
  ///添加监听
  void addListener() {
    Lblelinkplugin.lbCallBack = this;
  }

  ///播放url地址需优先调用Connect
  void playByUrl(String url) {
    Lblelinkplugin.play(url);
  }

  ///播放暂停
  void playPause() {
    Lblelinkplugin.pause();
  }

  ///播放停止
  void playStop() {
    Lblelinkplugin.stop();
  }

  ///搜索数据
  void searchList() {
    Lblelinkplugin.getServicesList((data) {});
  }

  ///连接数据
  void connectData() {
    Lblelinkplugin.connectToService("uuId", '',
        fConnectListener: () {}, fDisConnectListener: () {});
  }

  ///断开连接
  void disConnect() {
    Lblelinkplugin.disConnect();
  }

  @override
  void completeCallBack() {
    // 完成事件回调
  }

  @override
  void errorCallBack(String errorDes) {
    // 错误事件回调
  }

  @override
  void loadingCallBack() {
    // 加载中事件回调
  }

  @override
  void startCallBack() {
    // 开始事件回调
  }

  @override
  void pauseCallBack() {
    // 暂停事件回调
  }

  @override
  void stopCallBack() {
    // 停止事件回调
  }
}
