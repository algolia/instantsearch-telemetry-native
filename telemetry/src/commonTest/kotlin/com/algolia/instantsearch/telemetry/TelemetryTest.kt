package com.algolia.instantsearch.telemetry

import com.algolia.instantsearch.telemetry.ComponentParam.Client
import com.algolia.instantsearch.telemetry.ComponentParam.Facets
import com.algolia.instantsearch.telemetry.ComponentParam.IndexName
import com.algolia.instantsearch.telemetry.ComponentParam.SelectionMode
import com.algolia.instantsearch.telemetry.ComponentParam.Undefined
import com.algolia.instantsearch.telemetry.ComponentType.FacetList
import com.algolia.instantsearch.telemetry.ComponentType.HitsSearcher
import kotlin.test.Test
import kotlin.test.assertEquals

class TelemetryTest {

    @Test
    fun schemaBuildTest() {
        Telemetry.shared.traceConnector(FacetList, setOf(Facets, SelectionMode))
        Telemetry.shared.trace(HitsSearcher, setOf(Client, IndexName, Undefined))
        Telemetry.shared.traceConnector(HitsSearcher, setOf(Client, IndexName))

        val schema = Telemetry.shared.schema()
        assertEquals(2, schema?.components?.size)
        assertEquals(1, schema?.components?.count { it.type == HitsSearcher })
        assertEquals(3, schema?.components?.first { it.type == HitsSearcher }?.parameters?.size)
        assertEquals(true, schema?.components?.first { it.type == HitsSearcher }?.isConnector)
    }
}
