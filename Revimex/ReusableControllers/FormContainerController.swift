//
//  FormContainerController.swift
//  Revimex
//
//  Created by Maquina 53 on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class FormContainerController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    @IBOutlet weak var tableForm: UITableView!
    
    private var data:[Campo?]!;
    
    public struct Campo{
        
        var tipoCampo:String!;
        var nombreCampo:String!;
        var idString:String!;
        
        init(tipoCampo:String!,nombreCampo:String!,idString:String!){
            self.tipoCampo = tipoCampo;
            self.nombreCampo = nombreCampo;
            self.idString = idString;
        }
    }
    
    
    override func viewDidLoad() {
        
        tableForm.dataSource = self;
        tableForm.delegate = self;
        tableForm.register(UINib(nibName: "InputCellText", bundle: nil), forCellReuseIdentifier: "textCell");
        tableForm.register(UINib(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: "userCell");
        
        data=[
            Campo(tipoCampo: UserInfoCell.KEY, nombreCampo: nil, idString: "InfoUsuario"),
            Campo(tipoCampo: InputCellText.KEY, nombreCampo: "campo 1", idString: "cmp 1"),
            Campo(tipoCampo: InputCellText.KEY, nombreCampo: "campo 2", idString: "cmp 2"),
            Campo(tipoCampo: InputCellText.KEY, nombreCampo: "campo 3", idString: "cmp 3"),
            Campo(tipoCampo: InputCellText.KEY, nombreCampo: "campo 4", idString: "cmp 4"),
            Campo(tipoCampo: InputCellText.KEY, nombreCampo: "campo 5", idString: "cmp 5"),
        ];
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            
            if(data[indexPath.row])?.tipoCampo == UserInfoCell.KEY{
                let item = tableForm.dequeueReusableCell(withIdentifier: "userCell",for: indexPath) as! UserInfoCell;
                item.selectionStyle = .none;
                return item;
            }else if(data[indexPath.row])?.tipoCampo == InputCellText.KEY{
                let item = tableForm.dequeueReusableCell(withIdentifier: "textCell",for: indexPath) as! InputCellText;
                item.selectionStyle = .none;
                item.labelNombreCampo.text = data[indexPath.row]?.nombreCampo;
                return item;
            }
            
            return UITableViewCell(style: .default, reuseIdentifier: nil);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(data[indexPath.row])?.tipoCampo == UserInfoCell.KEY{
            return 180;
        }else{
            return 50;
        }
    }
  
    
}
