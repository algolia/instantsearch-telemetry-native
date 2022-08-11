package com.algolia.instantsearch.telemetry

import kotlinx.atomicfu.atomic
import kotlinx.atomicfu.updateAndGet

/**
 * Telemetry instance provider.
 */
public object TelemetryProvider {

    private val ref = atomic(Telemetry())

    /** Get [Telemetry] instance */
    public fun get(): Telemetry = ref.value

    /** Set [Telemetry] instance */
    public fun set(telemetry: Telemetry): Telemetry = ref.updateAndGet { telemetry }
}
