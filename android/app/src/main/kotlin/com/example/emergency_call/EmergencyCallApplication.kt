package com.b1nar10.emergency_call

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.app.FlutterApplication

class EmergencyCallApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                NotificationChannel("messages", "messages", NotificationManager.IMPORTANCE_LOW)
            val manager =  getSystemService(NotificationManager::class.java)

            manager.createNotificationChannel(channel)
        }
    }
}