//
//  NetworkConstant.swift
//  VoltFramework
//
//  Created by
//

import Foundation

class NetworkConstant {

    static let platform: String = "SDK_INVESTWELL"
    static let baseURL: String = "https://api.staging.voltmoney.in"
    static let webBaseURL: String = "https://app.staging.voltmoney.in"

    static let loginTokenURL: String = baseURL + "/v1/partner/platform/auth/login"
    static let createCreditApplicationURL = baseURL + "/v1/partner/platform/las/createCreditApplication"
    static let loadWebViewURL = baseURL

    static let appKey = "volt-sdk-staging@voltmoney.in"
    static let appSecret = "e10b6eaf2e334d1b955434e25fcfe2d8"
}
