//
//  RequestBuilder.swift
//  S3FileUploadSignv4iOS
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import Foundation


final class S3RequestBuilder: RequestBuildable {
    
    let encoder: S3Encodeable
    let configData: AWSSecretConfig
    
    init(encoder: S3Encodeable, awsConfig: AWSSecretConfig) {
        self.encoder = encoder
        self.configData = awsConfig
    }
    
    final func request(with data: Data, uploadPath: String) -> URLRequest? {
        
        guard let url = URL(string: getHost()) else {
            return nil
        }
        
        return buildRequest(data, url: url, uploadPath: uploadPath)
    }
    
    //MARK:- Private Methods
    private func getHost() -> String {
        let url: String = "https://".appending(configData.bucketName).appending(".").appending(configData.serverAddress)
        return url
    }
    
    private func buildRequest(_ content: Data, url: URL, uploadPath : String) -> URLRequest? {
        
        let date: Date = Date()
        let amzDateString: String = date.stringWithFormatType(DateFormatType.amazonDate)

        let tokenExpiry: String = Constants.tokenExpirationSeconds
        let policyExpiryHours: TimeInterval = Constants.policyExpirationHours
        let credentials: String = encoder.getCredential(from: date)
        
        guard let policy: String = encoder.getPolicyWith(amzDate: amzDateString, credentials: credentials, tokenExpiry: tokenExpiry, policyExpiryHours: policyExpiryHours) else {
            return nil
        }
        
        let amazonSignatureKey: String = encoder.getAmazonSignature(from: date, policy: policy)
        
        return  buildRequest(url: url, amzDate: amzDateString, path: uploadPath, policy: policy, amzSignature: amazonSignatureKey, credential: credentials, content: content)
    }
    
    private func buildRequest(url: URL, amzDate: String, path: String, policy: String, amzSignature: String, credential: String, content: Data) -> URLRequest {
        
        var request = URLRequest(url: url)
        let postData = getPostDataFrom(data: content, amzDate: amzDate, path: path, policy: policy, signature: amzSignature, credential: credential)
        request.setValue("multipart/form-data; boundary=" + Constants.randomBoundry, forHTTPHeaderField: FieldKey.contentType)
        request.setValue(String(postData.count), forHTTPHeaderField: FieldKey.contentLength)
        request.httpBody = postData
        request.httpMethod = Constants.requestHTTPPOSTMethod
        
        return request
    }
}

//MARK:- Post Data Building
extension S3RequestBuilder {
    
    private func getPostDataFrom(data: Data, amzDate: String, path: String, policy: String, signature: String, credential: String) -> Data {
        
        let fileName: String = path.components(separatedBy: "/").last ?? ""
        
        var postData = Data()
        postData.append(multiPart: FieldKey.algorithm, value: configData.hMacAlgorithm)
        postData.append(multiPart: FieldKey.credential, value: credential)
        postData.append(multiPart: FieldKey.date, value: amzDate)
        postData.append(multiPart: FieldKey.expires, value: Constants.tokenExpirationSeconds)
        postData.append(multiPart: FieldKey.signature, value: signature)
        postData.append(multiPart: FieldKey.permission, value: configData.permission)
        postData.append(multiPart: FieldKey.key, value: path)
        postData.append(multiPart: FieldKey.policy, value: policy)
        
        postData.append(("--" + Constants.randomBoundry + "\r\n").utf8Data())
        let contentInfo = "\(FieldKey.contentDisposition): form-data; name=\"\(FieldKey.file)\"; filename=\"" + fileName + "\"\r\n"
        postData.append(contentInfo.utf8Data())
        postData.append("\(FieldKey.contentType): \(Constants.contentType)\r\n\r\n".utf8Data())
        postData.append(data)
        postData.append("\r\n".utf8Data())
        postData.append(("--" + Constants.randomBoundry + "--\r\n").utf8Data())
        
        return postData
    }
}
