<p>
<a href="https://developer.apple.com/ios" target="_blank"><img src="https://img.shields.io/badge/Platform-iOS_16+-blue.svg" alt="Platform: iOS 16.0+" /></a>
<a href="https://developer.apple.com/swift" target="_blank"><img src="https://img.shields.io/badge/Language-Swift_5-orange.svg" alt="Language: Swift 5" /></a>
<a href="https://github.com/hugo-pivaral/UITabControl/blob/main/LICENSE" target="_blank"><img src="https://img.shields.io/badge/License-MIT-blueviolet.svg" alt="License: MIT" /></a>
</p>

# NetNeuron 🧠
NetNeuron is a robust Swift networking library specifically crafted to streamline the process of making and managing HTTP requests. Designed with RESTful APIs in mind, this framework effectively handles the intricacies of network communication, enabling developers to write more efficient and cleaner code. Additionally, NetNeuron seamlessly integrates with SwiftUI projects, making it an ideal solution for modern, Swift-centric app development.

## Features
* **Swift Native:** NetNeuron is built with 100% Swift libraries, which means no external dependencies are required for it to work. This promotes easier integration and ensures seamless compatibility with Swift projects.
* **User-friendly:** The design of NetNeuron enables clear and concise code, making it easier for developers to understand and implement.
* **Flexible:** It allows for easy customization of request configuration.
* **Modular:** The separation of functionalities into distinct classes and structures encourages reusability and maintainability.
* **Supports Asynchronous Operations:** With built-in support for async/await syntax, NetNeuron is ready for modern asynchronous programming.
* **Thorough Error Handling:** NetNeuron includes a comprehensive suite of networking errors, providing more information about what went wrong and where.

## Classes
- `HTTPMethod`: This enum encapsulates all standardized HTTP methods, providing a structured way to specify the request method when configuring API calls.
- `ClientConfiguration`: This struct serves as a container for user-defined network configurations. It includes the host URL, default headers, URLSession, and the JSON encoder/decoder settings for a `NetNeuronClient`.
- `NetNeuronClient`: A sophisticated class that orchestrates and executes networking operations using `URLSession`. It provides a clean interface for making requests to an API and handles response data conversion.
- `NetNeuronError`: A comprehensive enumeration of potential networking errors. This enum enhances error-handling capabilities by outlining various issues that could arise during network requests, from API errors to connection issues.
- `NetNeuronResource`: This protocol establishes the fundamental properties of a networking resource that enumerates all possible endpoints of an API. Any struct or enum adhering to this protocol must have a corresponding `Resource` defined, representative of a specific API endpoint.
- `Resource`: This struct provides a model for specifying the necessary details of a network resource, including the HTTP method, endpoint, and any relevant query parameters. It provides utility functions for appending routes and parameters, offering a fluent API for modifying and building resource paths.

## Requirements
iOS 16.0 and higher

## Installation
Installation is only available through <a href="https://swift.org/package-manager/" target="_blank">Swift Package Manager</a>:

```swift
dependencies: [
  .package(url: "https://github.com/hugo-pivaral/NetNeuron.git", .exact("1.0.0")),
],
```
After installing the SPM into your project import NetNeuron with

```swift
import NetNeuron
```

## Usage
Here is a basic example of how to use NetNeuron for a simple GET request:

```swift
import NetNeuron

// Set up client configuration
let config = ClientConfiguration(
    hostURL: "https://api.example.com/",
    headers: ["Content-Type": "application/json"]
)

// Create a networking client with the configuration
let client = NetNeuronClient(configuration: config)

// Define a resource
let resource = Resource(.GET, "my/endpoint/example")

// Define a model for the response data you expect to receive
struct ResponseData: Decodable {
    let name: String
    let id: Int
}

// Send the request
Task {
    do {
        let response: ResponseData = try await client.request(
            to: resource,
            expecting: ResponseData.self,
            errorType: NetworkingError.self
        )
        // Do something with the response
        print("Name: \(response.name), ID: \(response.id)")
    } catch {
        // Handle any errors
        print("An error occurred: \(error)")
    }
}
```

## Author
[Hugo Pivaral](https://hugop.dev)

## License
NetNeuron is under the MIT license. See [LICENSE](./LICENSE) for details.
