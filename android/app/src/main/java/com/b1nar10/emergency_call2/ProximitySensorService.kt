package com.b1nar10.emergency_call2

import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

class ProximitySensorService : Service() {

    lateinit var sensorManager: SensorManager
    private lateinit var proximitySensor: Sensor


    // calling the sensor event class to detect
    // the change in data when sensor starts working.
    private val proximitySensorEventListener = object : SensorEventListener {

        override fun onSensorChanged(event: SensorEvent?) {
            // check if the sensor type is proximity sensor.
            if (event?.sensor?.type == Sensor.TYPE_PROXIMITY) {
                if (event.values[0] == 0.0f) {
                    // Object is close
                    Log.d("onSensorChanged", "Object near")
                    launchNotification()
                } else {
                    Log.d("onSensorChanged", "Object far")
                }
            }
        }

        override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
            // method to check accuracy changed in sensor.
        }
    }

    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notification = NotificationCompat.Builder(this, "messages")
                .setContentText("Listening for proximity")
                .setContentTitle("Proximity listener running...")
                .setSmallIcon(R.mipmap.ic_launcher)

            startForeground(101, notification.build())
        }

        registerProximityListener()
    }

    private fun registerProximityListener() {
        // calling sensor service.
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager

        // from sensor service we are
        // calling proximity sensor
        proximitySensor = sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY)

        // handling the case if the proximity
        // sensor is not present in users device.
        sensorManager.registerListener(
            proximitySensorEventListener,
            proximitySensor,
            SensorManager.SENSOR_DELAY_NORMAL
        )
    }

    private fun launchNotification() {
        val intent = Intent(this, MainActivity::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notification = NotificationCompat.Builder(this, "messages")
                .setContentText("Listening for proximity")
                .setContentTitle("Proximity listener running...")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE))

            val notificationManager: NotificationManager =
                getSystemService(NOTIFICATION_SERVICE) as NotificationManager

            notificationManager.notify(0, notification.build())
        }
    }


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}