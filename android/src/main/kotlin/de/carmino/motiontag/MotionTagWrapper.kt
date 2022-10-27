package de.carmino.motiontag

import android.app.Application
import de.motiontag.tracker.MotionTag
import de.motiontag.tracker.Settings

object MotionTagWrapper {
  private val motionTag = MotionTag.getInstance()

  fun initialize(
    application: Application,
    notification: android.app.Notification,
    isWifiOnlyDataTransfer: Boolean
  ) {
    val settings = Settings(notification, isWifiOnlyDataTransfer)
    motionTag.initialize(application, settings, MotionTagCallbackDelegate)
  }
}
