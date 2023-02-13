//
//  NetworkManager.swift
//  VoltFramework
//
//  Created by
//

import Foundation

enum NetworkError: Error {
//    case bodyInGet
//    case invalidURL
//    case noInternet
    case invalidResponse(Data? = nil)
//    case accessForbidden
   // case noData
//    case badGateway
   // case decodingError
   // case domainError
//    case urlError
//    case badRequest
//    case internalServerError
}

/*enum RESTNetworkError: Error {
    case unauthorized
    case badGateway
    case decodingError
    case domainError
    case urlError
    case badRequest
    case noData
    case forbidden
    case internalServerError
    case requestTimeout
    case noContent
    case notModified
    case tooManyRequests
    case SSLCertificateError
    case SSLCertificateRequired
}*/

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum HttpHeader: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case userAgent = "User-Agent"
    case SAAsessionID = "SAA-session-id"
    case urlencoded = "application/x-www-form-urlencoded"
    case jsonHeader = "application/json"
    case bearerKey = "Bearer"
}

struct Resource<T: Codable> {
    var url: URL
    var header: [String: String]?
    var httpMethod: HttpMethod = .post
    var contentType: String = ""
    var body: Data?
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

protocol NetworkManagerProtocol {
    func serviceCallAsync<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void)
    func serviceCall<T>(resource: Resource<T>) ->
                                    Result<T, NetworkError>
}

class NetworkManager: NetworkManagerProtocol {

    public func serviceCallAsync<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {

        let url = resource.url

        // Load from the cache
        var cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad

        // Load from the source
        if ReachabilityMonitor.shared.status == .connected {
            cachePolicy = .reloadIgnoringLocalCacheData
        }

        var request = URLRequest(url: url, cachePolicy: cachePolicy)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        if let resourceHeader = resource.header {
            for (key, value) in resourceHeader {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)

        var dataTask: URLSessionDataTask?
        dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.invalidResponse()))
                return
            }

            var statusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }

#if DEBUG
                print("DATA: " + (String(data: data!, encoding: .utf8) ?? ""))
#endif

            switch statusCode {
            case 200...399:
                guard data != nil else {
                    completion(.failure(.invalidResponse()))
                    return
                }

                if resource as? Resource<Data?> != nil {
                    completion(.success(data as! T))
                } else if let result = try? JSONDecoder().decode(T.self, from: data ?? Data()) {
                    completion(.success(result))
                } else {
                    completion(.failure(.invalidResponse()))
                }
            case 400...499:
                completion(.failure(.invalidResponse(data)))
            case 500...599:
                completion(.failure(.invalidResponse(data)))
            default:
                completion(.failure(.invalidResponse()))
            }
        }

        dataTask?.resume()
    }

    public func serviceCall<T>(resource: Resource<T>) -> Result<T, NetworkError> {
        var resultOuter: Result<T, NetworkError>!
        let semaphore = DispatchSemaphore(value: 0)

        self.serviceCallAsync(resource: resource) { result in
            resultOuter = result
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .distantFuture)

        return resultOuter
    }

}
