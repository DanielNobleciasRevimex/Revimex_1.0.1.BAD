//
//  FotosInmuebleCellController.swift
//  Revimex
//
//  Created by Maquina 53 on 11/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import FontAwesome_swift

class FotosInmuebleCellController: UITableViewCell,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController();
    
    public var idString:String!;
    public var controller:FotosInmuebleController!;
    
    @IBOutlet weak var labelPerspectiva: UILabel!
    @IBOutlet weak var imgPerspectiva: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgPerspectiva.image = UIImage.fontAwesomeIcon(name: .camera,textColor: UIColor.black,size: CGSize(width: 100, height: 100));
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected){
            obtenerImagen();
        }
    }

    
    func obtenerImagen(){
        let alert = UIAlertController(title: "Agregar "+labelPerspectiva.text!, message: "¿Desea tomar una fotografía o agregar una de su galería?", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title:"Cámara",style: UIAlertActionStyle.default,handler: { action in
            self.tomarFoto();
        }))
        alert.addAction(UIAlertAction(title: "Galería", style: UIAlertActionStyle.default, handler: { action in
            self.abrirGaleria();
        }))
        controller.present(alert, animated: true);
    }
    
    func tomarFoto(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = .camera;
            self.imagePicker.allowsEditing = true;
            self.controller.present(imagePicker, animated: true, completion: nil);
        }else{
            controller.present(Utilities.showAlertSimple("Error", "La camara de su dispositivo no esta disponible"), animated: true);
            self.isSelected = false;
        }
    }
    
    func abrirGaleria(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary;
            self.imagePicker.allowsEditing = true;
            self.controller.present(imagePicker, animated: true, completion: nil);
            
        }else{
            controller.present(Utilities.showAlertSimple("Error", "La Galería no esta disponible"), animated: true);
            self.isSelected = false;
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        imgPerspectiva.image = image;
        controller.setImgVw(idName: idString,img: image);
        self.imagePicker.dismiss(animated: true, completion: nil);
    }
    
}
