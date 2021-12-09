package com.algolia.instantsearch.telemetry

import com.algolia.instantsearch.telemetry.ComponentParam.Client
import com.algolia.instantsearch.telemetry.ComponentParam.Facets
import com.algolia.instantsearch.telemetry.ComponentParam.IndexName
import com.algolia.instantsearch.telemetry.ComponentParam.SelectionMode
import com.algolia.instantsearch.telemetry.ComponentType.FacetList
import com.algolia.instantsearch.telemetry.ComponentType.HitsSearcher
import kotlinx.serialization.decodeFromByteArray
import kotlinx.serialization.encodeToHexString
import kotlinx.serialization.protobuf.ProtoBuf
import kotlin.test.Test
import kotlin.test.assertEquals

class SerializationTest {

    @Test
    fun serializationTest() {
        Telemetry.trace(HitsSearcher, setOf(Client, IndexName))
        Telemetry.traceConnector(FacetList, setOf(Facets, SelectionMode))
        val schema = Telemetry.schema() ?: error("schema should not be empty")
        val bytes = schema.toByteArray()
        val decoded = ProtoBuf.decodeFromByteArray<Schema>(bytes)
        val hex = "e22b0cc02501c82506c8250dd02500e22b0cc02508c82507c82518d02501"
        assertEquals(hex, ProtoBuf.encodeToHexString(Schema.serializer(), schema))
        assertEquals(schema, decoded)
    }
}
