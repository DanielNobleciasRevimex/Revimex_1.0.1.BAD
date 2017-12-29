//
//  DatosPrincipalesCellController.swift
//  Revimex
//
//  Created by Maquina 53 on 18/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class DatosPrincipalesCellContent:InfoCells{
    
    var idTipo: String! = DatosPrincipalesCellController.KEY;
    public var nombreUsuario:String?;
    public var residencia:String?;
    var controller: UITableViewCell!;
    
    
    func setController(controller: UITableViewCell!) {
        self.controller = controller as! DatosPrincipalesCellController;
    }
    
}

class DatosPrincipalesCellController: UITableViewCell,TextFieldDelegate {
    public static let KEY: String! = "DATOS_PRINCIPALES";
    public var table:UITableView!;
    
    @IBOutlet weak var content: UIView!
    @IBOutlet var txFlNombreUsuario: TextField!
    @IBOutlet var txFlResidencia: TextField!
    public var infoUserController:InfoUserController!;
    
    
    override func awakeFromNib() {
        super.awakeFromNib();
        print(content.bounds.height)
        //let alto = CGSize(width: content.bounds.width, height: txFlNombreUsuario.bounds.height + txFlResidencia.bounds.height + 24);
        //content.bounds.size = alto;
        
        
        txFlResidencia.placeholder = "Lugar de Residencia";
        txFlResidencia.placeholderAnimation = .default;
        txFlResidencia.delegate = self;
        txFlResidencia.layer.cornerRadius = 10;
        
        txFlNombreUsuario.placeholder = "Nombre de Usuario";
        txFlNombreUsuario.placeholderAnimation = .default;
        txFlNombreUsuario.delegate = self;
        txFlNombreUsuario.isEnabled = false;
        txFlNombreUsuario.layer.cornerRadius = 10;
        
        selectionStyle = .none;
        dis_enable();
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(datos: DatosPrincipalesCellContent!){
        txFlNombreUsuario.text = datos.nombreUsuario;
        txFlResidencia.text = datos.residencia;
    }
    
    func dis_enable(){
        txFlNombreUsuario.colorEnable();
        txFlResidencia.isEnabled = !txFlResidencia.isEnabled;
        txFlResidencia.colorEnable();
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func GetResidencia()->String?{
        self.updateFocusIfNeeded();
        return txFlResidencia.text;
    }
}
