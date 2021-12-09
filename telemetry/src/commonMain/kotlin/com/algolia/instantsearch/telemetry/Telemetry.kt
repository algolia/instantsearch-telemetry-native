package com.algolia.instantsearch.telemetry

import com.algolia.instantsearch.telemetry.internal.DefaultTelemetry

/**
 * Controller to handle components telemetry operations.
 */
public interface Telemetry : Config {

    /**
     * Get telemetry [Schema].
     * Returns `null` is telemetry is not [enabled].
     */
    public fun schema(): Schema?

    /**
     * Track a component by its [ComponentType] and [ComponentParam].
     */
    public fun trace(
        componentType: ComponentType,
        componentParams: Set<ComponentParam> = emptySet()
    )

    /**
     * Track a component by its [ComponentType] and [ComponentParam].
     */
    public fun traceConnector(
        componentType: ComponentType,
        componentParams: Set<ComponentParam> = emptySet()
    )

    /**
     * Clear and remove all components traces.
     */
    public fun clear()

    /**
     * The default instance of [Telemetry].
     */
    public companion object : Telemetry by Telemetry()
}

/**
 * Creates an instance of [Telemetry].
 */
public fun Telemetry(): Telemetry = DefaultTelemetry()
