//
//  DatosPersonalesCellController.swift
//  Revimex
//
//  Created by Maquina 53 on 18/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class DatosPersonalesCellContent: InfoCells{
    
    var idTipo: String! = DatosPersonalesCellController.KEY;
    var controller: UITableViewCell!;
    
    public var nombre:String?;
    public var pApellido:String?;
    public var sApellido:String?;
    public var telefono:String?;
    public var rfc:String?;
    public var direccion:String?;
    public var nacimiento:String?;
    public var facebook:String?;
    public var gmail:String?;
    
    func setController(controller: UITableViewCell!) {
        self.controller = controller as! DatosPersonalesCellController;
    }
}

class DatosPersonalesCellController: UITableViewCell,TextFieldDelegate {
    
    public static let KEY: String! = "DATOS_PERSONALES";
    
    @IBOutlet var txFlNombre: TextField!
    @IBOutlet var txFlPApellido: TextField!
    @IBOutlet var txFlSApellido: TextField!
    @IBOutlet var txFlTelefono: TextField!
    @IBOutlet var txFlRFC: TextField!
    @IBOutlet var txFlDireccion: TextField!
    @IBOutlet var tcFlNacimiento: TextField!
    
    public var infoUserController:InfoUserController!;
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        txFlNombre.placeholder = "Nombre: "
        txFlNombre.clearButtonMode = .whileEditing;
        txFlNombre.placeholderAnimation = .default;
        txFlNombre.delegate = self;
        txFlNombre.tag = 1;
        
        txFlPApellido.placeholder = "Apellido Paterno: ";
        txFlPApellido.clearButtonMode = .whileEditing;
        txFlPApellido.placeholderAnimation = .default;
        txFlPApellido.delegate = self;
        txFlPApellido.tag = 2;
        
        txFlSApellido.placeholder = "Apellido Materno: ";
        txFlSApellido.clearButtonMode = .whileEditing;
        txFlSApellido.placeholderAnimation = .default;
        txFlSApellido.delegate = self;
        txFlSApellido.tag = 3;
        
        txFlTelefono.placeholder = "Teléfono: ";
        txFlTelefono.clearButtonMode = .whileEditing;
        txFlTelefono.placeholderAnimation = .default;
        txFlTelefono.delegate = self;
        txFlTelefono.tag = 4;
        
        txFlRFC.placeholder = "RFC: ";
        txFlRFC.clearButtonMode = .whileEditing;
        txFlRFC.delegate = self;
        txFlRFC.placeholderAnimation = .default;
        txFlRFC.tag = 5;
        
        
        txFlDireccion.placeholder = "Dirección: ";
        txFlDireccion.clearButtonMode = .whileEditing;
        txFlDireccion.placeholderAnimation = .default;
        txFlDireccion.delegate = self;
        txFlDireccion.tag = 6;
        
        tcFlNacimiento.placeholder = "Fecha de Nacimiento: ";
        tcFlNacimiento.clearButtonMode = .whileEditing;
        tcFlNacimiento.placeholderAnimation = .default;
        tcFlNacimiento.delegate = self;
        tcFlNacimiento.tag = 7;
        
        selectionStyle = .none;
        dis_enable();
        
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func dis_enable(){
        
        txFlNombre.isEnabled = !txFlNombre.isEnabled;
        txFlNombre.colorEnable();
        
        txFlPApellido.isEnabled = !txFlPApellido.isEnabled;
        txFlPApellido.colorEnable();
        txFlSApellido.isEnabled = !txFlSApellido.isEnabled;
        txFlSApellido.colorEnable();
        
        txFlTelefono.isEnabled = !txFlTelefono.isEnabled;
        txFlTelefono.colorEnable();
        txFlTelefono.keyboardType = .namePhonePad;
        
        txFlRFC.isEnabled = !txFlRFC.isEnabled;
        txFlRFC.colorEnable();
        txFlRFC.isPlaceholderUppercasedWhenEditing = true;
        
        txFlDireccion.isEnabled = !txFlDireccion.isEnabled;
        txFlDireccion.colorEnable();
        
        tcFlNacimiento.isEnabled = !tcFlNacimiento.isEnabled;
        tcFlNacimiento.keyboardType = .numbersAndPunctuation
        tcFlNacimiento.colorEnable();
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
