//
//  OutgoingMessages.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/25.
//

import Foundation

class OutgoingMessage {
    let messageDictionary: NSMutableDictionary
    
    // MARK: - 초기화
    
    // 텍스트 메시지
    init(message: String, senderId: String, senderName: String, date: Date, status: String, type: String) {
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    // 메시지보내기
    
    func sendMessage(chatRoomID: String, messageDictionary: NSMutableDictionary, memberIds: [String], membersToPush: [String]) {
        let messageId = UUID().uuidString
        
        messageDictionary[kMESSAGEID] = messageId
        
        for memberId in memberIds {
            reference(.Message).document(memberId).collection(chatRoomID).document(messageId).setData(messageDictionary as! [String : Any])
        }
        
        // update recent chat
        
        //send push notifications
    }
}
