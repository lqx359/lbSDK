

import UIKit
import LBLelinkKit

class LMLBSDKManager: NSObject {
    
    static let shareInstance = LMLBSDKManager()
    //设备搜索类
    
    //初始化乐播sdk
    func initLBSDK(appid: String,secretKey: String,result: @escaping FlutterResult){
        
        #if DEBUG
           LBLelinkKit.enableLog(true);
        #else
        
        #endif

        let authResult: Bool = ((try? LBLelinkKit.auth(withAppid: appid, secretKey: secretKey)) != nil)

        if (authResult){
            print("sdk初始化成功")
        }else{
            print("sdk初始化失败")
        }
        //初始化结果回调给flutter
        result(authResult)
        
        //注册成为互动广告的监听者
        LBLelinkKit.registerAsInteractiveAdObserver()
        
    }
    
    //开始搜索设备
    func beginSearchEquipment(){
        
        //点击搜索设备时上报
        LBLelinkBrowser.reportAPPTVButtonAction()
        
        //开始搜索设备
        self.linkBrowser.searchForLelinkService()
        
    }
    
    //连接设备
    func linkToService(ipAddress: String) {
        
        var currentService:LBLelinkService?
        
        for item in self.services {
            if (item.ipAddress == ipAddress){
                currentService = item;
                break;
            }
        }
        
        if let c = currentService{

            self.linkConnection.lelinkService = c
            self.linkConnection.connect();

        }else{

            print("设备无效/找不到该设备");

        }
        
    }
    
    //获取上次连接的设备
    func getLastConnectService(result: @escaping FlutterResult){
        
        let lastServices = self.linkBrowser.lastServices()
        
        if lastServices?.count ?? 0 > 0{
        
            let ser = lastServices?[0]
            
            if let item = ser{
            
                let dict: [String:String] = [
                    "tvName": item.lelinkServiceName,
                    "tvUID": item.tvUID == nil ? "":item.tvUID,
                    "ipAddress":item.ipAddress
                ];
               
                result(dict);
            }else{
                result([
                    "tvName": "",
                    "tvUID": "",
                    "ipAddress":""
                ])
            }
        }else{
            result([
                "tvName": "",
                "tvUID": "",
                "ipAddress":""
            ])
        }
        
    }
    
    
    //断开连接
    func disConnect(){
        self.linkConnection.disConnect();
    }
    
    
    // MARK:--------懒加载--------
    
    //设备
    lazy var linkBrowser: LBLelinkBrowser = {
        let a = LBLelinkBrowser()
        a.delegate = self;
        return a
    }()
    
    //连接
    lazy var linkConnection: LBLelinkConnection = {
        let a = LBLelinkConnection()
        a.delegate = self;
        return a
    }()
    
    //设备列表
    lazy var services: [LBLelinkService] = {
        let a = Array<LBLelinkService>()
        return a;
    }()
    
}

//设备搜索代理
extension LMLBSDKManager: LBLelinkBrowserDelegate{
    
    //搜索列表发生错误回调
    func lelinkBrowser(_ browser: LBLelinkBrowser!, onError error: Error!) {
        
        print("搜索设备发生错误：\(String(describing: error))")
        
        LMLBEventChannelSupport.sharedInstance.sendErrorToFlutter(error: error);
    }
    
    //设备列表发生变化回调
    func lelinkBrowser(_ browser: LBLelinkBrowser!, didFind services: [LBLelinkService]!) {
        
        self.services = services;
        
        LMLBEventChannelSupport.sharedInstance.sendServicesToFlutter(services: services)
        
    }
    
}

//连接代理
extension LMLBSDKManager: LBLelinkConnectionDelegate{
    
    //连接成功
   func lelinkConnection(_ connection: LBLelinkConnection, didConnectTo service: LBLelinkService) {
       
       print("连接成功");
    
    for item in self.linkBrowser.lastServices() {
        self.linkBrowser.deleteLelinkService(item)
    }
    //连接成功的话保存该设备
    self.linkBrowser.save([service])
    
    LMLBEventChannelSupport.sharedInstance.sendCommonDesToFlutter(type: .connect, des: "连接\(String(describing: service.lelinkServiceName))成功")
    
   }

    //连接断开
    func lelinkConnection(_ connection: LBLelinkConnection, disConnectTo service: LBLelinkService) {
        print("连接断开");
        
        LMLBEventChannelSupport.sharedInstance.sendCommonDesToFlutter(type: .disConnect, des: "与\(String(describing: service.lelinkServiceName))断开连接")
        
    }
    
    //连接出错
    func lelinkConnection(_ connection: LBLelinkConnection, onError error: Error) {
        
        print("连接出错");
        LMLBEventChannelSupport.sharedInstance.sendErrorToFlutter(error: error)
    }
    
    //收到互动广告
    func lelinkConnection(_ connection: LBLelinkConnection, didReceive adInfo: LBADInfo) {
        
        //暂不处理
    }
    
}
