//
//  InputCellText.swift
//  Revimex
//
//  Created by Maquina 53 on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

@IBDesignable
class InputCellText: UITableViewCell {
    
    public static let KEY = "CELL_TEXT";
    
    @IBOutlet weak var labelNombreCampo: UILabel!
    @IBOutlet weak var txFlCampo: UITextField!
    @IBOutlet weak var contenedor: UIView!
    
    public var idString:String?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
