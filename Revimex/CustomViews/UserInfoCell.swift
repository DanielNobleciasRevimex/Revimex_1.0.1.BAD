//
//  UserInfoCell.swift
//  Revimex
//
//  Created by Maquina 53 on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
class UserInfoCellContent: InfoCells{
    
    var idTipo: String! = UserInfoCell.KEY;
    public var imgUser:UIImage!;
    public var imgBackground:UIImage!;
    var controller: UITableViewCell!;
    
    init() {
        
    }
    
    init(imgUser: UIImage!,imgBackground:UIImage!) {
        self.imgUser = imgUser;
        self.imgBackground = imgBackground;
    }
    
    func setController(controller: UITableViewCell!) {
        self.controller = controller as! UserInfoCell;
    }
    
}

class UserInfoCell: UITableViewCell {
    public static var KEY = "CELL_USER";
    public var idString:String!;
    
    @IBOutlet weak var contenedor: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgUser.contentMode = .scaleAspectFit;
        imgUser.backgroundColor = UIColor(white: 1, alpha: 0.5);
        imgUser.clipsToBounds = true
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2;
        imgUser.layer.borderWidth = 1.5;
        imgUser.layer.borderColor = UIColor.black.cgColor;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func set(datos:UserInfoCellContent!){
        imgUser.image = datos.imgUser;
        imgBackground.image = datos.imgBackground;
    }
    
}
