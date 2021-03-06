//
//  LoginViewController.swift
//  PizzaChat
//
//  Created by Karlis Butins on 22/02/2021.
//  Copyright © 2021 Karlis Butins. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
// Login button with firebase authentication
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {  //debug
                    print(e)
                } else {
                    // go back to LoginViewController
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
}
