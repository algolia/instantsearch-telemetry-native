package com.algolia.instantsearch.telemetry

import com.algolia.instantsearch.telemetry.ComponentParam.Client
import com.algolia.instantsearch.telemetry.ComponentParam.Facets
import com.algolia.instantsearch.telemetry.ComponentParam.IndexName
import com.algolia.instantsearch.telemetry.ComponentParam.SelectionMode
import com.algolia.instantsearch.telemetry.ComponentType.FacetList
import com.algolia.instantsearch.telemetry.ComponentType.HitsSearcher
import com.algolia.instantsearch.telemetry.ComponentType.SearchBox
import com.algolia.instantsearch.telemetry.internal.DefaultTelemetry
import kotlinx.coroutines.delay
import kotlinx.coroutines.test.runTest
import kotlinx.serialization.decodeFromByteArray
import kotlinx.serialization.encodeToHexString
import kotlinx.serialization.protobuf.ProtoBuf
import kotlin.test.Test
import kotlin.test.assertEquals

class SerializationTest {

    @Test
    fun serializationTest() = runTest {
        val telemetry = DefaultTelemetry(scope = this)
        telemetry.trace(HitsSearcher, setOf(Client, IndexName))
        telemetry.traceConnector(FacetList, setOf(Facets, SelectionMode))
        telemetry.traceDeclarative(SearchBox)
        delay(100)

        val schema = telemetry.schema() ?: error("schema should not be empty")
        val bytes = schema.toByteArray()
        val decoded = ProtoBuf.decodeFromByteArray<Schema>(bytes)
        val hex = "e22b0fc02501c82506c8250dd02500d82500e22b0fc02508c82507c82518d02501d82500e22b09c02514d02500d82501"

        assertEquals(hex, ProtoBuf.encodeToHexString(Schema.serializer(), schema))
        assertEquals(schema, decoded)
    }
}
