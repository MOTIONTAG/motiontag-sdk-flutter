package de.motiontag.motiontag_example

import android.app.Application
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.core.app.NotificationCompat
import de.motiontag.fluttertracker.MotionTagWrapper

private const val NOTIFICATION_CHANNEL_ID = "motiontag"
private const val NOTIFICATION_CHANNEL_NAME = "MotionTag"
private const val NOTIFICATION_CHANNEL_DESCRIPTION = "Test MotionTag notification channel"
private const val NOTIFICATION_CONTENT_TITLE = "MotionTag"
private const val NOTIFICATION_CONTENT_TEXT = "tracking"

class MainApplication : Application() {

  override fun onCreate() {
    super.onCreate()

    MotionTagWrapper.initialize(
      this,
      isWifiOnlyDataTransfer = false,
      notification = createNotificationAndNotificationChannel()
    )
  }

  /**
   * Creates a [Notification] and a [NotificationChannel] if it is required by the current Android
   * level
   */
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
      .setPriority(NotificationCompat.PRIORITY_LOW)
      .build()
  }
}
