//
//  Usuario.swift
//  Revimex
//
//  Created by Maquina 53 on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import Foundation

class Usuario{
    
    public var usuario:String!;
    public var pass:String!;
    public var id:Int!;
    public var nombre:String!;
    public var pApellido:String!;
    public var sApellido:String!;
    public var estado:String!;
    public var rfc:String!;
    
    init(_ usuario:String,_ pass:String!,_ id:Int!,_ nombre:String?,_ pApellido:String?,_ sApellido:String?,_ estado:String?,_ rfc:String?){
        self.usuario = usuario;
        self.pass = pass;
        self.id = id;
        self.nombre = nombre;
        self.pApellido = pApellido;
        self.sApellido = sApellido;
        self.estado = estado;
        self.rfc = rfc;
    }
    
}
