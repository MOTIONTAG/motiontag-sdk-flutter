package de.motiontag.fluttertracker

import android.app.Application
import de.motiontag.tracker.MotionTag

object MotionTagWrapper {
    private val motionTag = MotionTag.getInstance()

    fun initialize(
        application: Application,
        notification: android.app.Notification,
    ) {
        motionTag.initialize(application, notification, MotionTagCallbackDelegate)
    }
}
