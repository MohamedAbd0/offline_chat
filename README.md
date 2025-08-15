# Offline Chat - Flutter macOS Desktop App

A production-ready Flutter macOS desktop application that clones ChatGPT's UX but uses a local Ollama model as the backend. Built with Clean Architecture, BLoC state management, and modern Flutter practices.

## Features

### 🎯 Core Features

- **ChatGPT-like UI**: Familiar sidebar with chat list, message bubbles, and clean interface
- **Local AI Backend**: Uses Ollama for completely offline AI conversations
- **Real-time Streaming**: Live streaming responses with typing indicators
- **Chat Management**: Create, rename, delete, and search through conversations
- **Persistent Storage**: Encrypted local database using Isar
- **File Attachments**: Support for images, PDFs, and text files (Vision capabilities)
- **Settings Management**: Configurable Ollama endpoint, model selection, and preferences

### 🏗️ Architecture Features

- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **BLoC State Management**: Reactive state management with flutter_bloc
- **Dependency Injection**: Service locator pattern with get_it
- **Encrypted Database**: Isar database with built-in encryption
- **HTTP Client**: Dio with proper error handling and timeouts
- **Routing**: Go Router for declarative navigation

### 🎨 User Experience

- **Keyboard Shortcuts**:
  - `Cmd+N`: New chat
  - `Cmd+F`: Search chats
  - `Cmd+K`: Focus message composer
  - `Esc`: Stop streaming
  - `Enter`: Send message
  - `Shift+Enter`: New line
- **Drag & Drop**: File attachments support
- **Responsive Design**: Adapts to different window sizes
- **Dark/Light Theme**: System theme support

## Prerequisites

### 1. Install Ollama

```bash
# macOS (using Homebrew)
brew install ollama

# Or download from https://ollama.ai
```

### 2. Pull a Model

```bash
# Start Ollama service
ollama serve

# Pull a model (in another terminal)
ollama pull llama3.2:3b

# Or other models like:
# ollama pull llama3.2:1b    # Smaller, faster
# ollama pull llama3.1:8b    # Larger, more capable
# ollama pull llava:7b       # Vision-capable model
```

### 3. Flutter Development Setup

- Flutter SDK 3.8.1 or higher
- Xcode for macOS development
- FVM (Flutter Version Management) - recommended

## Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd offline_chat
```

### 2. Install Dependencies

```bash
# If using FVM
fvm flutter pub get

# Or with regular Flutter
flutter pub get
```

### 3. Generate Code

```bash
# Generate Isar database schemas
fvm dart run build_runner build --delete-conflicting-outputs
```

### 4. Configure Settings

Edit `assets/config/app_config.json`:

```json
{
  "baseUrl": "http://localhost:11434",
  "fixedModel": "llama3.2:3b",
  "keepAlive": "5m",
  "visionEnabled": true
}
```

### 5. Run the App

```bash
# Make sure Ollama is running
ollama serve

# Run the Flutter app
fvm flutter run -d macos
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── di/                         # Dependency injection
│   └── injector.dart
├── core/                       # Core utilities and config
│   ├── config/app_config.dart
│   ├── errors.dart
│   └── utils/
│       ├── ldjson_parser.dart
│       ├── base64_image.dart
│       ├── pdf_extract.dart
│       ├── file_pick.dart
│       └── markdown_sanitizer.dart
├── data/                       # Data layer
│   ├── datasources/
│   │   ├── remote/ollama_api.dart
│   │   └── local/isar_db.dart
│   ├── dtos/                   # Data transfer objects
│   ├── mappers/                # Entity ↔ DTO mappers
│   └── repositories/
│       └── chat_repository_impl.dart
├── domain/                     # Business logic layer
│   ├── entities/               # Domain models
│   ├── repositories/           # Repository interfaces
│   └── usecases/               # Business use cases
└── presentation/               # UI layer
    ├── routes/app_router.dart
    ├── blocs/                  # BLoC state management
    ├── pages/                  # Screen widgets
    └── widgets/                # Reusable UI components
```

## Configuration

### App Configuration

The app uses a JSON configuration file at `assets/config/app_config.json`:

- `baseUrl`: Ollama server endpoint (default: http://localhost:11434)
- `fixedModel`: Model name to use (default: llama3.2:3b)
- `keepAlive`: How long to keep model in memory (default: 5m)
- `visionEnabled`: Enable image processing capabilities (default: true)

### Runtime Settings

Users can modify settings through the Settings page:

- Change Ollama server URL
- Switch between available models
- Configure keep-alive duration
- Toggle vision capabilities

## Ollama Integration

### API Endpoints Used

- `POST /api/chat` - Streaming and non-streaming chat completions
- Supports both streaming (LDJSON) and single response modes

### Error Handling

- Connection refused → User-friendly "Ollama not running" message
- HTTP 412/426 → "Requires newer Ollama version" message
- Timeout handling for both connect and receive operations
- Graceful degradation for network issues

### Streaming Implementation

- Uses LDJSON (Line-Delimited JSON) parsing
- Real-time message updates as tokens arrive
- Cancellable streams with proper cleanup
- Persistent partial content saves (survives app restarts)

## Database Schema

### Isar Collections

- **ChatDto**: Chat metadata (id, title, timestamps)
- **MessageDto**: Individual messages (role, content, chat relationship)
- **AttachmentDto**: File attachments (type, path, metadata)
- **SettingsDto**: App configuration (singleton pattern)

### Data Relationships

- One-to-many: Chat → Messages
- One-to-many: Message → Attachments
- Indexed queries for performance

## Security Considerations

### Network Security (ATS)

The app includes App Transport Security (ATS) configuration for local development:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**Production Note**: For production deployment, configure specific ATS exceptions instead of allowing arbitrary loads.

### Local Data

- All conversations stored locally (never sent to external servers)
- Database encryption ready (currently disabled for development)
- Secure storage for encryption keys via macOS Keychain

## Development Guidelines

### Code Standards

- Null-safety enabled
- Strict linting with flutter_lints
- No business logic in widgets
- Small, testable classes
- Repository pattern for data access

### Testing Strategy

- Unit tests for use cases and repositories
- Widget tests for UI components
- Integration tests for critical user flows
- Mocking with get_it for isolated testing

### Performance Considerations

- Lazy-loaded dependencies
- Efficient message pagination
- Optimized database queries with indexes
- Memory management for large conversations

## Troubleshooting

### Common Issues

**1. "Ollama not running" error**

```bash
# Start Ollama service
ollama serve
```

**2. Model not found**

```bash
# Pull the required model
ollama pull llama3.2:3b
```

**3. Build runner issues**

```bash
# Clean and regenerate
fvm flutter clean
fvm flutter pub get
fvm dart run build_runner clean
fvm dart run build_runner build --delete-conflicting-outputs
```

**4. Database issues**

- Delete app data: `~/Library/Containers/com.example.offlineChat/`
- Restart app to recreate database

### Logs and Debugging

- Flutter logs: Use `fvm flutter logs` for runtime debugging
- Ollama logs: Check Ollama service logs for API issues
- Network debugging: Use Flutter Inspector or Dio interceptors

## Roadmap

### Planned Features

- [ ] Plugin architecture for custom models
- [ ] Export/import chat functionality
- [ ] Advanced file processing (more formats)
- [ ] Voice input/output
- [ ] Multiple chat windows
- [ ] Custom themes
- [ ] Performance analytics

### Known Limitations

- PDF text extraction is placeholder (needs real implementation)
- No voice/audio support yet
- Limited to text-based models (vision support planned)
- macOS only (Windows/Linux support possible)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the existing code structure and standards
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:

1. Check the troubleshooting section
2. Review existing GitHub issues
3. Create a new issue with detailed reproduction steps

---

**Built with ❤️ using Flutter and Clean Architecture principles**
