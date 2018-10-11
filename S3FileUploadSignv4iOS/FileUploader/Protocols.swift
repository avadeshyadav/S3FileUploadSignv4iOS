//
//  Protocols.swift
//  S3FileUploadSignv4iOS
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import Foundation


protocol RequestBuildable {
    func request(with data: Data, uploadPath: String) -> URLRequest?
}

protocol S3Encodeable {
    func getCredential(from date: Date) -> String
    func getAmazonSignature(from date: Date, policy: String) -> String
    func getPolicyWith(amzDate: String, credentials: String, tokenExpiry: String, policyExpiryHours: TimeInterval) -> String?
}
