//
//  FormValidate.swift
//  Revimex
//
//  Created by Maquina 53 on 12/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import Foundation
protocol FormValidate{
    var rows:[String:Any?]?{get set};
    func obtValores()->[String:Any?]!;
    func esValido()->Bool;
}
