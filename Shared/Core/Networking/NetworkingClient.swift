import Foundation

public typealias StatusCode = Int

public protocol NetworkingClientProtocol {
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get set }
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get set }
    var bodyType: BodyType { get set }
    
    func makeRequest<ResponseType: Decodable>(
        type: ResponseType.Type,
        withMethod method: APIHttpMethod,
        url: URL,
        body: [String : String]?,
        queryParameters: [String : String]?,
        headers: [String : String]?) async throws -> (ResponseType, StatusCode)
}


public class NetworkingClient: NetworkingClientProtocol {
    
    private var session: URLSession
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    public var bodyType: BodyType
    
    init(session: URLSession = URLSession.shared,
         dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
         keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
         bodyType: BodyType = .json) {
        
        self.session = session
        self.dateDecodingStrategy = dateDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
        self.bodyType = bodyType
    }
    
    public func makeRequest<ResponseType: Decodable>(
        type: ResponseType.Type,
        withMethod method: APIHttpMethod,
        url: URL,
        body: [String : String]? = nil,
        queryParameters: [String : String]? = nil,
        headers: [String : String]? = nil) async throws -> (ResponseType, StatusCode) {
            
            guard let completeUrl = makeUrlComponents(withUrl: url, queryParameters: queryParameters)?.url else {
                throw APIError.invalidRequestWithIncorrectUrlFormat(
                    "Failed to create url with the passed query parameters of \(String(describing: queryParameters))"
                )
            }
            
            let request = makeUrlRequest(withMethod: method,
                                         url: completeUrl,
                                         body: body,
                                         queryParameters: queryParameters,
                                         headers: headers)
            let response = try await data(for: request)
            return try parseResponse(type: type, response: response)
            
        }
    
    
    private func parseResponse<ResponseType: Decodable>(type: ResponseType.Type,
                                                         response: APIHttpResponse) throws -> (ResponseType, StatusCode) {
        switch response.statusCode {
        case 200..<300:
            do {
                return (try converData(toType: type,
                                      data: response.data,
                                       dateDecodingStrategy: dateDecodingStrategy), response.statusCode)
            } catch {
                print("❌", error)
                throw APIError(error: error)
            }
        case 401:
            throw APIError.unauthorized("You are not authorized. Please try again.")
        case 400:
            throw APIError.badRequest("Bad request with status code: \(response.statusCode)")
        default:
            throw APIError.unknown("Failed to parse response with status code: \(response.statusCode) ")
        }
        
    }
    
    private func makeUrlComponents(withUrl url: URL, queryParameters: [String : String]? = nil) -> URLComponents? {
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        queryParameters?.forEach { urlComponents?.queryItems?.append(URLQueryItem(name: $0, value: $1)) }
        return urlComponents
        
    }
    
    private func makeUrlRequest(withMethod method: APIHttpMethod,
                                url: URL,
                                body: [String : String]? = nil,
                                queryParameters: [String : String]? = nil,
                                headers: [String : String]? = nil) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.addValue(bodyType.rawValue,
                         forHTTPHeaderField: "Content-Type")
        
        if  (method == .POST || method == .PUT || method == .PATCH),
            let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        return request
        
    }
    
    private func data(for request: URLRequest) async throws -> APIHttpResponse {
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse("Failed to convert response to HTTPURLResponse")
        }
        return APIHttpResponse(data: data, response: httpResponse)
        
    }
    
    private func converData<T : Decodable>(toType type: T.Type,
                                           data: Data,
                                           dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil,
                                           keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil) throws -> T {
        let decoder = JSONDecoder()
        
        if let dateDecodingStrategy = dateDecodingStrategy {
            decoder.dateDecodingStrategy = dateDecodingStrategy
        } else {
            decoder.dateDecodingStrategy = self.dateDecodingStrategy
        }
        
        if let keyDecodingStrategy = keyDecodingStrategy {
            decoder.keyDecodingStrategy = keyDecodingStrategy
        } else {
            decoder.keyDecodingStrategy = self.keyDecodingStrategy
        }
        
        return  try decoder.decode(T.self, from: data)
    }
    
}


public struct APIHttpResponse {
    let data: Data
    let response: HTTPURLResponse
    var statusCode: Int {
        return response.statusCode
    }
    
    var debugString: String {
        let result = String(data: data, encoding: .utf8)
        return "Status Code: \(statusCode) - \(result ?? "<some-wrong>"))"
    }
}

public enum APIHttpMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}


public enum APIError: Error {
    case invalidResponse(String)
    case invalidRequestWithIncorrectUrlFormat(String)
    case badRequest(String)
    case invalidUrl(String)
    case unauthorized(String)
    case failedToParseJSON(String)
    case unknown(String)
    
    init(error: Error) {
        self = .unknown(error.localizedDescription)
    }
}

public enum BodyType: String {
    case urlFormEcoded = "application/x-www-form-urlencoded"
    case json = "application/json"
}
