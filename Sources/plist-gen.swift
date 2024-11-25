import Foundation

import ArgumentParser
import Yams

@main
struct PlistGen: ParsableCommand {
    enum PFormat: String, ExpressibleByArgument {
        case binary, xml

        var format: PropertyListSerialization.PropertyListFormat {
            switch self {
            case .binary: return .binary
            case .xml: return .xml
            }
        }
    }
    
    @Argument(help: "Input file to convert (JSON, YAML, or plist)")
    var input: String

    @Argument(help: "Output plist file to generate")
    var output: String = "Info.plist"

    @Option(help: "Output format of the plist file: binary or xml")
    var format: PFormat = .binary

    private var fileManager: FileManager { .default }
    private var fileURL: URL { URL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent(input) }
    private var encoded: String? { try? String(contentsOf: fileURL, encoding: .utf8) }
    
    var decodedFile: [String: Any] {
        get throws {
            if let encoded {
                if let decodedJSON = try? decodeJSON(encoded) { return decodedJSON }
                if let decodedYAML = try? decodeYAML(encoded) { return decodedYAML }
            }
            if let decodedPlist = try? decodePlist(fileURL) { return decodedPlist }
            
            throw ValidationError("Failed to decode the input file. Supported formats are JSON, YAML, and plist.")
        }
    }

    mutating func run() throws {
        try PropertyListSerialization.data(fromPropertyList: try decodedFile.sorted { $0.key < $1.key }, format: format.format, options: 0).write(to: URL(fileURLWithPath: output))
    }

    func decodeJSON(_ encoded: String) throws -> [String: Any]? { try JSONSerialization.jsonObject(with: encoded.data(using: .utf8) ?? Data(), options: []) as? [String: Any] }
    func decodeYAML(_ encoded: String) throws -> [String: Any]? { try Yams.load(yaml: encoded) as? [String: Any] }
    func decodePlist(_ path: URL) throws -> [String: Any]? { try PropertyListSerialization.propertyList(from: Data(contentsOf: path), options: [], format: nil) as? [String: Any] }
}
