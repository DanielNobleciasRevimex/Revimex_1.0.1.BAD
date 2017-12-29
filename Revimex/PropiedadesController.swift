//
//  PropiedadesController.swift
//  Revimex
//
//  Created by Maquina 53 on 05/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import FontAwesome_swift

class PropiedadesController: UIViewController {
    
    @IBOutlet weak var sgCtrlPropiedades: UISegmentedControl!
    @IBOutlet weak var cnVwPropiedades: UIView!
    @IBOutlet weak var btnNvPropiedad_Inversion: UIButton!
    @IBOutlet weak var labelSeccion: UILabel!
    
    var misPropiedades: MisPropiedadesController!;
    var misInversiones: UIViewController!;
    
    
    
    private var activeViewController: UIViewController?{
        didSet{
            removeInactiveViewController(inactiveViewController: oldValue);
            updateActiveViewController();
        }
    }
    
    override func viewDidLoad() {
        labelSeccion.isHidden = false;
        if((UserDefaults.standard.object(forKey: "userId") as? Int) != nil){
            super.viewDidLoad();
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            misPropiedades = storyboard.instantiateViewController(withIdentifier: "MisPropiedades") as! MisPropiedadesController;
            misInversiones = storyboard.instantiateViewController(withIdentifier: "MisInversiones");
            activeViewController = misPropiedades;
            labelSeccion.isHidden = true;
            
            
            btnNvPropiedad_Inversion.titleLabel?.font = UIFont.fontAwesome(ofSize: 36);
            btnNvPropiedad_Inversion.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal);
            btnNvPropiedad_Inversion.backgroundColor = UIColor.white;
            btnNvPropiedad_Inversion.layer.cornerRadius = 18;
            btnNvPropiedad_Inversion.layer.shadowRadius = 1.2;
            btnNvPropiedad_Inversion.layer.shadowColor = UIColor.black.cgColor;
            btnNvPropiedad_Inversion.layer.shadowOffset = CGSize(width: 0.8, height: 0.8);
            btnNvPropiedad_Inversion.layer.shadowOpacity = 0.8;
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(changeContentView(_:)));
            rightSwipe.direction = .right;
            
            if(misPropiedades.data.count <= 0 ){
                labelSeccion.text = "No hay propiedades";
                labelSeccion.isHidden = false;
            }
            
        }else{
            sgCtrlPropiedades.isHidden = true;
            cnVwPropiedades.isHidden = true;
            btnNvPropiedad_Inversion.isHidden = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?){
        if let inactiveVC = inactiveViewController{
            inactiveVC.willMove(toParentViewController: nil);
            inactiveVC.view.removeFromSuperview();
            inactiveVC.removeFromParentViewController();
        }
    }
    
    private func updateActiveViewController(){
        if let activeVC = activeViewController{
            addChildViewController(activeVC);
            activeVC.view.frame = cnVwPropiedades.bounds;
            cnVwPropiedades.addSubview(activeVC.view);
            activeVC.didMove(toParentViewController: self);
        }
    }
    
    @IBAction func nvPropiedad_Inversion(_ sender: UIButton) {
        performSegue(withIdentifier: "nvPropiedad", sender: nil);
    }
    
    @IBAction func changeContentView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            activeViewController = misPropiedades;
            break;
        case 1:
            activeViewController = misInversiones;
            labelSeccion.text = "No hay Inversiones";
            break;
        default:
            break;
            
        }
    }
    
}
