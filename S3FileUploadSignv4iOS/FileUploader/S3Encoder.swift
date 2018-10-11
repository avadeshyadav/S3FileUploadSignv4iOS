//
//  S3Encoder.swift
//  S3FileUploadSignv4iOS
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import Foundation


struct S3Encoder: S3Encodeable {
    
    private let configData: AWSSecretConfig
    
    init(awsConfig: AWSSecretConfig) {
        self.configData = awsConfig
    }
    
    func getCredential(from date: Date) -> String {
        
        let dateString: String = date.stringWithFormatType(DateFormatType.simpleDate)
        let cretentials: [String] = [configData.accessKeyId, dateString, configData.regionName, configData.serviceName, configData.aws4Request]
        return cretentials.joined(separator: "/")
    }
    
    func getPolicyWith(amzDate: String, credentials: String, tokenExpiry: String, policyExpiryHours: TimeInterval) -> String? {
        
        var rootPolicy = Dictionary<String, Any>()
        var conditionArray = Array<Any>()
        
        conditionArray.append([FieldKey.bucket: configData.bucketName])
        conditionArray.append([FieldKey.permission: configData.permission])
        conditionArray.append([FieldKey.algorithm: configData.hMacAlgorithm])
        conditionArray.append([FieldKey.credential: credentials])
        conditionArray.append([FieldKey.date: amzDate])
        conditionArray.append([FieldKey.expires: tokenExpiry])
        conditionArray.append([FieldKey.startsWith, "$key", "ios"])
        
        let currentDate = Date.dateFromString(amzDate, withDateFormatType: DateFormatType.amazonDate) ?? Date()
        let date = currentDate.addingTimeInterval(policyExpiryHours * 60 * 60)
        let expirayDateString = date.stringWithFormatType(DateFormatType.expiryDate)
        rootPolicy[FieldKey.expiration] = expirayDateString
        
        rootPolicy[FieldKey.conditions] = conditionArray
        
        return rootPolicy.stringValue()?.toBase64()
    }
    
    func getAmazonSignature(from date: Date, policy: String) -> String {
        
        let dateString = date.stringWithFormatType(DateFormatType.simpleDate)
        let secretKeyData = "AWS4".appending(configData.secretKeyId).utf8Data()
        let dateKey:[UInt8] = HMACSHA256(using: secretKeyData).generateSHA256(with: dateString.bytesArray())
        let dateRegionKey:[UInt8] = HMACSHA256(using: Data(dateKey)).generateSHA256(with: configData.regionName.bytesArray())
        let dateRegionServiceKey:[UInt8] = HMACSHA256(using: Data(dateRegionKey)).generateSHA256(with: configData.serviceName.bytesArray())
        let dateRegionServiceRequestKey:[UInt8] = HMACSHA256(using: Data(dateRegionServiceKey)).generateSHA256(with: configData.aws4Request.bytesArray())
        let signature:[UInt8] = HMACSHA256(using: Data(dateRegionServiceRequestKey)).generateSHA256(with: policy.bytesArray())
        
        return signature.hexString()
    }
}
