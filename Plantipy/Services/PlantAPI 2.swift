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
    func getRandomPersonAlamo(name: String, completion: @escaping PlantResponseCompletion) {
        
        
        guard let url = URL(string: "\(URL_BASE)\(name)" ) else { return }
        AF.request(url).responseJSON { (response) in
            if let error = response.error{
                debugPrint(error.localizedDescription)
                completion(nil)
                return
                
            }
            
            guard let data = response.data  else { return completion(nil) }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let person = try jsonDecoder.decode(Plant.self, from: data)
                completion(person)
            }catch{
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
    private func parsePersonSwifty(json: JSON) -> Plant {
           
            let common_name = json["common_name"].stringValue
            let complete_data = json["complete_data"].boolValue
            let id = json["id"].intValue
            let link = json["link"].stringValue
            let scientific_name = json["scientific_name"].stringValue
            let slug = json["slug"].stringValue
 
           
           
        return Plant(common_name: common_name, complete_data : complete_data, id : id, link : link, scientific_name : scientific_name, slug : slug)
           
           
       }
    
}

   
