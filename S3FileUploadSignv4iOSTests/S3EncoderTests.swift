//
//  S3EncoderTests.swift
//  S3FileUploadSignv4iOSTests
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import XCTest
@testable import S3FileUploadSignv4iOS


class S3EncoderTests: XCTestCase {
    
    let accessKey = "YourAppAccessKey"
    let secretKey = "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
    let region = "us-east-1"
    let service = "s3"
    let request = "aws4_request"
    let bucket = "YourBucketName"
    let permission = "public-read-write"
    let algorithm = "AWS4-HMAC-SHA256"
    let amzDateString = "20181011T075133Z"
    let expectedPolicy: String = "ewogICJleHBpcmF0aW9uIiA6ICIyMDE4LTEwLTExVDEzOjUxOjMzLjAwMFoiLAogICJjb25kaXRpb25zIiA6IFsKICAgIHsKICAgICAgImJ1Y2tldCIgOiAiWW91ckJ1Y2tldE5hbWUiCiAgICB9LAogICAgewogICAgICAiYWNsIiA6ICJwdWJsaWMtcmVhZC13cml0ZSIKICAgIH0sCiAgICB7CiAgICAgICJ4LWFtei1hbGdvcml0aG0iIDogIkFXUzQtSE1BQy1TSEEyNTYiCiAgICB9LAogICAgewogICAgICAieC1hbXotY3JlZGVudGlhbCIgOiAiWW91ckFwcEFjY2Vzc0tleVwvMjAxODEwMTFcL3VzLWVhc3QtMVwvczNcL2F3czRfcmVxdWVzdCIKICAgIH0sCiAgICB7CiAgICAgICJ4LWFtei1kYXRlIiA6ICIyMDE4MTAxMVQwNzUxMzNaIgogICAgfSwKICAgIHsKICAgICAgIngtYW16LWV4cGlyZXMiIDogIjg2NDAwIgogICAgfSwKICAgIFsKICAgICAgInN0YXJ0cy13aXRoIiwKICAgICAgIiRrZXkiLAogICAgICAiaW9zIgogICAgXQogIF0KfQ=="
    let expectedSignature: String = "7d6415527a1de80df01296a87c2648b0763be270cb81ee12e30754d967ec5cd3"
    
    var s3Encoder: S3Encodeable!
    
    override func setUp() {
        super.setUp()
        
        let data = AWSSecretConfig(secretKeyId: secretKey, accessKeyId: accessKey, bucketName: bucket, regionName: region, serverAddress: "", permission: permission, hMacAlgorithm: algorithm, serviceName: service, aws4Request: request)
        s3Encoder = S3Encoder(awsConfig: data)
    }
    
    func testGenerateCredentials() {
        
        let date = Date.dateFromString(amzDateString, withDateFormatType: .amazonDate)!
        let dateString = date.stringWithFormatType(DateFormatType.simpleDate)
        let expectedCredentials = "\(accessKey)/\(dateString)/\(region)/\(service)/\(request)"
        
        let credentials = s3Encoder.getCredential(from: date)
        
        XCTAssertEqual(expectedCredentials, credentials, "Incorrect credentials generation")
    }
    
    func testPolicyGeneration() {
        
        let date = Date.dateFromString(amzDateString, withDateFormatType: .amazonDate)!
        let dateString = date.stringWithFormatType(DateFormatType.simpleDate)
        let credentials = "\(accessKey)/\(dateString)/\(region)/\(service)/\(request)"
        
        let policy = s3Encoder.getPolicyWith(amzDate: amzDateString, credentials: credentials, tokenExpiry: "86400", policyExpiryHours: 6)
        
        XCTAssertNotNil(policy, "S3Helper Policy generation issue: generating nil policy")
        XCTAssertEqual(policy!, expectedPolicy, "S3Helper Policy generation issue: generating wrong policy")
    }
    
    func testSignatureGeneration() {
        
        let date: Date = Date.dateFromString(amzDateString, withDateFormatType: .amazonDate)!
        let signature = s3Encoder.getAmazonSignature(from: date, policy: expectedPolicy)
        
        XCTAssertEqual(expectedSignature, signature, "S3Helper signature generation issue: Generating wrong signature")
    }
}
