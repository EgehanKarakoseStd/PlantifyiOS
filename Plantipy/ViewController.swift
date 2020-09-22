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
import Network

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var InfoButtonView: UIStackView!
    @IBOutlet weak var classificationLable: UILabel!
    @IBOutlet weak var imageViewer: UIImageView!
    
    var plantApi  = PlantAPI()
    var d : Data!
    var d2 : Data!
    
    var id = 0
    var id2 = 0
    
    var datas = DataSet()
                                                                              
    var classificationResult = ""
    var classificationResult2 = ""
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    var connectivity = false
    
    
    
    override func viewDidLoad() {
        InfoButtonView.isHidden = true
        
         monitor.pathUpdateHandler = { pathUpdateHandler in
                         if pathUpdateHandler.status == .satisfied {
                             print("Internet connection is on.")
                             self.connectivity = true
                         } else {
                             self.classificationLable.text = "There's No Internet Connection.\n Please Connect to The Internet and Restart App"
                             self.connectivity = false
                         }
                     }

                     monitor.start(queue: queue)
        
       
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
        
        
        for i in datas.species{
            if(i.title.caseInsensitiveCompare(name) == .orderedSame){
                id = i.id
            }

        }
        print(name)
        print(id)
        
        plantApi.getPlantInfo(id: id) { (data) in
            if let data = data {
                self.d = data
                
            }
        }
       
        getPlantInfo2(name: classificationResult2)
        
        
        
    }
    
    func getPlantInfo2(name: String){
            
        
        for i in datas.species{
                   if(i.title.caseInsensitiveCompare(name) == .orderedSame){
                       id2 = i.id
                   }

               }
            
            plantApi.getPlantInfo(id: id2) { (data) in
                if let data = data {
                    self.d2 = data
                    
                }
            }
        print(name)
        print(id2)
        
        if (connectivity == true){
             InfoButtonView.isHidden = false
        }
       
            
            
            
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
        
        if (segue.identifier == "toInfo"){
            guard let plantInfoVC = segue.destination as? PlantInfoVC else{return}
            
    
            plantInfoVC.name = d.data.common_name ?? "Unknown"
            plantInfoVC.sal = d.data.growth.soil_salinity ?? "Unknown"
            plantInfoVC.tox = d.data.specifications.toxicity ?? "Unknown"
            plantInfoVC.famName = d.data.family_common_name ?? "Unknown"
            plantInfoVC.fire = d.data.growth.soil_humidity ?? "Unknown"
            plantInfoVC.shade = d.data.growth.soil_nutriments ?? "Unknown"
            plantInfoVC.id = String(id)
            
    }
        else if (segue.identifier == "toInfo2"){
            guard let plantInfoVC = segue.destination as? PlantInfoVC else{return}
            
                plantInfoVC.name = d2.data.common_name ?? "Unknown"
                plantInfoVC.sal = d2.data.growth.soil_salinity ?? "Unknown"
                plantInfoVC.tox = d2.data.specifications.toxicity ?? "Unknown"
                plantInfoVC.famName = d2.data.family_common_name ?? "Unknown"
                plantInfoVC.fire = d2.data.growth.soil_humidity ?? "Unknown"
                plantInfoVC.shade = d2.data.growth.soil_nutriments ?? "Unknown"
                plantInfoVC.id = String(id2)
                
        }
    
}
}



