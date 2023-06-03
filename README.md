<p>
<a href="https://developer.apple.com/ios" target="_blank"><img src="https://img.shields.io/badge/Platform-iOS_16+-blue.svg" alt="Platform: iOS 16.0+" /></a>
<a href="https://developer.apple.com/swift" target="_blank"><img src="https://img.shields.io/badge/Language-Swift_5-orange.svg" alt="Language: Swift 5" /></a>
<a href="https://github.com/hugo-pivaral/UITabControl/blob/main/LICENSE" target="_blank"><img src="https://img.shields.io/badge/License-MIT-blueviolet.svg" alt="License: MIT" /></a>
</p>

# NetNeuron

NetNeuron is a comprehensive Swift networking library designed to simplify the process of making and handling HTTP requests. This framework simplifies interaction with RESTful APIs, managing the complexity of network communication, and helps developers create more efficient, cleaner code.

## Features
- Comprehensive handling of all HTTP methods (GET, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH)
- Robust error handling mechanism to capture a wide range of networking errors.
- Customizable configuration options including default headers, URLSession, JSON encoder, and decoder.
- Generic request methods that allow for flexible request body and expected response types.

## Classes

- `HTTPMethod`: An enum that enumerates all the HTTP methods.
- `ClientConfiguration`: A struct that defines configuration options for a NetNeuronClient.
- `NetNeuronClient`: A class that manages networking operations.
- `NetNeuronError`: An enum that outlines the types of errors that can occur when making a network request.
- `NetNeuronResource`: A protocol that defines a networking resource.
- `Resource`: A struct that defines a networking resource.

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
let resource = Resource(.GET, "my/endpoint/data")

// Define a model for the response data (modify this to match your actual response)
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
