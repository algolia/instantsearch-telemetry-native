import ArgumentParser

@main
struct Parser: ParsableCommand {
  
  static let configuration = CommandConfiguration(
    abstract: "A Swift command-line tool to help with InstantSearch telemetry",
    subcommands: [Decode.self, Scan.self])
  
}
