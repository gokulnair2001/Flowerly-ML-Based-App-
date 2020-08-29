//
//  MainViewController.swift
//  Flowerly
//
//  Created by Gokul Nair on 28/08/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var flowerName: UILabel!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var scannedImage: UIImageView!
    @IBOutlet weak var precissionLabel: UILabel!
    @IBOutlet weak var capturedImageLabel: UILabel!
    @IBOutlet weak var flowerInfoLabel: UILabel!
    var imageLabler: VisionImageLabeler?
    var overlayView = UIView()
    let haptic = hapticFeedback()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanBtn.layer.cornerRadius = 10
        scannedImage.layer.cornerRadius = 20
        capturedImageLabel.isHidden = false
        initializeMLModel()
    }
    
    private func startAnimation(){
        activityIndicator.startAnimating()
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.backgroundColor = #colorLiteral(red: 0, green: 0.3376684487, blue: 0.3896867335, alpha: 1)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        activityIndicator.style = .medium
        activityIndicator.style = .large

        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
    }
    
    private func stopAnimation(){
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
    
    @IBAction func scanButton(_ sender: Any) {
        alertController()
        haptic.haptiFeedback1()
    }
    
    
}

//MARK:- Gallery photo selection method

extension MainViewController{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        var imageToSave: UIImage?
        
        if let originalImage = info[.originalImage] as? UIImage {
           imageToSave = originalImage
        }
        else if let editedImage = info[.editedImage] as? UIImage {
            imageToSave = editedImage
        }
        guard imageToSave != nil else{
               print("ot no image!")
               return
               }
        let visionImage = VisionImage(image: imageToSave!)
        performMLMagicOn(visionImage)
        
        self.scannedImage.image = imageToSave
       startAnimation()
        capturedImageLabel.isHidden = true

    }
    
    
    private func setupImageSelectionFromPhoto(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        
    }
   
}


//MARK:- Camera photo selection method

extension MainViewController {
    
    private func setupImageSelectionFromCamera(){
              
              if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                  let imagePicker = UIImagePickerController()
                  imagePicker.delegate = self
                  imagePicker.allowsEditing = true
                  imagePicker.sourceType = .camera
                  self.present(imagePicker, animated: true)
              }
              
          }
}

//MARK:- Alert action method

extension MainViewController{
    func alertController(){
        let alert = UIAlertController(title: "Select Mode", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Use Camera", style: .default, handler: setAction))
        alert.addAction(UIAlertAction(title: "Choose From Photo", style: .default, handler: setAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func setAction(action: UIAlertAction){
        
        if action.title == "Use Camera" {
            setupImageSelectionFromCamera()
            haptic.haptiFeedback1()
        }
        
        else if action.title == "Choose From Photo"{
            setupImageSelectionFromPhoto()
            haptic.haptiFeedback1()
        }
        
    }
}


//MARK:- ML model method

extension MainViewController{
    
    func initializeMLModel(){
       
        guard let manifestPath = Bundle.main.path(forResource: "manifest", ofType: "json", inDirectory: "DownloadedFlowerModels")
            else{
                print("manifest file not found")
                return
        }
        
        let myLocalModel = AutoMLLocalModel(manifestPath: manifestPath )
        let lablerOptions = VisionOnDeviceAutoMLImageLabelerOptions(localModel: myLocalModel)
        lablerOptions.confidenceThreshold = 0.5
        imageLabler = Vision.vision().onDeviceAutoMLImageLabeler(options: lablerOptions)
        
    }
    
    func performMLMagicOn(_ visionImage: VisionImage){
        imageLabler?.process(visionImage, completion: { (labels, error) in
            if let error = error{
                print("looks like we have some error: \(error.localizedDescription)")
                return
            }
            if let labels = labels{
                if labels.count == 0 {
                    self.flowerName.text = "Error!"
                    return
                }
                
                for visionLabel in labels {
                    let confidenceString = String(format: "%0.2f", (visionLabel.confidence ?? 0).doubleValue * 100)
                    let resultingFlowerString = "\(visionLabel)"
                    let resultingConfidenceString = "\(confidenceString)"
                    self.flowerName.text = resultingFlowerString
                    self.precissionLabel.text = resultingConfidenceString
                    self.info()
                }
                self.stopAnimation()
            }
        })
    }
}


extension MainViewController{
    func info(){
        switch flowerName.text {
        case "rose":
            flowerInfoLabel.text = "A rose is a woody perennial flowering plant of the genus Rosa, in the family Rosaceae, or the flower it bears. There are over three hundred species and tens of thousands of cultivars. They form a group of plants that can be erect shrubs, climbing, or trailing, with stems that are often armed with sharp prickles."
            break
        case "dandelion":
            flowerInfoLabel.text = "Taraxacum is a large genus of flowering plants in the family Asteraceae, which consists of species commonly known as dandelions. The genus is native to Eurasia and North America, but the two commonplace species worldwide, T. officinale and T. erythrospermum, were introduced from Europe and now propagate as wildflowers"
            break
        case "tulip":
            flowerInfoLabel.text = "Tulips form a genus of spring-blooming perennial herbaceous bulbiferous geophytes. The flowers are usually large, showy and brightly colored, generally red, pink, yellow, or white. They often have a different colored blotch at the base of the tepals, internally. Because of a degree of variability within the populations, and a long history of cultivation, classification has been complex and controversial."
            break
        case "sunflower":
            flowerInfoLabel.text = "Helianthus is a genus of plants comprising about 70 species. Except for three species in South America, all Helianthus species are native to North America and Central America. The common names 'sunflower' and 'common sunflower' typically refer to the popular annual species Helianthus annuus, whose round flower heads in combination with the ligules look like the sun."
            break
        case "daisy":
            flowerInfoLabel.text = "Daisy is a feminine given name. The flower name comes from the Old English word dægeseage, meaning 'day's eye'. The name Daisy is therefore ultimately derived from this source. Daisy is also a nickname for Margaret, used because Marguerite, the French version of that name, is also a French name for the oxeye daisy. It came into popular use in the late Victorian era along with other flower names. "
            break
        default:
            flowerInfoLabel.text = "No result found"
        }
    }
}


