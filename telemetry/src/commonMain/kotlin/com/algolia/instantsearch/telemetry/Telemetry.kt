package com.algolia.instantsearch.telemetry

import com.algolia.instantsearch.telemetry.internal.DefaultTelemetry
import com.algolia.instantsearch.telemetry.internal.DefaultTelemetryProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers

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
     * This operation is asynchronous.
     */
    public fun trace(
        componentType: ComponentType, componentParams: Set<ComponentParam> = emptySet()
    )

    /**
     * Track a component by its [ComponentType] and [ComponentParam].
     * This operation is asynchronous.
     */
    public fun traceConnector(
        componentType: ComponentType, componentParams: Set<ComponentParam> = emptySet()
    )

    /**
     * Track a component in declarative frameworks by its [ComponentType].
     * This operation is asynchronous.
     */
    public fun traceDeclarative(componentType: ComponentType)

    /**
     * Clear and remove all components traces.
     * This operation is asynchronous.
     */
    public fun clear()

    public companion object : TelemetryProvider by DefaultTelemetryProvider
}

/**
 * Creates an instance of [Telemetry].
 *
 * @param scope coroutine scope for async operations
 */
public fun Telemetry(
    scope: CoroutineScope = CoroutineScope(context = Dispatchers.Default.limitedParallelism(1))
): Telemetry = DefaultTelemetry(scope)
