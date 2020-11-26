# lblelinkplugin

乐播云投屏组件

## 使用

**1.安装**
```
lblelink_plugin: 
path:../

```
**2.导入**
```
import 'package:lblelinkplugin/lblelinkplugin.dart';
import 'package:lblelinkplugin/tv_list.dart';

```
**3.使用**
```
初始化
...
//参数：appid、secretKey
Lblelinkplugin.initLBSdk("you_key", "you_secret");
...
```
**4.内部方法**
```
//获取可连接设备列表
Lblelinkplugin.getServicesList((data){
     //data类型是List<TvData>
});

//连接设备
//参数：设备ip地址、连接成功回调、连接断开回调
Lblelinkplugin.connectToService("192.168.0.1", fConnectListener: (){

                  }, fDisConnectListener: (){

                  });

  //开始投屏
  Lblelinkplugin.play('http://pullhls80d25490.live.126.net/live/7d9cc146131245ddbf2126d56c699191/playlist.m3u8');

  //断开连接
  Lblelinkplugin.disConnect()

  //暂停
  Lblelinkplugin.pause()

  //继续播放
  Lblelinkplugin.resumePlay()

  //退出播放
  Lblelinkplugin.stop()

-------------------------------------------状态回调监听----------------------------------------------
  //回调监听
  LbCallBack是一个抽象类，可在需要的类后面with LbCallBack,实现内部的方法，来设置状态监听：
  void addListener() {
      Lblelinkplugin.lbCallBack = this;
    }

  目前有以下监听：
    @override
    void completeCallBack() {
      // 播放完成事件回调（注意：直播结束接收不到该回调）
    }

    //errorDes: 错误描述
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


```
