//
//  OTMClient.swift
//  OntheMap
//
//  Created by Tony Mackay on 27/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import Foundation

class OTMClient
{
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
        static var firstName = "Arnold"
        static var lastName = "Schwarzenegger"
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations
        case session
        case studentLocation
        case userData
        
        var stringValue: String {
            switch self {
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .session:
                return Endpoints.base + "/session"
            case .studentLocation:
                return Endpoints.base + "/StudentLocation"
            case .userData:
                return Endpoints.base + "/users/\(Auth.accountKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, trim: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            print(String(data: newData, encoding: .utf8) ?? "")
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: trim ? newData : data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: trim ? newData : data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, trim: Bool = true, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            
            let newData = data.subdata(in: 5..<data.count)
            print(String(data: newData, encoding: .utf8) ?? "")
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: trim ? newData : data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: trim ? newData : data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForDELETERequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            print(String(data: newData, encoding: .utf8) ?? "")
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    class func getStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, responseType: LocationResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(email: email, password: password)
        taskForPOSTRequest(url: Endpoints.session.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                Auth.accountKey = response.account.key
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        let body = LogoutRequest()
        taskForDELETERequest(url: Endpoints.session.url, responseType: LogoutResponse.self, body: body) { response, error in
            if let response = response {
                print(response)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getUserData(completion: @escaping (UserDataResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.userData.url, responseType: UserDataResponse.self, trim: true) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func addLocation(address: String, link: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let body = LocationRequest(
            uniqueKey: Auth.accountKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: address, mediaURL: link, latitude: latitude, longitude: longitude
        )
        
        taskForPOSTRequest(url: Endpoints.studentLocation.url, responseType: StudentLocationResponse.self, body: body, trim: false) { response, error in
            if let response = response {
                print(response)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
