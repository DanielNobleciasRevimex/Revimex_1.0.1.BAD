//
//  FotosInmuebleController.swift
//  Revimex
//
//  Created by Maquina 53 on 11/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class FotosInmuebleController: UIViewController,UITableViewDataSource,FormValidate{
    
    var rows: [String : Any?]?
    
    
    @IBOutlet public weak var tableFotosInmueble: UITableView!;
    
    public var sizeMax:CGRect!;
    
    public struct Cell{
        var textLabel:String!;
        var idText:String!;
        init(_ textLabel:String!,_ idText:String!) {
            self.textLabel = textLabel;
            self.idText = idText;
        }
    }
    
    private var data:[Cell] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rows = [:];
        tableFotosInmueble.frame = self.view.frame;
        tableFotosInmueble.layer.bounds = self.view.layer.bounds;
        tableFotosInmueble.isScrollEnabled = false;
        
        data.append(Cell("Perspectiva Frontal","frontal"));
        data.append(Cell("Perspectiva Izquierda","izquierda"));
        data.append(Cell("Perspectiva Derecha","derecha"));
        data.append(Cell("Perspectiva Posterior","posterior"));
        
        tableFotosInmueble.dataSource = self;
        tableFotosInmueble.translatesAutoresizingMaskIntoConstraints = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableFotosInmueble.dequeueReusableCell(withIdentifier:"cellFotosInmueble") as! FotosInmuebleCellController;
        
        item.labelPerspectiva.text = data[indexPath.row].textLabel;
        item.idString = "\(indexPath.row)";
        item.controller = self;
        
        return item;
    }
    
    func obtValores()->[String:Any?]!{
        return self.rows;
    }
    
    func setImgVw(idName:String!,img:UIImage!){
        self.rows![idName] = UIImageJPEGRepresentation(img, 3)!;
    }
    
    func esValido() -> Bool {
        if(rows?.count==4){
            return true;
        }else{
            self.present(Utilities.showAlertSimple("Aviso","Son necesarias todas las perspectivas de la casa"),animated: true);
            return false;
        }
    }

}
