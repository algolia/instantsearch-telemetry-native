package com.algolia.instantsearch.telemetry.internal

import com.algolia.instantsearch.telemetry.Component
import com.algolia.instantsearch.telemetry.ComponentParam
import com.algolia.instantsearch.telemetry.ComponentType
import com.algolia.instantsearch.telemetry.Schema
import com.algolia.instantsearch.telemetry.Telemetry
import kotlinx.atomicfu.atomic
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

/**
 * Default [Telemetry] implementation.
 *
 * Read operation are sync, write operations are async (using [scope]).
 */
internal class DefaultTelemetry(private val scope: CoroutineScope) : Telemetry {

    private val components: MutableMap<ComponentType, DataContainer> = mutableMapOf()
    private val _enabled = atomic(true)
    override var enabled: Boolean by _enabled

    override fun trace(componentType: ComponentType, componentParams: Set<ComponentParam>) {
        traceComponent(componentType = componentType, componentParams = componentParams)
    }

    override fun traceConnector(componentType: ComponentType, componentParams: Set<ComponentParam>) {
        traceComponent(componentType = componentType, componentParams = componentParams, isConnector = true)
    }

    override fun traceDeclarative(componentType: ComponentType) {
        traceComponent(componentType = componentType, isDeclarative = true)
    }

    private fun traceComponent(
        componentType: ComponentType,
        componentParams: Set<ComponentParam> = emptySet(),
        isConnector: Boolean? = null,
        isDeclarative: Boolean? = null
    ) {
        if (!enabled) return
        scope.launch {
            val current = components[componentType]
            val params = mergeParams(current, componentParams)
            val connector = isConnector ?: current?.isConnector ?: false
            val declarative = isDeclarative ?: current?.isDeclarative ?: false
            components[componentType] = DataContainer(params, connector, declarative)
        }
    }

    override fun schema(): Schema? {
        if (!enabled) return null
        val componentsList = components.map { (type, data) ->
            Component(type, data.params, data.isConnector, data.isDeclarative)
        }
        return Schema(componentsList)
    }

    override fun clear() {
        scope.launch {
            components.clear()
        }
    }

    /**
     * Merges given [ComponentParam] set with given [DataContainer]'s params.
     */
    private fun mergeParams(current: DataContainer?, componentParams: Set<ComponentParam>): Set<ComponentParam> {
        if (current == null) return componentParams
        return componentParams + current.params
    }

    /**
     * Component Data Container.
     */
    private data class DataContainer(
        val params: Set<ComponentParam>,
        val isConnector: Boolean,
        val isDeclarative: Boolean,
    )
}
