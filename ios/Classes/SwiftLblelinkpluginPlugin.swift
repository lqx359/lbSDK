import UIKit
import Flutter


 public class SwiftLblelinkpluginPlugin: NSObject, FlutterPlugin {
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lblelinkplugin", binaryMessenger: registrar.messenger())
    let instance = SwiftLblelinkpluginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    LMLBEventChannelSupport.register(with: registrar);
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    let dict = call.arguments as? [String:String]
    
    switch call.method {
        case "initLBSdk":
        LMLBSDKManager.shareInstance.initLBSDK(appid: dict?["iosAppid"] ?? "", secretKey: dict?["iosSecretKey"] ?? "",result: result);
        break
        case "beginSearchEquipment":
            LMLBSDKManager.shareInstance.beginSearchEquipment()
        break
        case "connectToService":
            LMLBSDKManager.shareInstance.linkToService(ipAddress: dict?["ipAddress"] ?? "");
        break
        case "disConnect":
            LMLBSDKManager.shareInstance.disConnect();
        break
        case "pause":
            LBPlayerManager.shareInstance.pause();
        break
        case "resumePlay":
            LBPlayerManager.shareInstance.resumePlay();
        break
        case "stop":
            LBPlayerManager.shareInstance.stop();
        break
        case "play":
            LBPlayerManager.shareInstance.beginPlay(connection: LMLBSDKManager.shareInstance.linkConnection, playUrl: dict?["playUrlString"] ?? "");
        break
        case "getLastConnectService":
            LMLBSDKManager.shareInstance.getLastConnectService(result: result)
        break
    default:
        result(FlutterMethodNotImplemented)
        break;
    }
    
    //result("iOS " + UIDevice.current.systemVersion)
  }
}
