//
//  OnBoardingViewController.swift
//  Flowerly
//
//  Created by Gokul Nair on 28/08/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.layer.cornerRadius = 20
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        self.dismiss(animated:true)
        core.shared.setIsNotNewUser()
    }

}
