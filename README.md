# InstantSearch Native Telemetry


To generate `.proto` specification and Swift telemetry telemetry execute:

```sh
make generate
```

## Telemetry parser tool

To build telemetry parser tool execute:

```sh
make build-parser
```

Parse telemetry string

```sh
tmparser decode H4sIAAAAAAAAE3ukzXNAVfCEKt8JVZkLqgyPtNkOqIpcUGUEAJ
```

To parse telemetry .csv file with format `ApplicationID, user-agents`, execute: 

```sh
tmparser scan path-to-log-file.csv
```
