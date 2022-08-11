package com.algolia.instantsearch.telemetry

import com.algolia.instantsearch.telemetry.ComponentParam.Client
import com.algolia.instantsearch.telemetry.ComponentParam.Facets
import com.algolia.instantsearch.telemetry.ComponentParam.IndexName
import com.algolia.instantsearch.telemetry.ComponentParam.SelectionMode
import com.algolia.instantsearch.telemetry.ComponentParam.Undefined
import com.algolia.instantsearch.telemetry.ComponentType.FacetList
import com.algolia.instantsearch.telemetry.ComponentType.HitsSearcher
import com.algolia.instantsearch.telemetry.ComponentType.SearchBox
import com.algolia.instantsearch.telemetry.internal.DefaultTelemetry
import kotlinx.coroutines.delay
import kotlinx.coroutines.test.runTest
import kotlin.test.Test
import kotlin.test.assertEquals

class TelemetryTest {

    @Test
    fun schemaBuildTest() = runTest {
        val telemetry = DefaultTelemetry(scope = this)
        telemetry.traceConnector(FacetList, setOf(Facets, SelectionMode))
        telemetry.trace(HitsSearcher, setOf(Client, IndexName, Undefined))
        telemetry.traceConnector(HitsSearcher, setOf(Client, IndexName))
        telemetry.traceDeclarative(SearchBox)
        delay(100)

        val schema = telemetry.schema()
        assertEquals(3, schema?.components?.size)
        assertEquals(1, schema?.components?.count { it.type == HitsSearcher })
        assertEquals(3, schema?.components?.first { it.type == HitsSearcher }?.parameters?.size)
        assertEquals(true, schema?.components?.first { it.type == HitsSearcher }?.isConnector)
        assertEquals(true, schema?.components?.first { it.type == SearchBox }?.isDeclarative)
    }
}
