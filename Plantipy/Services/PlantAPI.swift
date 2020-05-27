//
//  PlantAPI.swift
//  Plantipy
//
//  Created by Egehan Karaköse on 1.05.2020.
//  Copyright © 2020 Egehan Karaköse. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class PlantAPI{
    
    //    Web Request with Alamofire and Codable
    func getPlantInfo(id: Int, completion: @escaping PlantResponseCompletion) {
        
        
        guard let url = URL(string: "\(URL_BASE)\(id)\(URL_REST)" ) else { return }
        AF.request(url).responseJSON { (response) in
            if let error = response.error{
                debugPrint(error.localizedDescription)
                completion(nil)
                return
                
            }
            
            guard let data = response.data  else { return completion(nil) }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let plant = try jsonDecoder.decode(Plant.self, from: data)
                completion(plant)
            }catch{
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
   
    
}

   
