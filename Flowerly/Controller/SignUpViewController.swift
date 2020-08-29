//
//  SignUpViewController.swift
//  Flowerly
//
//  Created by Gokul Nair on 28/08/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let haptic = hapticFeedback()

    override func viewDidLoad() {
        super.viewDidLoad()

       let leftswipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        view.addGestureRecognizer(leftswipe)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
           
             self.navigationController?.popToRootViewController(animated: true)
         }
      
    @IBAction func signInBtn(_ sender: Any) {
        performSegue(withIdentifier: "tohome", sender: nil)
        haptic.haptiFeedback1()
    }
    
}
