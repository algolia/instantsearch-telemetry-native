package com.algolia.instantsearch.telemetry.internal

import com.algolia.instantsearch.telemetry.Component
import com.algolia.instantsearch.telemetry.ComponentParam
import com.algolia.instantsearch.telemetry.ComponentType
import com.algolia.instantsearch.telemetry.Schema
import com.algolia.instantsearch.telemetry.Telemetry

/**
 * Default [Telemetry] implementation.
 */
internal class DefaultTelemetry : Telemetry {

    override var enabled: Boolean = true
    private val telemetryComponents = mutableMapOf<ComponentType, DataContainer>()

    override fun trace(componentType: ComponentType, componentParams: Set<ComponentParam>) {
        if (!enabled) return
        val current = telemetryComponents[componentType]
        val params = mergeParams(current, componentParams)
        val isConnector = current?.isConnector ?: false
        telemetryComponents[componentType] = DataContainer(params, isConnector)
    }

    override fun traceConnector(componentType: ComponentType, componentParams: Set<ComponentParam>) {
        if (!enabled) return
        val current = telemetryComponents[componentType]
        val params = mergeParams(current, componentParams)
        telemetryComponents[componentType] = DataContainer(params, true)
    }

    override fun schema(): Schema? {
        if (!enabled) return null
        val componentsList = telemetryComponents.map { (type, data) ->
            Component(type, data.params, data.isConnector)
        }
        return Schema(componentsList)
    }

    override fun clear() {
        telemetryComponents.clear()
    }

    private fun mergeParams(current: DataContainer?, componentParams: Set<ComponentParam>): Set<ComponentParam> {
        if (current == null) return componentParams
        return componentParams + current.params
    }

    private data class DataContainer(val params: Set<ComponentParam>, val isConnector: Boolean)
}
