//
//  WelcomeViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            loginUser()
        } else {
            ProgressHUD.showError("이메일 및 패스워드를 입력해주세요!")
        }
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" {
            
            if passwordTextField.text == repeatPasswordTextField.text {
                registerUser()
            } else {
                ProgressHUD.showError("비밀번호가 맞지 않습니다!")
            }
        } else {
            ProgressHUD.showError("비어있는 항목을 확인해주세요!")
        }
    }
    
    @IBAction func backgroundTap(_ sender: Any) {
        dismissKeyboard()
    }
    
    // MARK: - HelperFunctions
    
    func loginUser() {
        ProgressHUD.show("로그인 중...")
        
        // 버튼 누르기전에 검사했기 때문에 강제옵셔널처리
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
            if error != nil {
                // localizedDescription : 에러를 사람이 알 수있는언어로 보여줌
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            self.goToApp()
        }
    }
    
    func registerUser() {
        performSegue(withIdentifier: "welcomeToFinishReg", sender: self)
        
        cleanTextFields()
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func cleanTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    
    //MARK: - GoToApp
    
    // 로그인 후 새로운화면은로 전환
    func goToApp() {
        ProgressHUD.dismiss()
        
        cleanTextFields()
        dismissKeyboard()
        
        print("show the app")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "welcomeToFinishReg" {
            let vc = segue.destination as! FinishRegistrationViewController
            vc.email = emailTextField.text!
            vc.password = passwordTextField.text!
        }
    }
}
