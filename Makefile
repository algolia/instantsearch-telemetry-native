generate:
	./gradlew generate
	protoc --swift_out=./Sources/InstantSearchTelemetry --swift_opt=Visibility=Public telemetry.proto
        
