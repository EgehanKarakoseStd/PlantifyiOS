//
//  Plant.swift
//  Plantipy
//
//  Created by Egehan Karaköse on 1.05.2020.
//  Copyright © 2020 Egehan Karaköse. All rights reserved.
//

import Foundation



struct Plant: Codable{
    
    let common_name: String?
    let complete_data: Bool?
    let family_common_name : String?
    let specifications: Specifications
    let growth: Growth
    

    
    
    
}
