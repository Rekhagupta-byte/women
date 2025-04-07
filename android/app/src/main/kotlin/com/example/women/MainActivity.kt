package com.example.women

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.telephony.SmsManager
import android.widget.Toast
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sendSms"
    private val SMS_PERMISSION_CODE = 101

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val phoneNumber = call.argument<String>("phoneNumber")
                val message = call.argument<String>("message")

                if (phoneNumber != null && message != null) {
                    if (ActivityCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
                        sendSMS(phoneNumber, message)
                        result.success("📩 SMS Sent!")
                    } else {
                        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.SEND_SMS), SMS_PERMISSION_CODE)
                        result.error("PERMISSION_DENIED", "SMS permission not granted", null)
                    }
                } else {
                    result.error("ERROR", "Invalid phone number or message", null)
                }
            }
        }
    }

   private fun sendSMS(phoneNumber: String, message: String) {
    try {
        val smsManager = SmsManager.getDefault()
        val parts = smsManager.divideMessage(message)
        smsManager.sendMultipartTextMessage(phoneNumber, null, parts, null, null)
        Toast.makeText(this, "📩 SMS Sent Successfully!", Toast.LENGTH_SHORT).show()
    } catch (e: Exception) {
        Toast.makeText(this, "❌ SMS Failed: ${e.message}", Toast.LENGTH_LONG).show()
    }
}

}
