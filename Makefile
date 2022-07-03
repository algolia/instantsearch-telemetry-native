# generate Kotlin sources based on telemetry.proto
generate:
	./gradlew generate
	protoc --swift_out=./Sources/InstantSearchTelemetry --swift_opt=Visibility=Public telemetry.proto

# build telemetry parser command line tool and move it to /usr/local/bin with name tmparser
build-parser:
	swift build -c release
	sudo cp -f .build/release/Parser /usr/local/bin/tmparser

# fetch user-agents data from RedShift database and transform it
fetch-telemetry:
	psql "host=${TELEMETRY_DB_HOST} dbname=${TELEMETRY_DB_NAME} port=${TELEMETRY_DB_PORT} user=${TELEMETRY_DB_USER} password=${TELEMETRY_DB_PASSWORD}" --csv -f telemetry.sql > tmp
	tmparser scan tmp > telemetry$(shell date +'%d.%m.%Y').csv
	rm tmp
