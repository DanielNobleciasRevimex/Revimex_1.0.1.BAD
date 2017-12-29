//
//  FormView.swift
//  Revimex
//
//  Created by Maquina 53 on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

@IBDesignable
class FormView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    public var data:[Campo]!;
    
    @IBOutlet weak var tableForm: UITableView!

    var contentView:UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        setUp();
    }
    
    func setUp(){
        data = [];
        guard let view = loadViewFromNib() else {return};
        view.frame = bounds;
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight];
        addSubview(view);
        contentView = view;
        
        tableForm.dataSource = self;
        tableForm.delegate = self;
        tableForm.register(UINib(nibName: "InputCellText", bundle: nil), forCellReuseIdentifier: InputCellText.KEY);
        tableForm.register(UINib(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: UserInfoCell.KEY);
    }
    
    func loadViewFromNib()->UIView?{
        let bundle = Bundle(for: type(of: self));
        let nib = UINib(nibName: "FormView", bundle: bundle);
        return nib.instantiate(withOwner: self, options: nil).first as? UIView;
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder();
        setUp();
        contentView?.prepareForInterfaceBuilder();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(row: data[indexPath.row], indexPath: indexPath);
    }
    
    func getCell(row:Campo,indexPath: IndexPath)->UITableViewCell{
        switch row.tipoCampo{
        case UserInfoCell.KEY:
            let item = tableForm.dequeueReusableCell(withIdentifier: UserInfoCell.KEY, for: indexPath) as! UserInfoCell;
            item.imgUser.image = (data[indexPath.row] as! Campo.Usuario).imgUsuario;
            
            var backImg = Utilities.escalar(img: item.imgUser.image, nwAncho:item.imgUser.frame.size, sizeOriginal: CGRect(x: 0, y: 0, width: item.imgBackground.bounds.width, height: item.imgBackground.bounds.height));
            backImg = Utilities.blur(img: backImg, blurVal: 60);
            item.imgBackground.image = backImg;
            item.idString = row.idString;
            return item;
        case InputCellText.KEY:
            let item = tableForm.dequeueReusableCell(withIdentifier: InputCellText.KEY, for: indexPath) as! InputCellText;
            item.labelNombreCampo.text = (data[indexPath.row] as! Campo.InputText).labelNombreCampo;
            item.txFlCampo.placeholder = (data[indexPath.row] as! Campo.InputText).placeholder;
            item.idString = row.idString;
            return item;
        default:
            break;
        }
        return UITableViewCell(style: .default, reuseIdentifier: nil);
    }
    
    public func addCell(row:Campo){
        data.append(row);
    }
    
    
    public class Campo{
        var tipoCampo:String!;
        var idString:String?;
        public class Usuario: Campo{
            var imgUsuario: UIImage!;
            override init() {
                super.init();
                tipoCampo =  UserInfoCell.KEY;
            }
        }
        public class InputText:Campo{
            var labelNombreCampo:String!;
            var placeholder:String!
            override init() {
                super.init();
                tipoCampo = InputCellText.KEY;
            }
        }
    }
}
