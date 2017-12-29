//
//  ViewController.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var textoRegistro: UITextView!
    @IBOutlet weak var textoInvitado: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textoRegistro.isEditable = false
        textoInvitado.isEditable = false
        
        //asigna el color, logo y tamaño a la barra de navegacion
        let screenSize = UIScreen.main.bounds
        
        let navBar: UINavigationBar = UINavigationBar()
        navBar.frame = CGRect(x: 0.0,y: 0.0,width: screenSize.width,height: screenSize.height/5)  // Here you can set you Width and Height for your navBar
        navBar.backgroundColor = azul
        
        let logo = UIImage(named: "revimex.png")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: screenSize.width/4,y: screenSize.height/12,width: screenSize.width/2,height: screenSize.height/12)
        
        view.addSubview(navBar)
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.addSubview(imageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //apagan la bandera que indica que es la primera vez que se entra en la aplicacion
    @IBAction func crearCuentaTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isFirstTime")
        print(sender);
    }
    
    @IBAction func invitadoTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isFirstTime")
    }
    
    
}

