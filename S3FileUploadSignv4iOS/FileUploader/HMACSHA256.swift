//
//  HMACSHA256.swift
//  S3FileUploadSignv4iOS
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import Foundation


class HMACSHA256 {
    
    typealias Context = UnsafeMutablePointer<CCHmacContext>
    private let context = Context.allocate(capacity: 1)
    
    init(using key: Data) {
        
        key.withUnsafeBytes() { (buffer: UnsafePointer<UInt8>) in
            CCHmacInit(context, CCHmacAlgorithm(kCCHmacAlgSHA256), buffer, size_t(key.count))
        }
    }
    
    func generateSHA256(with message: [UInt8]) -> [UInt8] {
        
        CCHmacUpdate(context, message, size_t(message.count))
        var hmac = Array<UInt8>(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmacFinal(context, &hmac)
        return hmac
    }
}
