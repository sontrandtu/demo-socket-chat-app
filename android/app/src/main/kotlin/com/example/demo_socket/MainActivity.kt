package com.example.demo_socket

import android.content.Context
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        //2
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "demo").setMethodCallHandler {
            // 3
                call, result ->
            when (call.method) {
                "getPackage" -> {
                    result.success(BuildConfig.APPLICATION_ID)
                }
                "getBattery" -> {
                    result.success(getBatteryCapacity(context))
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getBatteryCapacity(context: Context): Long {
        val mBatteryManager: BatteryManager =
            context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val chargeCounter: Int =
            mBatteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)
        val capacity: Int =
            mBatteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        return if (chargeCounter == Int.MIN_VALUE || capacity == Int.MIN_VALUE) 0 else (chargeCounter / capacity * 100).toLong()
    }
}
