//
//  Recent.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import Foundation

// 대화방 만들기
func startPrivateChat(user1: FUser, user2: FUser) -> String {
    let userId1 = user1.objectId
    let userId2 = user2.objectId
    
    var chatRoomId = ""
    
    let value = userId1.compare(userId2).rawValue
    
    // 대화방은 동일하지만 위치가 반대일 것입니다.
    if value < 0 {
        chatRoomId = userId1 + userId2
    } else {
        chatRoomId = userId2 + userId1
    }
    
    let members = [userId1, userId2]
    
    //create recent chats
    createRecent(members: members, chatRoomId: chatRoomId, withUserUserName: "", type: kPRIVATE, users: [user1, user2], avatarOfGroup: nil)
    
    return chatRoomId
}

// users와 avatarOfGroup매개변수는 그룹채팅에 사용
func createRecent(members: [String], chatRoomId: String, withUserUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    
    var tempMembers = members
    
    reference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { snapshot, error in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data() as NSDictionary
                
                if let currentUserId = currentRecent[kUSERID] {
                    if tempMembers.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.index(of: currentUserId as! String)!)
                    }
                }
            }
        }
        
        for userId in tempMembers {
            // create recent items
            createRecentItems(userId: userId, chatRoomId: chatRoomId, members: members, withUserUserName: withUserUserName, type: type, users: users, avatarOfGroup: avatarOfGroup)
        }
        
    }
}

func createRecentItems(userId: String, chatRoomId: String, members: [String], withUserUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    let localReference = reference(.Recent).document()
    let recentId = localReference.documentID
    
    let date = dateFormatter().string(from: Date())
    
    var recent: [String : Any]!
    
    if type == kPRIVATE {
        // 개인대화방
        
        var withUser: FUser?
        
        if users != nil && users!.count > 0 {
            if userId == FUser.currentId() {
                //for current User
                withUser = users!.last!
            } else {
                withUser = users!.first!
            }
        }
        
        // kMEMBERSTOPUSH : 대화방에서 푸쉬알림을 받을 멤버를 정합니다. (알림차단하는 경우)
        recent = [kRECENTID : recentId, kUSERID : userId, kCHATROOMID : chatRoomId, kMEMBERS : members, kMEMBERSTOPUSH : members, kWITHUSERFULLNAME : withUser!.fullname, kWITHUSERUSERID : withUser!.objectId, kLASTMESSAGE : "", kCOUNTER : 0, kDATE : date, kTYPE : type, kAVATAR : withUser!.avatar] as [String : Any]
    } else {
        // 그룹대화방
        if avatarOfGroup != nil {
            recent = [
                kRECENTID : recentId, kUSERID : userId, kCHATROOMID : chatRoomId, kMEMBERS : members, kMEMBERSTOPUSH : members, kWITHUSERFULLNAME : withUserUserName, kLASTMESSAGE : "", kCOUNTER : 0, kDATE : date, kTYPE : type, kAVATAR : avatarOfGroup!] as [String : Any]
        }
        
        
    }
    
    // save recent chat
    localReference.setData(recent)
}

//Restart Chat
func restartRecentChat(recent: NSDictionary) {
    if recent[kTYPE] as! String == kPRIVATE {
        createRecent(members: recent[kMEMBERSTOPUSH] as! [String], chatRoomId: recent[kCHATROOMID] as! String, withUserUserName: recent[kWITHUSERUSERNAME] as! String, type: kPRIVATE, users: [FUser.currentUser()!], avatarOfGroup: nil)
    }
    
    if recent[kTYPE] as! String == kGROUP {
        createRecent(members: recent[kMEMBERSTOPUSH] as! [String], chatRoomId: recent[kCHATROOMID] as! String, withUserUserName: recent[kWITHUSERUSERNAME] as! String, type: kGROUP, users: nil, avatarOfGroup: recent[kAVATAR] as? String)
    }
}

// Delete recent

func deleteRecentChat(recentChatDictionary: NSDictionary) {
    if let recentId = recentChatDictionary[kRECENTID] {
        reference(.Recent).document(recentId as! String).delete()
    }
}
