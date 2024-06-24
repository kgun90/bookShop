//
//  NetworkService.swift
//  BookShop
//
//  Created by gkang on 6/20/24.
//

import Foundation

public let successRange = 200 ..< 300
public let failRange = 400 ..< 500

class NetworkService {
    init(route: Endpoint.ROUTE) {
        self.route = route.rawValue
    }
    
    private let route: String

    public enum HTTPMethod: String {
        case get = "GET", put = "PUT", post = "POST", delete = "DELETE"
    }
    

    func request<R: Decodable>(path: String, method: HTTPMethod, query: [String: String]? = nil, type: R.Type, completion: @escaping (Decodable?) -> Void) {
        
        guard var urlComponent = URLComponents(string: Endpoint.BASE_URL) else {
            print("Invalid URL")
            return
        }
        
        urlComponent.path = "\(route)\(path)"
        urlComponent.queryItems = dictionaryToQuery(query)
        
        guard let url = urlComponent.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                let response = self.decodeResponse(of: ErrorResponse.self, result: data)
                completion(response)
                
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse), successRange.contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            completion(self.decodeResponse(of: R.self, result: data))
        }

        task.resume()
    }
    
    private func dictionaryToQuery(_ query: [String: String]?) -> [URLQueryItem] {
        return query?.map { URLQueryItem(name: $0.0, value: $0.1) } ?? []
    }
    
    private func decodeResponse<R: Decodable> (of: R.Type, result: Data) -> R? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.formatCoder)
        
        var response: R? = nil
        
        do {
            response = try decoder.decode(R.self, from: result)
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
        }
        
        return response
    }

}
