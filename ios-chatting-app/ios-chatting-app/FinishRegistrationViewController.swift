//
//  FinishRegistrationViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import UIKit
import ProgressHUD

class FinishRegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var email: String!
    var password: String!
    var avatarImage: UIImage? // 아바타 이미지는 선택옵션
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(email, password)
    }
 
    // MARK: - IBActions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cleanTextFields()
        dismissKeyboard()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        ProgressHUD.show("회원등록 중")
        
        if nameTextField.text != "" && surnameTextField.text != "" && countryTextField.text != "" && cityTextField.text != "" && phoneTextField.text != "" {
            
            FUser.registerUserWith(email: email!, password: password!, firstName: nameTextField.text!, lastName: surnameTextField.text!) { error in
                if error != nil {
                    ProgressHUD.dismiss()
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                
                self.registerUser()
            }
        } else {
            ProgressHUD.showError("비어있는 항목을 확인해주세요!")
        }
    }
    
    // MARK: - Helpers
    
    // 국가별 전화번호 같은 세부적인 커스텀세팅
    func registerUser() {
        let fullName = nameTextField.text! + " " + surnameTextField.text!
        
        // 상수 와 값 연결
        var tempDictonary: Dictionary = [
            kFIRSTNAME : nameTextField.text!,
            kLASTNAME : surnameTextField.text!,
            kFULLNAME : fullName,
            kCOUNTRY : countryTextField.text!,
            kCITY : cityTextField.text!,
            kPHONE : phoneTextField.text!
        ] as [String : Any]
        
        if avatarImage == nil {
            imageFromInitials(firstName: nameTextField.text!, lastName: surnameTextField.text!) { avatarInitials in
                let avatarIMG = avatarInitials.jpegData(compressionQuality: 0.7) // 이미지 -> 데이터
                let avatar = avatarIMG?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) // 데이터로 가져온 후 저장할 수 있도록 문자열로 변환
                
                tempDictonary[kAVATAR] = avatar
                
                self.finishRegistration(withValues: tempDictonary)
            }
        } else {
            let avatarData = avatarImage?.jpegData(compressionQuality: 0.7)
            let avatar = avatarData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            tempDictonary[kAVATAR] = avatar
            
            self.finishRegistration(withValues: tempDictonary)
        }
        
    }
    
    func finishRegistration(withValues: [String : Any]) {
        updateCurrentUserInFirestore(withValues: withValues) { error in
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error?.localizedDescription)
                }
                
                return
            }
            
            ProgressHUD.dismiss()
            self.goToApp()
        }
    }
    
    func goToApp() {
        cleanTextFields()
        dismissKeyboard()
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func cleanTextFields() {
        nameTextField.text = ""
        surnameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
    }
    
}
