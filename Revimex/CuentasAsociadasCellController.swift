//
//  CuentasAsociadasCellController.swift
//  Revimex
//
//  Created by Maquina 53 on 18/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material

class CuentasAsociadasCellContent: InfoCells{
    
    var idTipo: String! = CuentasAsociadasCellController.KEY;
    public var facebook:String?;
    public var gmail:String?;
    var controller: UITableViewCell!;
    
    func setController(controller: UITableViewCell!) {
        self.controller = controller as! CuentasAsociadasCellController;
    }
}

class CuentasAsociadasCellController: UITableViewCell,TextFieldDelegate {
    
    public static let KEY: String! = "CUENTAS_ASOCIADAS";
    
    @IBOutlet var txFlFacebook: TextField!
    @IBOutlet var txFlGmail: TextField!
    public var infoUserController:InfoUserController!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        txFlFacebook.placeholder = "Facebook: ";
        txFlFacebook.clearButtonMode = .whileEditing;
        txFlFacebook.placeholderAnimation = .default;
        txFlFacebook.keyboardType = .emailAddress;
        txFlFacebook.delegate = self;
        txFlFacebook.tag = 1;
        
        txFlGmail.placeholder = "Gmail: ";
        txFlGmail.clearButtonMode = .whileEditing;
        txFlGmail.keyboardType = .emailAddress;
        txFlGmail.placeholderAnimation = .default;
        txFlGmail.delegate = self;
        txFlGmail.tag = 2;
        
        selectionStyle = .none
        dis_enable();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func dis_enable(){
        txFlFacebook.isEnabled = !txFlFacebook.isEnabled;
        txFlFacebook.colorEnable();
        txFlGmail.isEnabled = !txFlGmail.isEnabled;
        txFlGmail.colorEnable();
    }

}
