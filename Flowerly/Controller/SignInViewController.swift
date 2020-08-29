//
//  ViewController.swift
//  Flowerly
//
//  Created by Gokul Nair on 28/08/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import UIKit


class SignInViewController: UIViewController {
    
    let haptic = hapticFeedback()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if core.shared.isNewUser() {
            let vc = storyboard?.instantiateViewController(identifier: "onboarding") as! OnBoardingViewController
            present(vc, animated: true)
        }
    }
    @IBAction func signInBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "main", sender: nil)
        haptic.haptiFeedback1()
    }
    
    
}

//MARK:-  Onboarding Code

class core{
    
    static let shared = core()
    
    func isNewUser()->Bool {
        return !UserDefaults.standard.bool(forKey: "onboarding")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "onboarding")
    }
}

