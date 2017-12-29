//
//  DescriptionViewController.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var vistasContainer: UIView!
    @IBOutlet weak var descripcionBtn: UIButton!
    @IBOutlet weak var serviciosBtn: UIButton!
    
    
    
    var info:UIViewController?
    var ubication:UIViewController?
    
    var arrayViews:[UIViewController?]!;
    
    private var actualViewController: UIViewController?{
        didSet{
            removeInactiveViewController(inactiveViewController: oldValue);
            updateActiveViewController();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        descripcionBtn.layer.borderWidth = 1
        descripcionBtn.layer.borderColor = UIColor.white.cgColor
        
        serviciosBtn.layer.borderWidth = 1
        serviciosBtn.layer.borderColor = UIColor.white.cgColor
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.tag = 100
        view.addSubview(visualEffectView)
        view.sendSubview(toBack: visualEffectView)
        
        propiedad = Details(Id: "",calle: "",colonia: "",construccion: "",cp: "",estacionamiento: "",estado: "",habitaciones: "",idp: "",lat: "0",lon: "0",municipio: "",niveles: "",origen_propiedad: "",patios: "",precio: "",terreno: "",tipo: "",descripcion: "",pros: "",wcs: "",fotos: [])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        info = storyboard.instantiateViewController(withIdentifier: "Info") as! InfoController
        ubication = storyboard.instantiateViewController(withIdentifier: "Ubication") as! UbicationContoller
        
        arrayViews = [info,ubication]
        
        actualViewController = arrayViews[0];
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        if propiedad.fotos.count > 0{
            descriptionImageBackground = Utilities.traerImagen(urlImagen: propiedad.fotos[0])
        }
        else{
            descriptionImageBackground = Utilities.traerImagen(urlImagen: "")
        }
        let contenedorImagen = UIImageView(image: descriptionImageBackground)
        contenedorImagen.frame = view.bounds
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contenedorImagen.addSubview(visualEffectView)
        view.addSubview(contenedorImagen)
        view.sendSubview(toBack: contenedorImagen)
        view.viewWithTag(100)?.removeFromSuperview()
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?){
        if let inactiveVC = inactiveViewController{
            inactiveVC.willMove(toParentViewController: nil);
            inactiveVC.view.removeFromSuperview();
            inactiveVC.removeFromParentViewController();
        }
    }
    
    private func updateActiveViewController(){
        if let activeVC = actualViewController{
            addChildViewController(activeVC);
            activeVC.view.frame = vistasContainer.bounds;
            vistasContainer.addSubview(activeVC.view);
            activeVC.didMove(toParentViewController: self);
        }
    }

    @IBAction func showDescription(_ sender: Any) {
        actualViewController = arrayViews[0];
    }
    
    @IBAction func showServices(_ sender: Any) {
        actualViewController = arrayViews[1];
    }
    
}
