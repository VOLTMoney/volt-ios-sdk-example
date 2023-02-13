//
//  Volt.swift
//  VoltFramework
//
//  Created
//

import Foundation

public enum VOLTENV: CustomStringConvertible {
    case STAGING
    case PRODUCTION

    public var description: String {
        switch self {
        case .STAGING:
            return "https://app.staging.voltmoney.in/partnerplatform"
        case .PRODUCTION:
            return "https://app.voltmoney.in/partnerplatform"
        }
    }
}

protocol VoltProtocol {
    static func preCreateApplication(dob: String, email: String, panNumber: String, mobileNumber: Int, callback: ((_ response: APIResponse?) -> Void)?)
    static func initVoltSDK(mobileNumber: String) -> URL?
    static var voltInstance: VoltInstance? { get }
}

public class VoltSDKContainer: VoltProtocol {
    static var voltInstance: VoltInstance?

    public init(voltInstance: VoltInstance? = nil) {
        VoltSDKContainer.voltInstance = voltInstance
    }

    public static func initVoltSDK(mobileNumber: String) -> URL? {
        var webURL = voltInstance?.voltEnv?.description

        if self.voltInstance?.ref != "" {
            let ref = "ref=" + (voltInstance?.ref ?? "") + "&"
            webURL?.append(ref)
        }

        if voltInstance?.primary_color != "" {
            let primaryColor = "primaryColor=" + (voltInstance?.primary_color ?? "") + "&"
            webURL?.append(primaryColor)
        }

        if voltInstance?.secondary_color != "" {
            let secondaryColor = "secondaryColor=" + (voltInstance?.secondary_color ?? "") + "&"
            webURL?.append(secondaryColor)
        }

        if mobileNumber != "" {
            let mobileNumber = "user=" + mobileNumber + "&"
            webURL?.append(mobileNumber)
        }

        if voltInstance?.partner_platform != "" {
            let partnerPlatform = "platform=" + (voltInstance?.partner_platform ?? "")
            webURL?.append(partnerPlatform)
        }

        return URL(string: webURL ?? "")
    }

    private static func generateClientToken() -> (APIResponse?, Bool?) {
        var responseData: APIResponse?
        if let authTokenData = RestApiManager.getLoginToken(urlString: NetworkConstant.loginTokenURL, appKey: voltInstance?.app_key ?? "", appSecret: voltInstance?.app_secret ?? "", method: .post) {
            do {
                responseData = try JSONDecoder().decode(APIResponse.self, from: authTokenData)
                if responseData?.authToken != nil {
                    UserDefaults.standard.set(responseData?.authToken, forKey: "authToken")
                    return (responseData, true)
                } else {
                    return (responseData, false)
                }
            } catch (let error) {
                print(error)
                return (responseData, false)
            }
        } else {
            return (responseData, false)
        }
    }

    public static func preCreateApplication(dob: String, email: String, panNumber: String, mobileNumber: Int, callback: ((_ response: APIResponse?) -> Void)?) {
        var responseData: APIResponse?
        if generateClientToken().1 == true {
            if let createApplicationData = RestApiManager.createCreditApplication(urlString: NetworkConstant.createCreditApplicationURL, dob: dob, email: email, panNumber: panNumber, mobileNumber: mobileNumber, method: .post) {
                do {
                    responseData = try JSONDecoder().decode(APIResponse.self, from: createApplicationData)
                    if responseData?.customerAccountId != nil {
                        callback?(responseData)
                    } else {
                        callback?(responseData)
                    }
                } catch(let error) {
                    print(error)
                    callback?(responseData)
                }
            } else {
                callback?(responseData)
            }
        } else {
            callback?(generateClientToken().0)
        }
    }
}
