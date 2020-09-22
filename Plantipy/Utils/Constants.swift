//
//  Constants.swift
//  Plantipy
//
//  Created by Egehan Karaköse on 1.05.2020.
//  Copyright © 2020 Egehan Karaköse. All rights reserved.
//

import UIKit

let WHITE_BG = UIColor.white.withAlphaComponent(0.6).cgColor
let MAIN_BG = UIColor.blue.withAlphaComponent(0.1).cgColor
let BLACK_BG = UIColor.black.withAlphaComponent(0.6).cgColor
let URL_BASE = "https://trefle.io/api/v1/species/"
let URL_REST = "?token=SFhGekpZVThFZmtSdWlOb1V5aFFHZz09"



typealias PlantResponseCompletion = (Data?) -> Void
