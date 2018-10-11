//
//  Constants.swift
//  S3FileUploadSignv4iOS
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import Foundation


struct AWSSecretConfig {
    
    var secretKeyId: String = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
    var accessKeyId: String = "YourAppAccessKey"
    var bucketName: String = "YourBucketName"
    var regionName: String = "us-east-1"
    var serverAddress: String =   "s3.amazonaws.com"
    var permission: String = "public-read-write"
    var hMacAlgorithm: String = "AWS4-HMAC-SHA256"
    var serviceName: String = "s3"
    var aws4Request: String = "aws4_request"
}

struct Constants {
    static let policyExpirationHours: TimeInterval = 6
    static let tokenExpirationSeconds: String = "86400"
    static let requestHTTPPOSTMethod: String = "POST"
    static let randomBoundry: String = "34355435RandomBoundry"
    static let contentType: String = "application/octet-stream"
}

enum DateFormatType: String {
    case simpleDate =     "yyyyMMdd"
    case amazonDate =     "yyyyMMdd'T'HHmmss'Z'"
    case expiryDate =     "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}

struct FieldKey {
    static let contentType: String = "Content-Type"
    static let contentLength: String = "Content-Length"
    static let contentDisposition: String = "Content-Disposition"
    static let algorithm: String = "x-amz-algorithm"
    static let credential: String = "x-amz-credential"
    static let date: String = "x-amz-date"
    static let expires: String = "x-amz-expires"
    static let signature: String = "x-amz-signature"
    static let permission: String = "acl"
    static let key: String = "key"
    static let policy: String = "policy"
    static let file: String = "file"
    static let bucket: String = "bucket"
    static let startsWith: String = "starts-with"
    static let expiration: String = "expiration"
    static let conditions: String = "conditions"
}
