import com.algolia.instantsearch.telemetry.Schema
import kotlinx.serialization.protobuf.schema.ProtoBufSchemaGenerator

public fun Schema.generate() {
    ProtoBufSchemaGenerator
}
