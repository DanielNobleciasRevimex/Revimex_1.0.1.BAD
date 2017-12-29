//
//  LineasNegocioViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 29/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class LineasNegocioViewController: UIViewController {
    
    @IBOutlet weak var bannerUser: UserInfoCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerUser.imgUser.image = UIImage.fontAwesomeIcon(name: .userO, textColor: .black, size: CGSize(width: 500, height: 500));
        bannerUser.imgBackground.image = UIImage.fontAwesomeIcon(name: .userO, textColor: .black, size: CGSize(width: 500, height: 500));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
