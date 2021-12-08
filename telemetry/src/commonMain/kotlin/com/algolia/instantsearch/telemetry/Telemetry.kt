package com.algolia.instantsearch.telemetry

import com.algolia.instantsearch.telemetry.internal.DefaultTelemetry

/**
 * Controller to handle components telemetry operations.
 */
public interface Telemetry {

    /**
     * Flag to enable/disable telemetry tracing.
     */
    public var enabled: Boolean

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
}

/**
 * Creates an instance of [Telemetry].
 */
public fun Telemetry(): Telemetry = DefaultTelemetry()
