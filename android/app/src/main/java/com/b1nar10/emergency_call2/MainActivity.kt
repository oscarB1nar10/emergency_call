package com.b1nar10.emergency_call2

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(
                it,
                "com.emergency_call.messages"
            ).setMethodCallHandler { call, result ->
                if (call.method.equals("startProximityService")) {
                    startProximityService()
                    result.success("Service started")
                }
            }
        }
    }

    private fun startProximityService() {
        val serviceIntent = Intent(this, ProximitySensorService::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(
                serviceIntent
            )
        } else {
            startService(serviceIntent)
        }
    }
}
