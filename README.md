# plist-gen
A small Swift CLI tool that is essentially a callable wrapper for `PropertyListSerialization`. It allows you to convert binary/xml plist/JSON/YML files to binary/xml plist files. I mostly made this for creating Info.plist files from yml files.

## Usage:
```sh
USAGE: plist-gen <input> [<output>] [--format <format>]

ARGUMENTS:
  <input>                 Input file to convert (JSON, YAML, or plist)
  <output>                Output Info.plist file to generate (default: Info.plist)

OPTIONS:
  --format <format>       Output format of the Info.plist file: binary or xml (default: binary)
  -h, --help              Show help information.
```

### Examples:
```sh
plist-gen Info.yml # Will create Info.plist as a bplist
plist-gen Info.yml --format xml # Will create Info.plist as an xml file
plist-gen Info.plist # Assuming this is an xml plist, it will be overwritten by a bplist
plist-gen item.json --format xml item.plist # An example of all arguments passed
```
