//
//  UbiacionExtraInmuebleController.swift
//  Revimex
//
//  Created by Maquina 53 on 26/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class UbicacionExtraInmuebleController: UIViewController, FormValidate{
    var rows: [String : Any?]?
    
    
    @IBOutlet weak var txFlCodigoPostal: TextField!
    @IBOutlet weak var txFlEstado: TextField!
    @IBOutlet weak var txFlMunicipio: TextField!
    @IBOutlet weak var txFlColonia: TextField!
    @IBOutlet weak var txFlCalle: TextField!
    @IBOutlet weak var txFlNumeroExt: TextField!
    @IBOutlet weak var txFlNumeroInt: TextField!
    @IBOutlet weak var txFlManzana: TextField!
    @IBOutlet weak var txFlLote: TextField!
    
    public var subirPropiedad:SubirPropiedadViewController!;
    

    override func viewDidLoad() {
        super.viewDidLoad();
        iniTextFileds();
    }

    
    override func viewWillAppear(_ animated: Bool) {
        iniTextFileds();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func iniTextFileds(){
        
        txFlCodigoPostal.placeholder = "Código Postal: ";
        txFlCodigoPostal.text = rows!["codigoPostal"] as! String!;
        txFlCodigoPostal.isEnabled = false;
        txFlCodigoPostal.colorEnable();
        
        txFlEstado.placeholder = "Estado: ";
        txFlEstado.text = rows!["estado"] as! String!;
        txFlEstado.isEnabled = false;
        txFlEstado.colorEnable();
        
        txFlMunicipio.placeholder = "Municipio: ";
        txFlMunicipio.text = rows!["municipio"] as! String!;
        txFlMunicipio.isEnabled = false;
        txFlMunicipio.colorEnable();
        
        txFlColonia.placeholder = "Colonia: ";
        txFlColonia.text = rows!["colonia"] as! String!;
        txFlColonia.isEnabled = false;
        txFlColonia.colorEnable();
        
        txFlCalle.placeholder = "Calle: ";
        txFlCalle.text = rows!["calle"] as! String!;
        txFlCalle.isEnabled = false;
        txFlCalle.colorEnable();
        
        txFlNumeroExt.placeholder = "Numero Exterior: ";
        txFlNumeroExt.text = rows!["numeroExterior"] as! String!;
        txFlNumeroExt.isEnabled = false;
        txFlNumeroExt.colorEnable();
        
        txFlNumeroInt.placeholder = "Número Interior: ";
        txFlNumeroInt.isEnabled = true;
        txFlNumeroInt.colorEnable();
        
        txFlManzana.placeholder = "Manzana: ";
        txFlManzana.isEnabled = true;
        txFlManzana.colorEnable();
        
        txFlLote.placeholder = "Lote: ";
        txFlLote.isEnabled = true;
        txFlLote.colorEnable();
        
    }
    
    func obtValores() -> [String : Any?]! {
        rows!["numeroInterior"] = self.txFlNumeroInt.getActualText()! ;
        rows!["manzana"] = self.txFlManzana.getActualText()!;
        rows!["lote"] = self.txFlLote.getActualText()!;
        rows!["tipoCalle"] = "Calle";
        return rows;
    }
    
    func esValido() -> Bool {
        var valido = false;
        let alert = UIAlertController(title: " ¡Aviso! ", message: "¿Esta seguro que ha comprobado su información?", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: .default){action in
            self.subirPropiedad.byPass();
            valido = true;
        });
        alert.addAction(UIAlertAction(title: "NO", style: .default){action in
            valido = false;
        });
        self.present(alert, animated: true, completion: nil);
        return valido;
    }
    
}
