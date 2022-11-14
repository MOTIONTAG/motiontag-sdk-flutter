package de.motiontag.motiontag_sdk_example

import android.app.Application
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.core.app.NotificationCompat
import de.motiontag.fluttertracker.MotionTagWrapper

private const val NOTIFICATION_CHANNEL_ID = "MOTIONTAG"
private const val NOTIFICATION_CHANNEL_NAME = "MOTIONTAG"
private const val NOTIFICATION_CHANNEL_DESCRIPTION = "MOTIONTAG SDK example notification channel"
private const val NOTIFICATION_CONTENT_TITLE = "MOTIONTAG SDK example"
private const val NOTIFICATION_CONTENT_TEXT = "Tracking is active"

// This class must be registered in the AndroidManifest.xml
// https://developer.android.com/reference/android/app/Application
class MainApplication : Application() {

  override fun onCreate() {
    super.onCreate()

    // The MOTIONTAG Android SDK must be initialized here.
    MotionTagWrapper.initialize(this, notification = createNotificationAndNotificationChannel())
  }


 // Creates a Notification and a NotificationChannel that will be displayed when the device is actively collecting sensor information
  private fun createNotificationAndNotificationChannel(): Notification {
    // On newer Android we need a NotificationChannel first
    // https://developer.android.com/training/notify-user/channels
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val importance = NotificationManager.IMPORTANCE_LOW

      val channel =
        NotificationChannel(NOTIFICATION_CHANNEL_ID, NOTIFICATION_CHANNEL_NAME, importance)
      channel.description = NOTIFICATION_CHANNEL_DESCRIPTION

      val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
      notificationManager.createNotificationChannel(channel)
    }

    return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
      .setContentTitle(NOTIFICATION_CONTENT_TITLE)
      .setContentText(NOTIFICATION_CONTENT_TEXT)
      .setSmallIcon(R.drawable.ic_foreground_notification)
      .setPriority(NotificationCompat.PRIORITY_LOW)
      .build()
  }
}
