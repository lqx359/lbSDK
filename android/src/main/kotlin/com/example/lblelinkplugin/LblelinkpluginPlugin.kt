package com.example.lblelinkplugin
import android.content.Context
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.logging.StreamHandler

/** LblelinkpluginPlugin */
public class LblelinkpluginPlugin : FlutterPlugin, MethodCallHandler {

  ///=== registerWith()
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "lblelinkplugin")
    channel.setMethodCallHandler(LblelinkpluginPlugin())
    ctx = flutterPluginBinding.applicationContext
    EventChannel(flutterPluginBinding.binaryMessenger, "lblelink_event").setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        LeBUtil.instance.initEvent(events)
      }

      override fun onCancel(arguments: Any?) {
        LeBUtil.instance.removeEvent()
      }
    })
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.

   companion object {
     var ctx: Context? = null
     @JvmStatic
     fun registerWith(registrar: Registrar) {
       val channel = MethodChannel(registrar.messenger(), "lblelinkplugin")
       channel.setMethodCallHandler(LblelinkpluginPlugin())
       ctx = registrar.context().applicationContext
       EventChannel(registrar.messenger(), "lblelink_event").setStreamHandler(object : EventChannel.StreamHandler {
         override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
           LeBUtil.instance.initEvent(events)
         }

         override fun onCancel(arguments: Any?) {
           LeBUtil.instance.removeEvent()
         }
       })
     }
   }

  ///调用具体方法 dart端调用invokeMethod()时执行对应方法
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "initLBSdk" -> {
        ctx?.run {
          LeBUtil.instance.initUtil(this, call.argument<String>("androidAppid")!!, call.argument<String>("androidSecretKey")!!, result)
        }
      }
      "connectToService" -> {
        LeBUtil.instance.connectService(call.argument<String>("ipAddress")!!, call.argument<String>("name")!!)
      }
      "disConnect" -> {
        LeBUtil.instance.disConnect(result)
      }
      "pause" -> {
        LeBUtil.instance.pause()
      }
      "resumePlay" -> {
        LeBUtil.instance.resumePlay()
      }
      "stop" -> {
        LeBUtil.instance.stop()
      }
      "beginSearchEquipment" -> {
        LeBUtil.instance.searchDevice()
      }
      "stopSearchEquipment" -> {
        LeBUtil.instance.stopSearch()
      }
      "play" -> {
        LeBUtil.instance.play(call.argument<String>("playUrlString")!!)
      }
      "getLastConnectService"->{
        LeBUtil.instance.getLastIp(result)
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
