//
//  LineasNegociosControllerViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class LineasNegociosController: UIViewController {
    
    @IBOutlet weak var btnBrokerage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setCustomBackgroundAndNavbar()
    }
    
    @IBAction func actionBrokerage(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let formContainer = storyboard.instantiateViewController(withIdentifier: "MisBrokerage");
        navigationController?.pushViewController(formContainer, animated: true);
    }
    
    
}
