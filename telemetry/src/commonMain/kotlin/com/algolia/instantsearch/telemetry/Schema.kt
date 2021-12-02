package com.algolia.instantsearch.telemetry

import kotlinx.serialization.Serializable
import kotlinx.serialization.protobuf.ProtoBuf
import kotlinx.serialization.protobuf.ProtoNumber

@Serializable
public data class Schema(
    @ProtoNumber(700) val components: List<Component> = emptyList()
)

public fun Schema.toByteArray(): ByteArray {
    return ProtoBuf.encodeToByteArray(Schema.serializer(), this)
}
