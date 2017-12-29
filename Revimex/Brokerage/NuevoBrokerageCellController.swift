//
//  NuevoBrokerageCellController.swift
//  Revimex
//
//  Created by Maquina 53 on 28/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material
//
public class NuevoBrokerage{
    
    public var id:String!;
    public var id_ai:Int!;
    public var estado:String!;
    public var municipio:String!;
    public var valorReferencia:String!;
    public var precioOriginal:String!;
    public var tipo:String!;
    public var construccion:String!;
    public var terreno:String!;
    public var urlFotoPrincipal:String!;
    public var urlFotos:[[String:Any?]]!;

    init(id:String!,id_ai:Int!,estado:String!,municipio:String!,valorReferencia:String!,precioOriginal:String!,tipo:String!,construccion:String!,terreno:String!,urlFotoPrincipal:String!, urlFotos:[[String:Any?]]!) {
        self.id = id;
        self.id_ai = id_ai;
        self.estado = estado;
        self.municipio = municipio;
        self.valorReferencia = valorReferencia;
        self.precioOriginal = precioOriginal;
        self.tipo = tipo;
        self.construccion = construccion;
        self.terreno = terreno;
        self.urlFotoPrincipal = urlFotoPrincipal;
        self.urlFotos = urlFotos;
    }
    
}

class NuevoBrokerageCellController: UITableViewCell {
    
    @IBOutlet weak var txLbEstado: TextField!
    @IBOutlet weak var txLbMunicipio: TextField!
    @IBOutlet weak var txLbValorReferencia: TextField!
    @IBOutlet weak var txLbPrecioOriginal: TextField!
    @IBOutlet weak var imgPrincipal: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iniTexts();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func iniTexts(){
        
        txLbEstado.placeholder = "Estado: ";
        txLbEstado.isEnabled = false;
        
        txLbMunicipio.placeholder = "Municipio: ";
        txLbMunicipio.isEnabled = false;
        
        txLbValorReferencia.placeholder = "Precio : ";
        txLbValorReferencia.isEnabled = false;
        
        txLbPrecioOriginal.placeholder = "Precio Original: ";
        txLbPrecioOriginal.isEnabled = false;
        
        imgPrincipal.image = UIImage.fontAwesomeIcon(name: .download, textColor: .black, size: CGSize(width: 500, height: 500));
        
    }
    
    public func setNuevoBrokerage(nuevoBrokerage:NuevoBrokerage!){
        txLbEstado.text = nuevoBrokerage.estado;
        txLbMunicipio.text = nuevoBrokerage.municipio;
        txLbValorReferencia.text = nuevoBrokerage.valorReferencia;
        txLbPrecioOriginal.text = nuevoBrokerage.precioOriginal;
        if(!nuevoBrokerage.urlFotoPrincipal.isEmpty){
        obtnerImage(url: nuevoBrokerage.urlFotoPrincipal){ img in
            DispatchQueue.main.async {
                self.imgPrincipal.image = img;
            }
        }
        }else{
            imgPrincipal.image = UIImage(named: "imagenNoEncontrada.png");
        }
    }
    
    public func obtnerImage(url:String!,completado:@escaping(_ image:UIImage)->Void){
        guard let url = URL(string: url)else{return};
        URLSession.shared.dataTask(with: url){ (data,response,error) in
            guard let data = data else{return};
            print(data.base64EncodedData());
           
                completado(UIImage(data: data)!);
            }.resume();
    }
    
}
