//
//  PlantInfoVC.swift
//  Plantipy
//
//  Created by Egehan Karaköse on 1.05.2020.
//  Copyright © 2020 Egehan Karaköse. All rights reserved.
//

import UIKit

class PlantInfoVC: UIViewController {

    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var familyText: UILabel!
    @IBOutlet weak var toxText: UILabel!
    @IBOutlet weak var shadeText: UILabel!
    @IBOutlet weak var salText: UILabel!
    @IBOutlet weak var fireText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    
    var name = ""
    var sal = ""
    var tox = ""
    var fire = ""
    var famName = ""
    var shade = ""
    var id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         if (name.caseInsensitiveCompare("") == .orderedSame){name = "Unknown"}
         if (sal.caseInsensitiveCompare("") == .orderedSame){sal = "Unknown"}
         if (tox.caseInsensitiveCompare("") == .orderedSame){tox = "Unknown"}
         if (fire.caseInsensitiveCompare("") == .orderedSame){fire = "Unknown"}
         if (famName.caseInsensitiveCompare("") == .orderedSame){famName = "Unknown"}
         if (shade.caseInsensitiveCompare("") == .orderedSame){shade = "Unknown"}
        
        nameText.text = name.uppercased()
        familyText.text = famName
        toxText.text = tox
        shadeText.text = shade
        salText.text = sal
        fireText.text = fire
        plantImageView.image = UIImage(named: id)

        
    }
    

   

}
