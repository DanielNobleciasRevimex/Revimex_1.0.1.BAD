//
//  Details.swift
//  Revimex
//
//  Created by Seifer on 03/11/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class Details: NSObject {

    
    var Id: String
    var calle: String
    var colonia: String
    var construccion: String
    var cp: String
    var estacionamiento: String
    var estado: String
    var habitaciones: String
    var idp: String
    var lat: String
    var lon: String
    var municipio: String
    var niveles: String
    var origen_propiedad: String
    var patios: String
    var precio: String
    var terreno: String
    var tipo: String
    var descripcion: String
    var pros: String
    var wcs: String
    var fotos: Array<String>
    
    init(Id: String,calle: String,colonia: String,construccion: String,cp: String,estacionamiento: String,estado: String,habitaciones: String,idp: String,lat: String,lon: String,municipio: String,niveles: String,origen_propiedad: String,patios: String,precio: String,terreno: String,tipo: String,descripcion: String,pros: String,wcs: String,fotos: Array<String>){
        
        self.Id = Id
        self.calle = calle
        self.colonia = colonia
        self.construccion = construccion
        self.cp = cp
        self.estacionamiento = estacionamiento
        self.estado = estado
        self.habitaciones = habitaciones
        self.idp = idp
        self.lat = lat
        self.lon = lon
        self.municipio = municipio
        self.niveles = niveles
        self.origen_propiedad = origen_propiedad
        self.patios = patios
        self.precio = precio
        self.terreno = terreno
        self.tipo = tipo
        self.descripcion = descripcion
        self.pros = pros
        self.wcs = wcs
        self.fotos = fotos
        
    }
        
        
    
}
