package com.b1nar10.emergency_call2

import android.app.Service
import android.content.Intent
import android.location.Location
import android.os.IBinder
import android.os.Looper
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import org.json.JSONObject
import java.io.IOException
import java.util.concurrent.TimeUnit

class LocationService() : Service() {

    private var locationClient: FusedLocationProviderClient? = null
    private lateinit var locationCallback: LocationCallback

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        locationClient = LocationServices.getFusedLocationProviderClient(this)
        requestLocationUpdates(intent)
        return START_STICKY
    }

    private fun requestLocationUpdates(intent: Intent?) {
        val token = intent?.getStringExtra("token")
        val userPhoneId = intent?.getStringExtra("userPhoneId")

        if (!token.isNullOrEmpty() && !userPhoneId.isNullOrEmpty()) {

            val locationRequest = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 60000)
                .setWaitForAccurateLocation(false)
                .setMinUpdateIntervalMillis(60000)
                .setMaxUpdateDelayMillis(60000)
                .build()

            locationCallback = object : LocationCallback() {
                override fun onLocationResult(locationResult: LocationResult) {
                    locationResult.locations.forEach { location ->
                        sendLocationToServer(location, token = token, userPhoneId = userPhoneId)
                    }
                }
            }

            try {
                locationClient?.requestLocationUpdates(
                    locationRequest,
                    locationCallback,
                    Looper.getMainLooper()
                )
            } catch (unlikely: SecurityException) {
                // Log or handle exception
            }
        }
    }

    fun sendLocationToServer(location: Location, token: String, userPhoneId: String) {
        val client = OkHttpClient.Builder()
            .connectTimeout(10, TimeUnit.SECONDS)
            .writeTimeout(10, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .build()

        val url = "$baseApiUrl$endpoint"

        val jsonObject = JSONObject()
        jsonObject.put("token", token)
        jsonObject.put("userPhoneId", userPhoneId)
        jsonObject.put("latitude", location.latitude)
        jsonObject.put("longitude", location.longitude)
        // Add any other location details or authentication details as needed

        val requestBody = jsonObject.toString()
            .toRequestBody("application/json; charset=utf-8".toMediaTypeOrNull())

        val request = Request.Builder()
            .url(url)
            .post(requestBody)
            .addHeader("Content-Type", "application/json")
            .addHeader("x-api-key", apiKey) // Replace with your actual API key
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                // Handle failure to send location
                e.printStackTrace()
            }

            override fun onResponse(call: Call, response: Response) {
                // Handle response from the server
                if (response.isSuccessful) {
                    // Successfully sent location to the server
                    val responseBody = response.body?.string()
                    println("Server response: $responseBody")
                } else {
                    // Handle server error or invalid response
                    println("Error sending location to server. Response code: ${response.code}")
                }
            }
        })
    }

    override fun onDestroy() {
        super.onDestroy()
        locationClient?.removeLocationUpdates(locationCallback)
    }

    companion object {
        const val baseApiUrl = "https://qko8vh3p5m.execute-api.us-east-1.amazonaws.com"
        const val endpoint = "/prod/ec_save_location"
        const val apiKey = "OkPEwtJxUjaVOG6YAqPjK1kEOXvp76pG4JL2kh5k"
    }
}
