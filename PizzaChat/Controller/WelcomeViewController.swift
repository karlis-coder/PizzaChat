//
//  WelcomeViewController.swift
//  PizzaChat
//
//  Created by Karlis Butins on 22/02/2021.
//  Copyright © 2021 Karlis Butins. All rights reserved.
//

import UIKit
import CLTypingLabel
class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel! //CLTypingLabel (cocoapod) animates textlabels
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = K.appName
        
    }
    

}
