//
//  RowButtonsCellController.swift
//  Revimex
//
//  Created by Maquina 53 on 18/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class RowButtonsCellContent:InfoCells{
    var idTipo: String! = RowButtonsCellController.KEY;
    public var imgBtnEd:UIImage!;
    var controller: UITableViewCell!;
    
    init(imgBtn:UIImage?) {
        self.imgBtnEd = imgBtn;
    }
    func setController(controller: UITableViewCell!) {
        self.controller = controller as! RowButtonsCellController;
    }
}

class RowButtonsCellController: UITableViewCell {
    
    public static let KEY: String! = "ROW_BUTTONS";
    
    public var infoUserController:InfoUserController!;
    @IBOutlet var btnEditar: FABButton!
    @IBOutlet var btnGuardar: RaisedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnEditar.image = Icon.edit;
        btnEditar.tintColor = UIColor.black;
        btnEditar.pulseColor = .white;
        btnEditar.backgroundColor = Color.lightBlue.base;
        btnEditar.addTarget(self, action: #selector(editar), for: .touchUpInside);
        
        btnGuardar.title = "Guardar";
        btnGuardar.titleColor = Color.black;
        btnGuardar.backgroundColor = Color.lightBlue.base;
        btnGuardar.pulseColor = .white;
        btnGuardar.addTarget(self, action: #selector(guardarInfo), for: .touchUpInside);
        btnGuardar.isHidden = true;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func set(datos: RowButtonsCellContent){
        btnEditar.setBackgroundImage(datos.imgBtnEd, for: .application);
    }
    
    @objc func editar(){
        infoUserController.EnableEdit();
        btnGuardar.isHidden = false;
        btnEditar.isHidden = true;
    }
    
    @objc func guardarInfo() {
        infoUserController.actionGuardar();
        btnEditar.isHidden = false;
        btnGuardar.isHidden = true;
        infoUserController.disable_EnableAllSub();
        infoUserController.infoCargada = false;
    }
    
}
