//
//  Encryption.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/26.
//

import Foundation
import RNCryptor


class Encryption {
    
    // 암호화할 메서드
    class func encryptText(chatRoomId: String, message: String) -> String {
        
        let data = message.data(using: String.Encoding.utf8)
        let encryptedData = RNCryptor.encrypt(data: data!, withPassword: chatRoomId)
        
        return encryptedData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    // 복호화할 메서드
    class func decryptText(chatRoomId: String, encryptedMessage: String) -> String {
        
        let decryptor = RNCryptor.Decryptor(password: chatRoomId)

        let encryptedData = NSData(base64Encoded: encryptedMessage, options: NSData.Base64DecodingOptions(rawValue: 0))

        var message: NSString = ""

        if encryptedData != nil {
            do {
                let decryptedData = try decryptor.decrypt(data: encryptedData! as Data)
                message = NSString(data: decryptedData, encoding: String.Encoding.utf8.rawValue)!
            } catch {
                print("error decrypting text \(error.localizedDescription)")
            }
        }
        
        return message as! String
    }

}
