//
//  Plant.swift
//  Plantipy
//
//  Created by Egehan Karaköse on 1.05.2020.
//  Copyright © 2020 Egehan Karaköse. All rights reserved.
//

import Foundation



struct Plant : Codable{
    
    let common_name: String
    let complete_data: Bool
    let id: Int
    let link: String
    let scientific_name: String
    let slug: String
    
    
    enum  CodingKeys: String, CodingKey {
        case common_name
        case complete_data
        case id
        case link
        case scientific_name
        case slug
       

    }
}
