//
//  Carrito.swift
//  Revimex
//
//  Created by Seifer on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class Carrito: NSObject {
    
    var idPropiedad: String
    var estado: String
    var precio: String
    var referencia: String
    var fechaAgregado: String
    var foto: UIImage
    var urlPropiedad: String
    
    init(idPropiedad: String,estado: String, precio: String, referencia: String, fechaAgregado: String, foto: UIImage, urlPropiedad: String){
        self.idPropiedad = idPropiedad
        self.estado = estado
        self.precio = precio
        self.referencia = referencia
        self.fechaAgregado = fechaAgregado
        self.foto = foto
        self.urlPropiedad = urlPropiedad
    }
    
}
