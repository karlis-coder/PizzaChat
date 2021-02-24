//
//  RegisterViewController.swift
//  PizzaChat
//
//  Created by Karlis Butins on 22/02/2021.
//  Copyright © 2021 Karlis Butins. All rights reserved.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
// Register button functionality, creates new user in firebase if textfield criteria is met
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error { //debug
                    print(e.localizedDescription)
                } else {
                    // go back to ChatViewController
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
        }
    
    }

    }
    
}
