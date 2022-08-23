package com.algolia.instantsearch.telemetry

/**
 * Telemetry instance provider.
 */
public interface TelemetryProvider {

    /**
     * Get [Telemetry] instance.
     */
    public val shared: Telemetry

    /**
     * Set [Telemetry] instance.
     */
    public fun set(telemetry: Telemetry)
}
