# generate Kotlin sources based on telemetry.proto
generate:
	./gradlew generate
	protoc --swift_out=./Sources/InstantSearchTelemetry --swift_opt=Visibility=Public telemetry.proto

# build telemetry parser command line tool and move it to /usr/local/bin with name tmparser
build-parser:
	swift build -c release
	cp -f .build/release/Parser /usr/local/bin/tmparser
