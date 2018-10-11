//
//  DateExtensionTests.swift
//  S3FileUploadSignv4iOSTests
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import XCTest
@testable import S3FileUploadSignv4iOS

class DateExtensionTests: XCTestCase {
    
    func testDateCreationFromStrings() {
        
        let amzDateString = "20181007T101103Z"
        let expiryDateString = "2018-10-07T22:47:02.000Z"
        let simpleDateString = "20181007"
        
        let amazonDate = Date.dateFromString(amzDateString, withDateFormatType: .amazonDate)
        let expiryDate = Date.dateFromString(expiryDateString, withDateFormatType: .expiryDate)
        let simpleDate = Date.dateFromString(simpleDateString, withDateFormatType: .simpleDate)
        
        XCTAssertNotNil(amazonDate, "DateFormatter Issue: Unable to create date instance from AmazonDateString")
        XCTAssertNotNil(expiryDate, "DateFormatter Issue: Unable to create date instance from Expiry date String")
        XCTAssertNotNil(simpleDate, "DateFormatter Issue: Unable to create date instance from simple YYYYMMDD dateString")
    }
    
    func testDateStringCreationsFromDate() {
        
        let date = Date()
        
        let amazonDateString =  date.stringWithFormatType(.amazonDate)
        let expiryDateString =  date.stringWithFormatType(.expiryDate)
        let simpleDateString =  date.stringWithFormatType(.simpleDate)
        
        XCTAssertNotNil(amazonDateString, "DateFormatter Issue: Unable to create AmazonDateString from date instance")
        XCTAssertNotNil(expiryDateString, "DateFormatter Issue: Unable to create expiryDateString from date instance")
        XCTAssertNotNil(simpleDateString, "DateFormatter Issue: Unable to create simpleDateString from date instance")
    }
    
    func testDateStringConversionsBetweenFormats() {
        
        let amzDateString = "20181007T101103Z"
        let expectedSimpleDateString = "20181007"
        
        let date = Date.dateFromString(amzDateString, withDateFormatType: .amazonDate)
        let simpleDateString = date?.stringWithFormatType(DateFormatType.simpleDate)
        let recreatedAmzDateString = date?.stringWithFormatType(DateFormatType.amazonDate)
        
        XCTAssertEqual(simpleDateString, expectedSimpleDateString, "DateFormatter Issue: Wrong Simple date string YYYYMMDD output")
        XCTAssertEqual(recreatedAmzDateString, amzDateString, "DateFormatter Issue: Unable to generate same amazon date string back to an from date string")
    }
    
}

