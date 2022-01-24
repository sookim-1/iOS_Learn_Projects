//
//  WelcomeViewController.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login")
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        print("register")
    }
    
    @IBAction func backgroundTap(_ sender: Any) {
        print("dismiss")
    }
    
}
