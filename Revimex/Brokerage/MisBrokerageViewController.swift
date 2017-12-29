//
//  MisBrokerageViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 27/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material
//
class MisBrokerageViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var flBtnNuevo: FABButton!
    public var nuevoBrokerage:NuevoBrokerageViewController!;
    
    public var data:[String]!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = [];
        iniFlBtn();
    }

    func iniFlBtn(){
        flBtnNuevo.image = Icon.cm.add;
        flBtnNuevo.tintColor = Color.white;
        flBtnNuevo.backgroundColor = Color.black;
        flBtnNuevo.addTarget(self, action: #selector(nuevoBrokerageAction), for: .touchUpInside);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func nuevoBrokerageAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        nuevoBrokerage = storyboard.instantiateViewController(withIdentifier: "NuevoBrokerage") as! NuevoBrokerageViewController;
        navigationController?.present(nuevoBrokerage, animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "");
    }

}
