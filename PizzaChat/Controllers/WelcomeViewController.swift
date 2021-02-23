//
//  WelcomeViewController.swift
//  PizzaChat
//
//  Created by Karlis Butins on 22/02/2021.
//

import UIKit
import CLTypingLabel
class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "🍕PizzaChat"
        
    }
    

}
