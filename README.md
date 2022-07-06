# InstantSearch Native Telemetry


To generate `.proto` specification and Swift telemetry telemetry execute:

```sh
make generate
```

## Telemetry parser tool

Build telemetry parser tool (Swift 5.5 is required)

```sh
make build-parser
```

Parse telemetry base64 encoded gzipped string

```sh
tmparser decode H4sIAAAAAAAAE3ukzXNAVfCEKt8JVZkLqgyPtNkOqIpcUGUEAJ
```

Parse telemetry .csv file with format `application_id,encoded_telemetry,user_agents`:

```sh
tmparser scan path-to-log-file.csv
```


## Fetch telemetry data

1. Make sure your environment provides the following variables for database connection

- TELEMETRY_DB_HOST
- TELEMETRY_DB_NAME
- TELEMETRY_DB_PORT
- TELEMETRY_DB_USER
- TELEMETRY_DB_PASSWORD

2. Build parser tool by launching `make build-parser` command 
3. Launch the telemetry fetching: `make fetch-telemetry`
4. The new csv file with name `telemetry%date%.csv` might be created
