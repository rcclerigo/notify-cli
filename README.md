# Terminal Notify

A native macOS CLI tool for showing modal dialogs with custom buttons and URL actions.

## Features

- Native macOS alert dialog (NSAlert)
- Centers on screen and takes focus
- Two buttons: customizable OK button and Cancel button
- Opens URL when OK is clicked
- Exit codes: 0 for OK, 1 for Cancel

## Installation

### Quick Install (Recommended)

```bash
./install.sh
```

This will build the binary and install it to `/usr/local/bin` so you can use `notify` from anywhere.

### Manual Installation

```bash
# Build the binary
make build

# Install to /usr/local/bin (requires sudo)
make install
```

### Run Locally (Without Installing)

```bash
swiftc notify.swift -o notify
./notify --title "Hello" --description "World"
```

### Uninstall

```bash
./uninstall.sh
```

## Usage

```bash
notify [OPTIONS]

Options:
  --title <text>          Alert title (default: "Notification")
  --description <text>    Alert message/description (default: "")
  --label-ok <text>       Label for OK button (default: "OK")
  --ok-opens-url <url>    URL to open when OK is clicked (optional)
  --icon <type>           Icon type (default: "info")
                          Built-in: info, warning, critical/error
                          SF Symbol: checkmark.circle.fill, gear, etc.
                          Custom: /path/to/image.png
  --help                  Show this help message
```

## Examples

### Simple notification

```bash
notify --title "Build Complete" --description "Your build finished successfully"
```

### With different icons

```bash
# Success with SF Symbol
notify --title "Build Complete" --description "All tests passed" --icon checkmark.circle.fill

# Warning
notify --title "Low Disk Space" --description "Only 2GB remaining" --icon warning

# Error
notify --title "Build Failed" --description "Compilation error in main.swift" --icon critical

# Custom SF Symbols (macOS 11+)
notify --title "Settings Updated" --description "Configuration saved" --icon gear
notify --title "Download Complete" --description "File saved to Downloads" --icon arrow.down.circle.fill
```

### With custom button and URL

```bash
notify \
  --title "Pull Request Ready" \
  --description "Your PR #123 is ready for review" \
  --label-ok "Open PR" \
  --ok-opens-url "https://github.com/user/repo/pull/123" \
  --icon checkmark.circle
```

### Open local file

```bash
notify \
  --title "Log Available" \
  --description "Build logs are ready" \
  --label-ok "View Logs" \
  --ok-opens-url "file:///tmp/build.log" \
  --icon doc.text
```

### Custom icon from file

```bash
notify \
  --title "Custom Alert" \
  --description "Using a custom icon" \
  --icon /path/to/your/icon.png
```

## Exit Codes

- `0` - OK button clicked
- `1` - Cancel button clicked

## Testing

```bash
make test
```
