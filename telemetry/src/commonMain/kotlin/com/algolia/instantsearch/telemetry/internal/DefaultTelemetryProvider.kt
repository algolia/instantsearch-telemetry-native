package com.algolia.instantsearch.telemetry.internal

import com.algolia.instantsearch.telemetry.Telemetry
import com.algolia.instantsearch.telemetry.TelemetryProvider
import kotlinx.atomicfu.atomic
import kotlinx.atomicfu.updateAndGet

/**
 * Default [TelemetryProvider] implementation.
 */
internal object DefaultTelemetryProvider : TelemetryProvider {

    private val ref = atomic(Telemetry())

    override val shared: Telemetry get() = ref.value

    override fun set(telemetry: Telemetry) {
        ref.updateAndGet { telemetry }
    }
}
