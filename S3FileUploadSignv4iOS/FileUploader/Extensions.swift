//
//  Extensions.swift
//  S3FileUploadSignv4iOS
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import Foundation


extension String {
    
    func utf8Data() -> Data {
        return self.data(using: String.Encoding.utf8)!
    }
    
    func bytesArray() -> [UInt8] {
        let array = [UInt8](self.utf8)
        return array
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

extension Data {
    
    mutating func append(multiPart key: String, value: String) {
        
        let start = "--" + Constants.randomBoundry + "\r\n"
        self.append(start.utf8Data())
        self.append("\(FieldKey.contentDisposition): form-data; name=\"\(key)\"\r\n\r\n".utf8Data())
        self.append(value.utf8Data())
        self.append("\r\n".utf8Data())
    }
}

extension Dictionary {
    
    func stringValue() -> String? {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let stringVlue = String(data: data, encoding: .utf8)
            return stringVlue
        }
        catch {
            print("Error while converting dictionary to string")
            return nil
        }
    }
}

extension Date {
    
    func stringWithFormatType(_ formatType: DateFormatType) -> String {
        
        let dateFormatter = Date.dateFormatterWithType(formatType)
        return dateFormatter.string(from: self)
    }
    
    static func dateFromString(_ dateString: String, withDateFormatType type: DateFormatType) -> Date? {
        
        let dateFormatter = dateFormatterWithType(type)
        return dateFormatter.date(from: dateString)
    }
    
    private static func dateFormatterWithType(_ type: DateFormatType) -> DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone =  TimeZone(abbreviation: "UTC")
        
        return dateFormatter;
    }
}

extension Sequence where Iterator.Element == UInt8 {
    
    func hexString() -> String {
        return self.map() { String(format: "%02x", $0) }.reduce("", +)
    }
}
