# 🤖 Offline Chat - AI-Powered Desktop App

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos)
[![Ollama](https://img.shields.io/badge/Ollama-FF6B35?style=for-the-badge&logo=ollama&logoColor=white)](https://ollama.ai)

A production-ready Flutter macOS desktop application that delivers a **ChatGPT-like experience** using **local AI models**. Built with Clean Architecture, BLoC state management, and enhanced with **beautiful syntax highlighting** and **modern UI components**.

[Features](#-features) • [Installation](#-installation--setup) • [Architecture](#-architecture) • [Configuration](#-configuration) • [Screenshots](#-screenshots)

</div>

---

## ✨ Features

### 🎯 **Core Capabilities**

- **🤖 ChatGPT-like Interface**: Familiar sidebar navigation, message bubbles, and intuitive chat experience
- **🔒 100% Offline**: Uses Ollama for completely private AI conversations - no data leaves your machine
- **⚡ Real-time Streaming**: Live streaming responses with elegant typing indicators and animations
- **💬 Advanced Chat Management**: Create, rename, delete, search, and organize conversations
- **💾 Persistent Storage**: Encrypted local database with automatic conversation saving
- **📎 File Attachments**: Support for images, PDFs, and text files with vision model capabilities
- **⚙️ Flexible Configuration**: Configurable Ollama endpoints, model selection, and preferences

### � **Enhanced User Experience**

- **✨ Beautiful Code Syntax Highlighting**:

  - ChatGPT-style code blocks with language detection
  - Professional syntax highlighting using VS2015 theme
  - Interactive copy buttons with visual feedback animations
  - Enhanced snackbar toasts with modern design
  - Support for 20+ programming languages
  - Distinct inline code vs code block rendering

- **🎹 Smart Keyboard Shortcuts**:

  - `Cmd+N`: Create new chat
  - `Cmd+F`: Search through chats
  - `Cmd+K`: Focus message composer
  - `Esc`: Stop AI response streaming
  - `Enter`: Send message
  - `Shift+Enter`: Insert new line
  - `Cmd+C`: Copy code blocks (enhanced with animations)

- **🖱️ Modern Interactions**:
  - Drag & drop file attachments with visual feedback
  - Responsive design that adapts to window resizing
  - Dark/Light theme support with system integration
  - Smooth animations and transitions throughout the app
  - Interactive code block headers with copy functionality

### 🏗️ **Technical Excellence**

- **🧱 Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **🔄 BLoC State Management**: Reactive state management with flutter_bloc for predictable UI updates
- **💉 Dependency Injection**: Service locator pattern with get_it for loose coupling
- **🗄️ Secure Database**: Hive database with built-in encryption capabilities
- **🌐 Robust HTTP Client**: Dio with comprehensive error handling, timeouts, and retry logic
- **🧭 Declarative Routing**: Go Router for type-safe navigation and deep linking

## 🚀 Installation & Setup

### **📋 Prerequisites**

#### 1. **Install Ollama**

<details>
<summary>📥 <strong>macOS Installation Options</strong></summary>

**Option A: Homebrew (Recommended)**

```bash
brew install ollama
```

**Option B: Direct Download**

- Download from [https://ollama.ai](https://ollama.ai)
- Follow the installer instructions

**Option C: Manual Installation**

```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

</details>

#### 2. **Download AI Models**

```bash
# Start Ollama service (run this first!)
ollama serve

# In a new terminal, pull your desired model:

# 🚀 Fast & Lightweight (Recommended for testing)
ollama pull llama3.2:1b    # ~1.3GB - Great for quick responses

# ⚖️ Balanced Performance (Recommended for daily use)
ollama pull llama3.2:3b    # ~2.0GB - Good balance of speed & quality

# 🧠 High Performance
ollama pull llama3.1:8b    # ~4.7GB - Superior quality, slower responses

# 👁️ Vision-Enabled Models (For image processing)
ollama pull llava:7b       # ~4.1GB - Can analyze images and PDFs
ollama pull llava:13b      # ~7.3GB - Better image understanding

# 💻 Code-Specialized Models
ollama pull codellama:7b   # ~3.8GB - Optimized for programming tasks
```

#### 3. **Flutter Development Environment**

```bash
# Install FVM (Flutter Version Management) - Recommended
brew install fvm

# Or ensure you have Flutter 3.8.1+
flutter --version
```

**Required Tools:**

- ✅ Flutter SDK 3.8.1 or higher
- ✅ Xcode (for macOS development)
- ✅ Git
- ✅ VS Code or Android Studio (recommended)

---

### **⚡ Quick Start**

#### 1. **Clone & Setup**

```bash
# Clone the repository
git clone https://github.com/MohamedAbd0/offline_chat.git
cd offline_chat

# Install dependencies
fvm flutter pub get
# OR: flutter pub get

# Generate required code files
fvm dart run build_runner build --delete-conflicting-outputs
```

#### 2. **Configure the App**

Create or edit `assets/config/app_config.json`:

```json
{
  "baseUrl": "http://localhost:11434",
  "fixedModel": "llama3.2:3b",
  "keepAlive": "5m",
  "visionEnabled": true,
  "maxTokens": 4096,
  "temperature": 0.7
}
```

#### 3. **Launch the Application**

```bash
# Terminal 1: Start Ollama service
ollama serve

# Terminal 2: Run the Flutter app
fvm flutter run -d macos --release
# OR for development: fvm flutter run -d macos
```

🎉 **That's it!** The app should launch and automatically connect to your local Ollama instance.

---

### **🔧 Advanced Setup**

<details>
<summary><strong>🐳 Docker Setup (Alternative)</strong></summary>

If you prefer using Docker for Ollama:

```bash
# Run Ollama in Docker
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

# Pull a model
docker exec -it ollama ollama pull llama3.2:3b

# Update app config to use Docker endpoint
# baseUrl: "http://localhost:11434"
```

</details>

<details>
<summary><strong>🌐 Remote Ollama Setup</strong></summary>

To connect to a remote Ollama instance:

1. **Configure remote Ollama server:**

```bash
# On remote server, start Ollama with external access
OLLAMA_HOST=0.0.0.0:11434 ollama serve
```

2. **Update app configuration:**

```json
{
  "baseUrl": "http://YOUR_SERVER_IP:11434",
  "fixedModel": "llama3.2:3b"
}
```

</details>

<details>
<summary><strong>🔨 Development Build Setup</strong></summary>

For development with hot reload:

```bash
# Enable debugging
fvm flutter run -d macos --debug

# For detailed logging
fvm flutter run -d macos --debug --verbose

# Profile mode for performance testing
fvm flutter run -d macos --profile
```

</details>

## 🏗️ Architecture

### **📁 Project Structure**

```
offline_chat/
├── 📁 lib/
│   ├── 🚀 main.dart                    # Application entry point
│   ├── 📁 di/                          # 💉 Dependency Injection
│   │   └── injector.dart               # Service locator setup
│   ├── 📁 core/                        # 🛠️ Core utilities & configuration
│   │   ├── config/
│   │   │   └── app_config.dart         # App configuration management
│   │   ├── errors.dart                 # Custom error definitions
│   │   └── utils/
│   │       ├── ldjson_parser.dart      # Line-delimited JSON parser
│   │       ├── base64_image.dart       # Image encoding utilities
│   │       ├── pdf_extract.dart        # PDF text extraction
│   │       ├── file_pick.dart          # File selection utilities
│   │       └── markdown_sanitizer.dart # Safe markdown rendering
│   ├── 📁 data/                        # 🗄️ Data Access Layer
│   │   ├── datasources/
│   │   │   ├── remote/
│   │   │   │   └── ollama_api.dart     # Ollama API client
│   │   │   └── local/
│   │   │       └── hive_db.dart        # Local database implementation
│   │   ├── dtos/                       # Data Transfer Objects
│   │   │   ├── chat_dto.dart
│   │   │   ├── message_dto.dart
│   │   │   └── settings_dto.dart
│   │   ├── mappers/                    # Entity ↔ DTO conversion
│   │   │   ├── chat_mapper.dart
│   │   │   └── message_mapper.dart
│   │   └── repositories/
│   │       └── chat_repository_impl.dart # Repository implementation
│   ├── 📁 domain/                      # 🧠 Business Logic Layer
│   │   ├── entities/                   # Core business models
│   │   │   ├── chat.dart
│   │   │   ├── message.dart
│   │   │   ├── attachment.dart
│   │   │   └── settings.dart
│   │   ├── repositories/               # Repository contracts
│   │   │   └── chat_repository.dart
│   │   └── usecases/                   # Business use cases
│   │       ├── get_chats.dart
│   │       ├── send_message.dart
│   │       ├── create_chat.dart
│   │       └── stream_response.dart
│   └── 📁 presentation/                # 🎨 UI Layer
│       ├── routes/
│       │   └── app_router.dart         # Navigation configuration
│       ├── blocs/                      # 🔄 State Management
│       │   ├── chat_list/
│       │   │   ├── chat_list_bloc.dart
│       │   │   ├── chat_list_event.dart
│       │   │   └── chat_list_state.dart
│       │   ├── chat_room/
│       │   │   ├── chat_room_bloc.dart
│       │   │   ├── chat_room_event.dart
│       │   │   └── chat_room_state.dart
│       │   └── settings/
│       │       ├── settings_bloc.dart
│       │       ├── settings_event.dart
│       │       └── settings_state.dart
│       ├── pages/                      # 📱 Screen Components
│       │   ├── main_page.dart          # Main chat interface
│       │   ├── chat_room_page.dart     # Individual chat room
│       │   ├── settings_page.dart      # App settings
│       │   └── welcome_page.dart       # Welcome screen
│       └── widgets/                    # 🧩 Reusable UI Components
│           ├── message_bubble.dart     # Chat message display
│           ├── typing_indicator.dart   # AI typing animation
│           ├── code_block.dart         # Enhanced code rendering
│           ├── copy_button.dart        # Interactive copy functionality
│           └── file_attachment.dart    # File preview widget
├── 📁 assets/
│   ├── config/
│   │   └── app_config.json             # Runtime configuration
│   └── images/                         # App icons and images
├── 📁 macos/                          # 🍎 macOS-specific configuration
├── 📁 test/                           # 🧪 Unit & Widget Tests
└── 📄 pubspec.yaml                    # Dependencies & metadata
```

### **🔧 Key Dependencies**

| Category                 | Package                  | Purpose                      |
| ------------------------ | ------------------------ | ---------------------------- |
| **State Management**     | `flutter_bloc`           | Reactive state management    |
| **Dependency Injection** | `get_it`                 | Service locator pattern      |
| **Database**             | `hive`                   | Local storage & caching      |
| **HTTP Client**          | `dio`                    | Network requests & streaming |
| **Routing**              | `go_router`              | Declarative navigation       |
| **Markdown**             | `flutter_markdown`       | Rich text rendering          |
| **Syntax Highlighting**  | `flutter_highlight`      | Code block styling           |
| **File Handling**        | `file_selector`          | File picker integration      |
| **Security**             | `flutter_secure_storage` | Encrypted key storage        |

---

## 📸 Screenshots

<div align="center">

### **🏠 Main Interface**

_Clean, ChatGPT-inspired design with sidebar navigation_

### **💬 Chat Experience**

_Real-time streaming responses with beautiful message bubbles_

### **🎨 Enhanced Code Blocks**

_Professional syntax highlighting with interactive copy buttons_

### **⚙️ Settings Panel**

_Flexible configuration for Ollama models and preferences_

### **📎 File Attachments**

_Drag & drop support for images, PDFs, and documents_

_Screenshots coming soon - the app features a modern, responsive design optimized for macOS_

</div>

## ⚙️ Configuration

### **📋 App Configuration (`app_config.json`)**

The application uses a flexible JSON configuration system located at `assets/config/app_config.json`:

```json
{
  "baseUrl": "http://localhost:11434",
  "fixedModel": "llama3.2:3b",
  "keepAlive": "5m",
  "visionEnabled": true,
  "maxTokens": 4096,
  "temperature": 0.7,
  "streamingEnabled": true,
  "requestTimeout": 30000
}
```

| Setting            | Type    | Default                  | Description                          |
| ------------------ | ------- | ------------------------ | ------------------------------------ |
| `baseUrl`          | String  | `http://localhost:11434` | Ollama server endpoint URL           |
| `fixedModel`       | String  | `llama3.2:3b`            | Default AI model to use              |
| `keepAlive`        | String  | `5m`                     | How long to keep model in memory     |
| `visionEnabled`    | Boolean | `true`                   | Enable image processing capabilities |
| `maxTokens`        | Integer | `4096`                   | Maximum response length              |
| `temperature`      | Float   | `0.7`                    | Response creativity (0.0-2.0)        |
| `streamingEnabled` | Boolean | `true`                   | Enable real-time response streaming  |
| `requestTimeout`   | Integer | `30000`                  | Request timeout in milliseconds      |

### **🔧 Runtime Settings**

Users can modify settings through the in-app Settings panel:

- **🌐 Server Configuration**: Change Ollama server URL and connection settings
- **🤖 Model Selection**: Switch between available AI models with real-time model list
- **⏱️ Performance Tuning**: Adjust keep-alive duration and timeout values
- **👁️ Feature Toggles**: Enable/disable vision capabilities and streaming
- **🎨 UI Preferences**: Theme selection and interface customization

### **🔌 Ollama Integration**

#### **API Endpoints**

| Endpoint    | Method | Purpose                                      |
| ----------- | ------ | -------------------------------------------- |
| `/api/chat` | POST   | Streaming and non-streaming chat completions |
| `/api/tags` | GET    | List available models                        |
| `/api/show` | POST   | Get model information                        |
| `/api/pull` | POST   | Download new models                          |

#### **🔄 Streaming Implementation**

- **LDJSON Parser**: Processes Line-Delimited JSON for real-time updates
- **Token-by-Token Updates**: Messages update as AI generates responses
- **Cancellable Streams**: Users can stop generation with proper cleanup
- **Persistent State**: Partial responses survive app restarts
- **Error Recovery**: Graceful handling of connection issues

#### **🛡️ Error Handling Matrix**

| Error Type         | User Message                                     | Technical Action                    |
| ------------------ | ------------------------------------------------ | ----------------------------------- |
| Connection Refused | "Ollama not running - please start the service"  | Retry with exponential backoff      |
| HTTP 412/426       | "Please update Ollama to a newer version"        | Show update instructions            |
| Timeout            | "Request timed out - trying again..."            | Automatic retry with longer timeout |
| Model Not Found    | "Model not available - please download it first" | Show model installation guide       |
| Network Error      | "Connection issue - check your network"          | Offline mode indicator              |

#### **🚀 Performance Optimizations**

- **Connection Pooling**: Reuse HTTP connections for better performance
- **Request Queuing**: Handle multiple simultaneous requests gracefully
- **Memory Management**: Efficient handling of large responses
- **Background Processing**: Non-blocking UI during AI operations

## 🗄️ Database & Storage

### **Hive Database Schema**

The application uses **Hive** for fast, encrypted local storage:

#### **Collections & Models**

```dart
// Chat metadata and organization
@HiveType(typeId: 0)
class ChatDto {
  @HiveField(0) String id;              // Unique chat identifier
  @HiveField(1) String title;           // User-defined chat title
  @HiveField(2) DateTime createdAt;     // Creation timestamp
  @HiveField(3) DateTime updatedAt;     // Last modification time
  @HiveField(4) List<String> messageIds; // References to messages
  @HiveField(5) Map<String, dynamic> metadata; // Extensible properties
}

// Individual conversation messages
@HiveType(typeId: 1)
class MessageDto {
  @HiveField(0) String id;              // Unique message identifier
  @HiveField(1) String chatId;          // Parent chat reference
  @HiveField(2) String role;            // 'user' | 'assistant' | 'system'
  @HiveField(3) String content;         // Message text content
  @HiveField(4) DateTime timestamp;     // Message creation time
  @HiveField(5) List<AttachmentDto> attachments; // File attachments
  @HiveField(6) Map<String, dynamic> metadata;   // Message properties
}

// File attachments and media
@HiveType(typeId: 2)
class AttachmentDto {
  @HiveField(0) String id;              // Unique attachment identifier
  @HiveField(1) String type;            // 'image' | 'pdf' | 'text'
  @HiveField(2) String path;            // File system path
  @HiveField(3) String name;            // Original filename
  @HiveField(4) int size;               // File size in bytes
  @HiveField(5) String mimeType;        // MIME type
  @HiveField(6) Map<String, dynamic> metadata; // File-specific data
}

// Application settings (singleton)
@HiveType(typeId: 3)
class SettingsDto {
  @HiveField(0) String baseUrl;         // Ollama server endpoint
  @HiveField(1) String currentModel;    // Active AI model
  @HiveField(2) String keepAlive;       // Model memory duration
  @HiveField(3) bool visionEnabled;     // Vision model capabilities
  @HiveField(4) bool darkMode;          // Theme preference
  @HiveField(5) Map<String, dynamic> advanced; // Advanced settings
}
```

#### **🔐 Database Security**

- **Encryption**: AES-256 encryption for sensitive data
- **Key Management**: Secure key storage via macOS Keychain
- **Data Isolation**: App sandbox prevents unauthorized access
- **Backup Safety**: Encrypted backups maintain security

#### **⚡ Performance Features**

- **Indexed Queries**: Fast lookups by chat ID, timestamp, and content
- **Lazy Loading**: Messages loaded on-demand for large conversations
- **Compression**: Efficient storage of large text content
- **Cache Management**: Automatic cleanup of old data

---

## 🛡️ Security & Privacy

### **🔒 Privacy-First Design**

- **🏠 100% Local Processing**: All conversations stay on your device
- **🚫 No Telemetry**: Zero data collection or analytics
- **🔐 Encrypted Storage**: Local database encryption with secure keys
- **🌐 No Cloud Dependencies**: Works completely offline

### **🍎 macOS Security Integration**

#### **App Transport Security (ATS)**

```xml
<!-- Development configuration -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>localhost</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

**🚨 Production Note**: For production deployment, use specific domain exceptions instead of allowing arbitrary loads.

#### **Keychain Integration**

- **🔑 Secure Key Storage**: Database encryption keys stored in macOS Keychain
- **👤 User Authentication**: Touch ID/Face ID integration for app access
- **🔒 Auto-Lock**: Automatic session timeout for security

#### **Sandbox Compliance**

- **📁 File Access**: Restricted to user-selected files and app documents
- **🌐 Network Access**: Limited to configured Ollama endpoints
- **🎥 Camera/Microphone**: Vision features use secure system APIs

### **🔧 Security Best Practices**

```dart
// Example: Secure configuration loading
class SecurityService {
  static Future<String> getEncryptionKey() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainItemAccessibility.first_unlock_this_device,
      ),
    );

    String? key = await storage.read(key: 'db_encryption_key');
    if (key == null) {
      key = generateSecureKey();
      await storage.write(key: 'db_encryption_key', value: key);
    }
    return key;
  }
}
```

## 🧪 Development & Testing

### **📋 Code Standards**

- ✅ **Null Safety**: Full null-safety compliance with strict analysis
- ✅ **Linting**: Enhanced linting rules with `flutter_lints`
- ✅ **Architecture**: Clean Architecture with clear layer separation
- ✅ **Testing**: Comprehensive unit, widget, and integration tests
- ✅ **Documentation**: Inline documentation and README maintenance

### **🏗️ Development Guidelines**

```dart
// Example: Clean Architecture pattern
abstract class ChatRepository {
  Future<List<Chat>> getChats();
  Stream<Message> sendMessage(String chatId, String content);
}

class ChatRepositoryImpl implements ChatRepository {
  final OllamaApi _api;
  final LocalDatabase _db;

  // Implementation with proper error handling
}
```

### **🧪 Testing Strategy**

| Test Type             | Coverage                                | Tools              |
| --------------------- | --------------------------------------- | ------------------ |
| **Unit Tests**        | Business logic, repositories, use cases | `test`, `mockito`  |
| **Widget Tests**      | UI components, user interactions        | `flutter_test`     |
| **Integration Tests** | End-to-end user flows                   | `integration_test` |
| **Performance Tests** | Memory usage, response times            | `flutter_driver`   |

```bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Run integration tests
fvm flutter test integration_test/
```

---

## 🛠️ Troubleshooting

### **🚨 Common Issues & Solutions**

<details>
<summary><strong>🔴 "Ollama not running" Error</strong></summary>

**Symptoms**: Connection refused, app shows offline status

**Solutions**:

```bash
# Check if Ollama is running
ps aux | grep ollama

# Start Ollama service
ollama serve

# Test connection manually
curl http://localhost:11434/api/tags

# Check for port conflicts
lsof -i :11434
```

**Advanced**:

- Check firewall settings
- Verify Ollama installation: `ollama --version`
- Try different port: `OLLAMA_HOST=0.0.0.0:11435 ollama serve`
</details>

<details>
<summary><strong>🟡 Model Not Found Error</strong></summary>

**Symptoms**: "Model xyz not available" message

**Solutions**:

```bash
# List available models
ollama list

# Pull the required model
ollama pull llama3.2:3b

# Verify model works
ollama run llama3.2:3b "Hello, how are you?"

# Check model size and disk space
df -h
```

</details>

<details>
<summary><strong>🔵 Build & Dependencies Issues</strong></summary>

**Symptoms**: Build failures, dependency conflicts

**Solutions**:

```bash
# Clean build artifacts
fvm flutter clean
rm -rf build/
rm pubspec.lock

# Reinstall dependencies
fvm flutter pub get
fvm flutter pub deps

# Regenerate generated files
fvm dart run build_runner clean
fvm dart run build_runner build --delete-conflicting-outputs

# Reset Flutter cache
fvm flutter pub cache repair
```

</details>

<details>
<summary><strong>🟣 Database & Storage Issues</strong></summary>

**Symptoms**: Data not persisting, corruption errors

**Solutions**:

```bash
# Clear app data (⚠️ Will delete all chats)
rm -rf ~/Library/Containers/com.example.offlineChat/

# Reset Hive boxes
# In app: await Hive.deleteBoxFromDisk('chats');

# Check storage permissions
# Verify app has file system access
```

</details>

<details>
<summary><strong>🟠 Performance Issues</strong></summary>

**Symptoms**: Slow responses, memory usage, UI lag

**Solutions**:

```bash
# Monitor performance
fvm flutter run --profile
# Use Flutter Inspector for memory analysis

# Check system resources
top -pid $(pgrep -f "ollama serve")

# Optimize model settings
# Reduce model size: llama3.2:1b instead of 3b
# Adjust keepAlive: "1m" for less memory usage
```

</details>

### **📊 Debug Information Collection**

When reporting issues, please include:

```bash
# System information
system_profiler SPSoftwareDataType | head -20

# Flutter environment
fvm flutter doctor -v

# Ollama status
ollama --version
ollama list

# App logs (while reproducing issue)
fvm flutter logs

# Network connectivity
curl -v http://localhost:11434/api/tags
```

---

## 🚀 Roadmap & Future Features

### **🎯 Version 2.0 Goals**

#### **🤖 AI & Models**

- [ ] **Multiple Model Support**: Run different models simultaneously
- [ ] **Custom Model Integration**: Support for fine-tuned and GGUF models
- [ ] **Model Marketplace**: Browse and install models from community
- [ ] **Voice Integration**: Speech-to-text and text-to-speech capabilities
- [ ] **Advanced Vision**: Enhanced image analysis and generation

#### **💻 Platform Expansion**

- [ ] **Windows Support**: Native Windows application
- [ ] **Linux Support**: AppImage and package manager distributions
- [ ] **iOS Version**: Mobile companion app with sync
- [ ] **Web Interface**: Browser-based chat interface

#### **🔧 Advanced Features**

- [ ] **Plugin Architecture**: Extensible functionality system
- [ ] **Workflow Automation**: Saved prompts and response templates
- [ ] **Team Collaboration**: Shared conversations and workspaces
- [ ] **API Integration**: Connect external tools and services
- [ ] **Advanced Search**: Semantic search across all conversations

#### **🎨 User Experience**

- [ ] **Custom Themes**: User-created and community themes
- [ ] **Workspace Management**: Multiple chat environments
- [ ] **Export/Import**: Backup and restore conversations
- [ ] **Markdown Editor**: Rich text input with preview
- [ ] **Code Execution**: Run code snippets directly in chat

### **📈 Performance & Scaling**

- [ ] **Distributed Computing**: Multi-machine model execution
- [ ] **GPU Acceleration**: Enhanced performance on Apple Silicon
- [ ] **Memory Optimization**: Better handling of large conversations
- [ ] **Background Processing**: Async operations and queuing

### **🔒 Enterprise Features**

- [ ] **Single Sign-On**: Corporate authentication integration
- [ ] **Audit Logging**: Comprehensive activity tracking
- [ ] **Data Governance**: Compliance and retention policies
- [ ] **Admin Dashboard**: Centralized management interface

### **📊 Analytics & Insights**

- [ ] **Usage Analytics**: Performance and feature usage metrics
- [ ] **Conversation Analysis**: Sentiment and topic analysis
- [ ] **Model Performance**: Response quality and speed tracking
- [ ] **Cost Analysis**: Resource usage and optimization suggestions

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### **🚀 Getting Started**

1. **Fork the Repository**

   ```bash
   git clone https://github.com/YourUsername/offline_chat.git
   cd offline_chat
   ```

2. **Set Up Development Environment**

   ```bash
   fvm flutter pub get
   fvm dart run build_runner build
   ```

3. **Create a Feature Branch**
   ```bash
   git checkout -b feature/amazing-new-feature
   ```

### **📝 Contribution Guidelines**

- **🏗️ Follow Architecture**: Maintain Clean Architecture patterns
- **✅ Add Tests**: Include unit tests for new functionality
- **📚 Update Documentation**: Keep README and code comments current
- **🎨 UI Consistency**: Follow existing design patterns
- **🔍 Code Review**: All changes require peer review

### **🐛 Bug Reports**

Use our issue template with:

- **Environment**: OS, Flutter version, Ollama version
- **Steps to Reproduce**: Detailed reproduction steps
- **Expected vs Actual**: What should happen vs what happens
- **Logs**: Include relevant error messages
- **Screenshots**: Visual evidence if applicable

### **💡 Feature Requests**

- Search existing issues first
- Provide detailed use case descriptions
- Include mockups or wireframes if applicable
- Consider implementation complexity
- Engage with community feedback

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Offline Chat Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 💬 Support & Community

### **🆘 Getting Help**

1. **📚 Check Documentation**: Review this README and in-app help
2. **🔍 Search Issues**: Look through [existing GitHub issues](https://github.com/YourUsername/offline_chat/issues)
3. **🐛 Report Bugs**: Create a [new issue](https://github.com/YourUsername/offline_chat/issues/new) with detailed information
4. **💡 Feature Requests**: Use the feature request template
5. **💬 Community Discussion**: Join our community channels

### **📞 Contact Channels**

- **GitHub Issues**: Primary support channel
- **Email**: support@offline-chat.dev
- **Discord**: [Join our community](https://discord.gg/offline-chat)
- **Twitter**: [@OfflineChatApp](https://twitter.com/OfflineChatApp)

### **🙏 Acknowledgments**

Special thanks to:

- **[Ollama Team](https://ollama.ai)** - For the amazing local AI platform
- **[Flutter Team](https://flutter.dev)** - For the incredible cross-platform framework
- **Contributors** - Everyone who has contributed code, ideas, and feedback
- **Community** - Beta testers and early adopters who helped shape the app

### **🌟 Show Your Support**

If you find this project helpful:

- ⭐ **Star the repository** on GitHub
- 🐛 **Report bugs** and suggest improvements
- 💻 **Contribute code** or documentation
- 📢 **Share with others** who might benefit
- ☕ **Buy us a coffee** to support development

---

<div align="center">

## 🎉 Ready to Get Started?

**[⬆️ Jump to Installation](#-installation--setup)** • **[⚙️ Configuration Guide](#-configuration)** • **[🛠️ Troubleshooting](#-troubleshooting)**

---

### **Built with ❤️ using Flutter, Clean Architecture, and the power of local AI**

**Experience ChatGPT-like conversations while keeping your data completely private and secure on your own machine.**

[![GitHub stars](https://img.shields.io/github/stars/YourUsername/offline_chat?style=social)](https://github.com/YourUsername/offline_chat/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/YourUsername/offline_chat?style=social)](https://github.com/YourUsername/offline_chat/network/members)
[![GitHub issues](https://img.shields.io/github/issues/YourUsername/offline_chat)](https://github.com/YourUsername/offline_chat/issues)
[![GitHub license](https://img.shields.io/github/license/YourUsername/offline_chat)](https://github.com/YourUsername/offline_chat/blob/main/LICENSE)

_Made with 💻 on macOS • Powered by 🦙 Ollama • Built with 💙 Flutter_

</div>
