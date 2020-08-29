//
//  HapticFeedback.swift
//  Flowerly
//
//  Created by Gokul Nair on 28/08/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import Foundation
import  AVKit

class hapticFeedback {

    func haptiFeedback1() {
  //print("haptick done")
  let generator = UINotificationFeedbackGenerator()
  generator.notificationOccurred(.success)
  }
  
 func haptiFeedback2() {
  //print("haptick done")
  let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.warning)
  }
}

