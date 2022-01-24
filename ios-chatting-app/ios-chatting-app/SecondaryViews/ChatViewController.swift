//
//  ChatViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/25.
//

import UIKit
import JSQMessagesViewController
import ProgressHUD
import IQAudioRecorderController
import IDMPhotoBrowser
import AVFoundation
import AVKit
import FirebaseFirestore

class ChatViewController: JSQMessagesViewController {

    var outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    
    var incomingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(self.backAction))]
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.senderId = FUser.currentId()
        self.senderDisplayName = FUser.currentUser()!.firstname
        
        //custom send button
        self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "mic"), for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal)
        
        // MARK: - JSQMessages라이브러리 SafeArea이슈 해결방법 - 3 작동안함
        /*
         ------------------------------------------------------------------------
        let constraint = perform(Selector(("toolbarBottomLayoutGuide")))?.takeUnretainedValue() as! NSLayoutConstraint

        constraint.priority = UILayoutPriority(rawValue: 1000)

        self.inputToolbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
         
         override func viewDidLayoutSubviews() {
             perform(Selector(("jsq_updateCollectionViewInsets")))
         }
         --------------------------------------------------------------------------
         */
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - JSQMessage Delegate functions
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoOrVideo = UIAlertAction(title: "카메라", style: .default) { action in
            print("카메라")
        }
        
        let sharePhoto = UIAlertAction(title: "사진 앨범", style: .default) { action in
            print("사진 앨범")
        }
        
        let shareVideo = UIAlertAction(title: "동영상 앨범", style: .default) { action in
            print("동영상 앨범")
        }
        
        let shareLocation = UIAlertAction(title: "위치 전송", style: .default) { action in
            print("위치 전송")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
            
        }
        
        takePhotoOrVideo.setValue(UIImage(named: "camera"), forKey: "image")
        sharePhoto.setValue(UIImage(named: "picture"), forKey: "image")
        shareVideo.setValue(UIImage(named: "video"), forKey: "image")
        shareLocation.setValue(UIImage(named: "location"), forKey: "image")
        
        optionMenu.addAction(takePhotoOrVideo)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(shareVideo)
        optionMenu.addAction(shareLocation)
        optionMenu.addAction(cancelAction)
        
        // iPad도 ActionSheet대응 처리 방법
        if ( UI_USER_INTERFACE_IDIOM() == .pad )
        {
            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController{
                
                currentPopoverpresentioncontroller.sourceView = self.inputToolbar.contentView.leftBarButtonItem
                currentPopoverpresentioncontroller.sourceRect = self.inputToolbar.contentView.leftBarButtonItem.bounds
                
                currentPopoverpresentioncontroller.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }
        }else{
            self.present(optionMenu, animated: true, completion: nil)
        }
        
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print("send")
    }
}

extension JSQMessagesInputToolbar {
    // MARK: - JSQMessages라이브러리 SafeArea이슈 해결방법 -1 정상
    override open func didMoveToWindow() {
      super.didMoveToWindow()
      if #available(iOS 11.0, *) {
        if self.window?.safeAreaLayoutGuide != nil {
            self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: (self.window?.safeAreaLayoutGuide.bottomAnchor)!, multiplier: 1.0).isActive = true
        }
      }
    }
     
     
    // MARK: - JSQMessages라이브러리 SafeArea이슈 해결방법 - 2 키보드는 같이 안올라옴
    /*------------------------------------------------------------------------
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window = window else { return }
        if #available(iOS 11.0, *) {
            guard let constraint = (superview?.constraints.first { $0.secondAnchor == bottomAnchor }) else { return }
            let anchor = window.safeAreaLayoutGuide.bottomAnchor
            NSLayoutConstraint.deactivate([constraint])
            bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: 1.0).isActive = true
        }
    }
    --------------------------------------------------------------------------
    */
}
