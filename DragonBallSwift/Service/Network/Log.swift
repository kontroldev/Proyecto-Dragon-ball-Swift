import Foundation

enum Log {
    static func thisRequest(_ response: HTTPURLResponse, data: Data, request: URLRequest?) {
        #if DEBUG
            print("HTTP \(response.statusCode) · \(request?.url?.path ?? "") · \(data.count) bytes")
        #endif
    }
}
