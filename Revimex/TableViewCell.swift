//
//  TableViewCell.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit


class TableViewCell: UITableViewCell {

    @IBOutlet weak var vistaFoto: UIImageView!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var referencia: UILabel!
    
    
    var idOfertaActual: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func irDetalles(_ sender: Any) {
        idOfertaSeleccionada = idOfertaActual
    }
    
  
    
}
