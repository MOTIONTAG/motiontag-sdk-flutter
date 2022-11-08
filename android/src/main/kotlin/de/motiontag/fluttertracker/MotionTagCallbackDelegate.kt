package de.motiontag.fluttertracker

import de.motiontag.tracker.Event
import de.motiontag.tracker.MotionTag

object MotionTagCallbackDelegate : MotionTag.Callback {
  private val delegates = mutableSetOf<MotionTag.Callback>()

  fun register(delegate: MotionTag.Callback) {
    delegates.add(delegate)
  }

  fun unregister(delegate: MotionTag.Callback): Boolean {
    return delegates.remove(delegate)
  }

  override fun onEvent(event: Event) {
    delegates.forEach { it.onEvent(event) }
  }
}
