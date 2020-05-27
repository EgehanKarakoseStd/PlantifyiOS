//
//  ViewController.swift
//  Plantipy
//
//  Created by Egehan Karaköse on 29.12.2019.
//  Copyright © 2019 Egehan Karaköse. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var InfoButtonView: UIStackView!
    @IBOutlet weak var classificationLable: UILabel!
    @IBOutlet weak var imageViewer: UIImageView!
    
    var plantApi  = PlantAPI()
    var plant : Plant!
    var plant2 : Plant!
    
    var id = 0
    var id2 = 0
    
    var data = DataSet()
                                                                              
    var classificationResult = ""
    var classificationResult2 = ""
    
    
    
    override func viewDidLoad() {
        InfoButtonView.isHidden = true
    }
    
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do{
            let model = try VNCoreMLModel(for: MyImageClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: {(request, error) in
                
                self.processClassifications(for: request, error: error)
                
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        }catch{
            fatalError("Failed to lead Core ML Model: \(error)")
        }
    }()
  
    
    func processClassifications(for request: VNRequest , error : Error?){
        guard let classifications = request.results as? [VNClassificationObservation] else {
            
            self.classificationLable.text = "Unable to classify image. \n\(error?.localizedDescription ?? "Error")"
            return
        }
        
        if classifications.isEmpty{
            self.classificationLable.text = "nothing recognized. \nPlease Try Again."
        }else{
            let topClassification = classifications.prefix(2)
            let descriptions = topClassification.map { classification in
                return String(format: "%.2f", classification.confidence * 100) + "% - " + classification.identifier.replacingOccurrences(of: "_", with: " ")
            }
            
            classificationResult = topClassification[0].identifier
            classificationResult = classificationResult.replacingOccurrences(of: "_", with: " ")
            
            classificationResult2 = topClassification[1].identifier
            classificationResult2 = classificationResult2.replacingOccurrences(of: "_", with: " ")
            
            self.classificationLable.text = "Classification:\n" + descriptions.joined(separator:"\n")
           
            getPlantInfo(name: classificationResult)
            
            
        }
        
        
        
    }
    
    func updateClassifications(for image: UIImage){
        classificationLable.text = "Classifying..."
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)),
            let ciImage = CIImage(image: image) else{
            print("Something went wrong")
            return
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
        do{
          try handler.perform([classificationRequest])
        }catch{
            print("failed perform classification. \(error.localizedDescription)")
        }
       
    }

    @IBAction func cameraButtonWasPressed(_ sender: Any) {
        
        InfoButtonView.isHidden = true
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.presentPhotoPicker(sourceType: .camera)
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose Photo ", style: .default) { (_) in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        
        photoSourcePicker.addAction(takePhotoAction)
        photoSourcePicker.addAction(choosePhotoAction)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(photoSourcePicker, animated: true , completion: nil)
    }
    
    func presentPhotoPicker(sourceType : UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker,animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageViewer.image = image
        updateClassifications(for: image)
    }
    
    
    func getPlantInfo(name: String){
        
        
        for i in data.species{
            if(i.title.caseInsensitiveCompare(name) == .orderedSame){
                id = i.id
            }

        }
        print(name)
        print(id)
        
        plantApi.getPlantInfo(id: id) { (plant) in
            if let plant = plant {
                self.plant = plant
                
            }
        }
       
        getPlantInfo2(name: classificationResult2)
        
        
        
    }
    
    func getPlantInfo2(name: String){
            
        
        for i in data.species{
                   if(i.title.caseInsensitiveCompare(name) == .orderedSame){
                       id2 = i.id
                   }

               }
            
            plantApi.getPlantInfo(id: id2) { (plant) in
                if let plant = plant {
                    self.plant2 = plant
                    
                }
            }
        print(name)
        print(id2)
        InfoButtonView.isHidden = false
            
            
            
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
        
        if (segue.identifier == "toInfo"){
            guard let plantInfoVC = segue.destination as? PlantInfoVC else{return}
            
            plantInfoVC.name = plant.common_name ?? "Unknown"
            plantInfoVC.sal = plant.growth.salinity_tolerance ?? "Unknown" 
            plantInfoVC.tox = plant.specifications.toxicity ?? "Unknown"
            plantInfoVC.famName = plant.family_common_name ?? "Unknown"
            plantInfoVC.fire = plant.growth.fire_tolerance ?? "Unknown"
            plantInfoVC.shade = plant.growth.shade_tolerance ?? "Unknown"
            plantInfoVC.id = String(id)
            
    }
        else if (segue.identifier == "toInfo2"){
            guard let plantInfoVC = segue.destination as? PlantInfoVC else{return}
            
                plantInfoVC.name = plant2.common_name ?? "Unknown"
                plantInfoVC.sal = plant2.growth.salinity_tolerance ?? "Unknown"
                plantInfoVC.tox = plant2.specifications.toxicity ?? "Unknown"
                plantInfoVC.famName = plant2.family_common_name ?? "Unknown"
                plantInfoVC.fire = plant2.growth.fire_tolerance ?? "Unknown"
                plantInfoVC.shade = plant2.growth.shade_tolerance ?? "Unknown"
                plantInfoVC.id = String(id2)
                
        }
    
}
}



