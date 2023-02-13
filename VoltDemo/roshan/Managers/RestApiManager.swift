//
//  RestApiManager.swift
//  VoltFramework
//
//  Created by 
//

import Foundation

class RestApiManager {

    static func getLoginToken(urlString: String, appKey: String, appSecret: String, method: HttpMethod) -> Data? {

        if let url =  URL.init(string: urlString) {
            var resource = Resource<Data?>(url: url)
            resource.httpMethod = method
            let bodyData = ["app_key" : appKey, "app_secret" : appSecret]
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
            resource.body = jsonData
            let headers = ["Content-Type": "application/json"]

            resource.header = headers

            let result = NetworkManager().serviceCall(resource: resource)
            switch result {
            case .success(let data):
                if data != nil {
                    return data
                }
            case .failure(.invalidResponse(let data)):
                if data != nil {
                    return data
                }
            }
            return nil
        }
        return nil
    }

    static func createCreditApplication(urlString: String, dob: String, email: String, panNumber: String, mobileNumber: Int, method: HttpMethod) -> Data? {

        if let url =  URL.init(string: urlString) {
            var resource = Resource<Data?>(url: url)
            resource.httpMethod = method
            var bodyData = [String : Any]()
            bodyData["dob"] = dob
            bodyData["email"] = email
            bodyData["pan"] = panNumber
            bodyData["mobileNumber"] = mobileNumber

            let jsonData = try? JSONSerialization.data(withJSONObject: ["customerDetails" : bodyData], options: [])
            resource.body = jsonData
            let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
            let headers = ["Content-Type": "application/json",
                       "Authorization": "Bearer \(authToken)",
                           "X-AppPlatform": NetworkConstant.platform]

            resource.header = headers

            let result = NetworkManager().serviceCall(resource: resource)
            switch result {
            case .success(let data):
                if data != nil {
                    return data
                }
            case .failure(.invalidResponse(let data)):
                if data != nil {
                    return data
                }
            }
            return nil
        }
        return nil
    }
}
