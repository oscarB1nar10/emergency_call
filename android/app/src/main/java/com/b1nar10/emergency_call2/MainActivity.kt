package com.b1nar10.emergency_call2

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.b1nar10.emergency_call2/locationService"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startLocationService" -> {
                    val token = call.argument<String>("token")
                    val userPhoneId = call.argument<String>("userPhoneId")
                    if (token != null && userPhoneId != null) {
                        // Assume LocationService is correctly defined to handle these extras
                        val intent = Intent(this, LocationService::class.java).apply {
                            putExtra("token", token)
                            putExtra("userPhoneId", userPhoneId)
                        }
                        startService(intent)
                        result.success("Location service started")
                    } else {
                        result.error("UNAVAILABLE", "Token or UserPhoneId not provided.", null)
                    }
                }
                "stopLocationService" -> {
                    val intent = Intent(this, LocationService::class.java)
                    stopService(intent)
                    result.success("Location service stopped")
                }
                else -> result.notImplemented()
            }
        }
    }
}
