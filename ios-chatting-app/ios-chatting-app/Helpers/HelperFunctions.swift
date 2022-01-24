//
//  HelperFunctions.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import Foundation
import UIKit
import FirebaseFirestore

//MARK: GLOBAL FUNCTIONS
private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}

// 기본이미지를 이름으로 만드는 메서드
func imageFromInitials(firstName: String?, lastName: String?, withBlock: @escaping (_ image: UIImage) -> Void) {
    
    var string: String!
    var size = 36
    
    if firstName != nil && lastName != nil {
        string = String(firstName!.first!).uppercased() + String(lastName!.first!).uppercased()
    } else {
        string = String(firstName!.first!).uppercased()
        size = 72
    }
    
    let lblNameInitialize = UILabel()
    lblNameInitialize.frame.size = CGSize(width: 100, height: 100)
    lblNameInitialize.textColor = .white
    lblNameInitialize.font = UIFont(name: lblNameInitialize.font.fontName, size: CGFloat(size))
    lblNameInitialize.text = string
    lblNameInitialize.textAlignment = NSTextAlignment.center
    lblNameInitialize.backgroundColor = UIColor.lightGray
    lblNameInitialize.layer.cornerRadius = 25
    
    UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
    lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    withBlock(img!)
}

// Firebase에서 가져온 String -> Data
func imageFromData(pictureData: String, withBlock: (_ image: UIImage?) -> Void) {
    
    var image: UIImage?
    
    let decodedData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    image = UIImage(data: decodedData! as Data)
    
    withBlock(image)
}
