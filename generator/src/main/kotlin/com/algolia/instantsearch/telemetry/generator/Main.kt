package com.algolia.instantsearch.telemetry.generator

import com.algolia.instantsearch.telemetry.Schema
import kotlinx.serialization.protobuf.schema.ProtoBufSchemaGenerator
import java.io.File

fun main() {
    val proto = ProtoBufSchemaGenerator.generateSchemaText(
        rootDescriptor = Schema.serializer().descriptor,
        packageName = Schema::class.java.packageName
    )
    val fileName = "telemetry.proto"
    val protoFile = File(fileName)
    protoFile.printWriter().use { out -> out.write(proto) }
    println("Generated file: ${protoFile.absoluteFile}")
}
