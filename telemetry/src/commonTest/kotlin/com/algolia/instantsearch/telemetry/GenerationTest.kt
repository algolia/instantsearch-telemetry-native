package com.algolia.instantsearch.telemetry

import kotlin.test.Test
import kotlinx.serialization.protobuf.schema.ProtoBufSchemaGenerator

class GenerationTest {


    @Test
    fun testGenerate() {
        val output = ProtoBufSchemaGenerator.generateSchemaText(Schema.serializer().descriptor)
        println(output)
    }
}
