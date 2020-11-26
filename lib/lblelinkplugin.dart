import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lb_flutter/tv_list.dart';

class Lblelinkplugin {
  static const MethodChannel _channel = const MethodChannel('lblelinkplugin');
  static const EventChannel _eventChannel =
      const EventChannel("lblelink_event");

  //设备列表回调
  static ValueChanged<List<TvData>> _serviecListener;

  static Function _connectListener;
  static Function _disConnectListener;
  static LbCallBack _lbCallBack;

  static set lbCallBack(LbCallBack value) {
    _lbCallBack = value;
  } //eventChannel监听分发中心

  static eventChannelDistribution() {
    _eventChannel.receiveBroadcastStream().listen((data) {
      print(data);
      int type = data["type"];

      switch (type) {
        case -1:
          _disConnectListener.call();
          break;
        case 0:
          TvListResult _tvList = TvListResult();
          _tvList.getResultFromMap(data["data"]);
          _serviecListener?.call(_tvList.tvList);
          break;
        case 1:
          _connectListener?.call();
          break;
        case 2:
          _lbCallBack?.loadingCallBack();
          break;
        case 3:
          _lbCallBack?.startCallBack();
          break;
        case 4:
          _lbCallBack?.pauseCallBack();
          break;
        case 5:
          _lbCallBack?.pauseCallBack();
          break;
        case 6:
          _lbCallBack?.stopCallBack();
          break;
        case 9:
          _lbCallBack?.errorCallBack(data["data"]);
          break;
        default:
          print(data["data"]);
          break;
      }
    });
  }

  //初始化sdk
  //返回值：初始化成功与否
  static Future<bool> initLBSdk({
    @required String androidAppid,
    @required String androidSecretKey,
    @required String iosAppid,
    @required String iosSecretKey,
  }) async {
    //初始化的时候注册eventChannel回调
    eventChannelDistribution();
    return _channel.invokeMethod(
      "initLBSdk",
      {
        "androidAppid": androidAppid,
        "androidSecretKey": androidSecretKey,
        "iosAppid": iosAppid,
        "iosSecretKey": iosSecretKey,
      },
    ).then((data) {
      return data;
    });

    //初始化的时候注册eventChannel回调
    // eventChannelDistribution();
  }

  //获取设备列表
  //回调：设备数组
  static getServicesList(ValueChanged<List<TvData>> serviecListener) {
    //开始搜索设备
    _channel.invokeMethod("beginSearchEquipment");

    _serviecListener = serviecListener;

//    _eventChannel.receiveBroadcastStream().listen((data) {
//
//      List<String> result = [];
//      data.forEach((data) {
//        String name = data as String;
//        result.add(name);
//      });
//        messageListener(result);
//    });
  }

  //连接设备(参数未定)
  static connectToService(String ipAddress, String name,
      {@required Function fConnectListener,
      @required Function fDisConnectListener}) {
    _connectListener = fConnectListener;
    _disConnectListener = fDisConnectListener;
    _channel.invokeMethod(
        "connectToService", {"ipAddress": ipAddress, "name": name});
  }

  //获取上次连接的设备
  static Future<TvData> getLastConnectService() {
    return _channel.invokeMethod("getLastConnectService").then((data) {
      print("data is ${data["tvName"]}");

//      if (data == null){
//        return data;
//      }

      return TvData()
        ..uId = data["tvUID"]
        ..name = data["tvName"]
        ..ipAddress = data["ipAddress"];
    });
  }

  //断开连接
  static disConnect() {
    _channel.invokeMethod("disConnect");
//        .then((data){
//      if(data == 0){
//        _disConnectListener.call();
//      }
//    });
  }

  //暂停
  static pause() {
    _channel.invokeMethod("pause");
  }

  //继续播放
  static resumePlay() {
    _channel.invokeMethod("resumePlay");
  }

  //退出播放
  static stop() {
    _channel.invokeMethod("stop");
  }

  //播放
  static play(String playUrlString) {
    _channel.invokeMethod("play", {"playUrlString": playUrlString});
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

abstract class LbCallBack {
  void startCallBack() {}

  void loadingCallBack() {}

  void completeCallBack() {}

  void pauseCallBack() {}

  void stopCallBack() {}

  void errorCallBack(String errorDes) {}
}
