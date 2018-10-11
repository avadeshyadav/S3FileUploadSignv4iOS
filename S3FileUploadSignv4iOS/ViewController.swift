//
//  ViewController.swift
//  S3FileUploadSignv4iOS
//
//  Created by Avadesh Kumar on 11/10/18.
//  Copyright © 2018 Avadesh Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func actionUpload(_ sender: UIButton) {
        upload()
    }
    
    
    func upload() {
      
        let imagePath = Bundle.main.path(forResource: "myImage1", ofType: "zip")
        let data = try! Data(contentsOf: URL(fileURLWithPath: imagePath!))
        let secretData = AWSSecretConfig()
        let s3Encoder = S3Encoder(awsConfig: secretData)
        let request = S3RequestBuilder(encoder: s3Encoder, awsConfig: secretData).request(with: data, uploadPath: "ios/sandbox/myFolderonServer/myImage1.gz")
        
        let task = URLSession.shared.dataTask(with: request!) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, let data = data {
                let text = String(data: data, encoding: String.Encoding.utf8)
                NSLog("Response from AWS S3: \(httpResponse.description)\n\(text!)")
            }
        }
        
        task.resume()
    }
}

