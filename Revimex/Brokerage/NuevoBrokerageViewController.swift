//
//  NuevoBrokerageViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 27/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material;
//
class NuevoBrokerageViewController: UIViewController {
    
    @IBOutlet weak var tamanoSubContainer: NSLayoutConstraint!
    @IBOutlet weak var tamanoMontoInv: NSLayoutConstraint!
    @IBOutlet weak var tamanoTiempoInv: NSLayoutConstraint!
    @IBOutlet weak var txFlMontoInversion: TextField!
    @IBOutlet weak var txFlTiempoInversion: TextField!
    @IBOutlet weak var tableBrokerage: UITableView!
    
    private var actualAlert:UIAlertController!;
    
    private var dataMonto:[Int]!;
    private var dataTiempo:[Int]!;
    
    private var indexMonto:Int!;
    private var indexTiempo:Int!;
    
    public var dataBrokerage:[NuevoBrokerage]!;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBrokerage = [];
        dataMonto = fillInversion();
        dataTiempo = [1,12,24,48,72];
        iniTextFields();
        tableBrokerage.dataSource = self;
        tableBrokerage.delegate = self;
        tableBrokerage.rowHeight = 200;
        // Do any additional setup after loading the view.
    }

    func iniTextFields(){
        txFlMontoInversion.placeholder = "Monto de Inversión";
        txFlMontoInversion.colorEnable();
        txFlMontoInversion.tag = 1;
        txFlMontoInversion.delegate = self;
        
        txFlTiempoInversion.placeholder = "Tiempo de Inversión"
        txFlTiempoInversion.colorEnable();
        txFlTiempoInversion.delegate = self;
        
        txFlMontoInversion.text = "$ \(dataMonto[0])";
        txFlTiempoInversion.text = "\(dataTiempo[0]) meses";
        indexMonto = 0;
        indexTiempo = 0;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func seleccionarMonto(){
        let alertPicker = UIAlertController(title: "Elija el Monto de su Inversión", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert);
        let pickerMonto = UIPickerView(frame: CGRect(x:0, y: 20, width: 250, height: 162));
        pickerMonto.backgroundColor = UIColor(white: 1, alpha: 0.7);
        pickerMonto.tag = 1;
        pickerMonto.delegate = self;
        pickerMonto.dataSource = self;
        alertPicker.view.addSubview(pickerMonto);
        let actionCancelar = UIAlertAction(title: "Cancel", style: .default,handler: nil);
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default){ action in
            self.busqueda();
            self.actualAlert.dismiss(animated: true, completion: nil);
        }
        alertPicker.addAction(actionCancelar);
        alertPicker.addAction(actionAceptar);
        self.actualAlert = alertPicker;
        present(alertPicker, animated: true, completion: nil);
    }
    
    private func seleccionarTiempo(){
        let alertPicker = UIAlertController(title: "Defina el tiempo de Inversión", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert);
        let pickerTiempo = UIPickerView(frame: CGRect(x:0, y:20, width: 250, height: 162));
        pickerTiempo.backgroundColor = UIColor(white: 1, alpha: 0.7);
        pickerTiempo.delegate = self;
        pickerTiempo.dataSource = self;
        alertPicker.view.addSubview(pickerTiempo);
        let actionCancelar = UIAlertAction(title: "Cancel", style: .default, handler: nil);
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default){ action in
            self.busqueda();
            self.actualAlert.dismiss(animated: true, completion: nil);
        }
        alertPicker.addAction(actionCancelar);
        alertPicker.addAction(actionAceptar);
        self.actualAlert = alertPicker;
        present(alertPicker, animated: true, completion: nil);
    }
    
    private func fillInversion()->[Int]{
        var respuesta:[Int] = [];
        var inicio = 100000;
        //var index = 0;
        
        for _ in inicio ... 1000000{
            respuesta.append(inicio);
            inicio = inicio + 50000;
        }
        return respuesta;
    }
    
    private func busqueda(){
        if(!txFlMontoInversion.isEmpty && !txFlTiempoInversion.isEmpty){
            buscarBrokerages(monto: dataMonto[self.indexMonto], tiempo:dataTiempo[self.indexTiempo] ){ brokerages in
                DispatchQueue.main.async{
                    self.dataBrokerage = [];
                    self.dataBrokerage = brokerages;
                    self.tableBrokerage.reloadData();
                }
            }
        }
    }

    private func buscarBrokerages(monto:Int,tiempo:Int,completado: @escaping(_ brokerages:[NuevoBrokerage])->Void){
        let url = "http://18.221.106.92/api/public/prop_brokerage/\(monto)";
        var brokerages:[NuevoBrokerage] = [];
        guard let urlBrokerage = URL(string: url) else{return};
        var request = URLRequest(url: urlBrokerage);
        request.httpMethod = "GET";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        let session = URLSession.shared;
        
        session.dataTask(with: request){ (data,response,error) in
            if(error == nil){
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! NSArray;
                        for node in json {
                            let temp = node as! NSDictionary;
                            let id = temp["Id"] as! String!;
                            let id_ai = temp["idp"] as! Int!;
                            let estado = temp["estado"] as! String!;
                            let municipio = temp["municipio"] as! String!;
                            let valorReferencia = temp["precio"] as! String!;
                            let precioOriginal = temp["Precio_Original__c"] as! String!;
                            let tipo = temp["tipo"] as! String!;
                            let construccion = temp["construccion"] as! String!;
                            let terreno = temp["terreno"] as! String!;
                            let urlFotoPrincipal = temp["fotoPrincipal"] as! String!;
                            let urlFotos = temp["images"] as! [[String:Any?]];
                            
                            let tempBrokerage = NuevoBrokerage(id: id, id_ai: id_ai, estado: estado, municipio: municipio, valorReferencia: valorReferencia, precioOriginal: precioOriginal,tipo: tipo,construccion: construccion,terreno: terreno,urlFotoPrincipal: urlFotoPrincipal,urlFotos: urlFotos);
                            brokerages.append(tempBrokerage);
                            
                        }
                        completado(brokerages);
                    }catch{
                        print(error);
                    }
                };
            }
            }.resume();
        
    }
}

extension NuevoBrokerageViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBrokerage.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableBrokerage.dequeueReusableCell(withIdentifier: "NuevoBrokerage_Row", for: indexPath) as! NuevoBrokerageCellController;
        item.setNuevoBrokerage(nuevoBrokerage: dataBrokerage[indexPath.row]);
        return item;
    }
    
}


extension NuevoBrokerageViewController: TextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField.tag == 1){
            seleccionarMonto();
        }else{
            seleccionarTiempo();
        }
        return false;
    }
}

extension NuevoBrokerageViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return dataMonto.count;
        }else{
            return dataTiempo.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            let numberF = NumberFormatter();
            numberF.numberStyle = .decimal;
            let valor = "$ "+numberF.string(from: NSNumber(value: dataMonto[row]))!;
            
            return valor;
        }else{
            return "\(dataTiempo[row]) meses";
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            let numberF = NumberFormatter();
            numberF.numberStyle = .decimal;
            self.indexMonto = row;
            self.txFlMontoInversion.text = "$ "+numberF.string(from: NSNumber(value: dataMonto[row]))!;
        }else{
            self.indexTiempo = row;
            self.txFlTiempoInversion.text = "\(dataTiempo[row]) meses";
        }
    }
}
