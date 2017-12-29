//
//  SubirPropiedadViewController.swift
//  Revimex
//
//  Created by Maquina 53 on 06/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class SubirPropiedadViewController: UIViewController{
    
    
    @IBOutlet weak var anchoBtnAnt: NSLayoutConstraint!
    @IBOutlet weak var altoBtnAnt: NSLayoutConstraint!
    @IBOutlet weak var anchoBtnSig: NSLayoutConstraint!
    @IBOutlet weak var altoBtnSig: NSLayoutConstraint!
    
    
    @IBOutlet weak var cnVwFormularios: UIView!
    
    @IBOutlet weak var btnSig: UIButton!
    @IBOutlet weak var btnAnt: UIButton!
    
    private struct orgBtn{
        private var orgAnt: UIButton!;
        private var orgSig: UIButton!;
        init(orgAnt:UIButton!,orgSig:UIButton!) {
            self.orgAnt = orgAnt;
            self.orgSig = orgSig;
        }
        
        func getOrgAnt()->UIButton!{
            return self.orgAnt;
        }
        
        func getOrgSig()->UIButton!{
            return self.orgSig;
        }
        
    };
    
    private var org_Btn:orgBtn!;
    public var queryDireccion:String!;
    
    var detallesInmueble: DetallesInmuebleController!;
    //var ubicacionInmueble: UbicacionInmuebleController!;
    var fotosInmueble: FotosInmuebleController!;
    var mapaUbicacionInmueble: MapaUbicacionInmueble!;
    var ubicacionExtraInmueble: UbicacionExtraInmuebleController!;
    
    var views:[UIViewController?]!;
    
    var cont: Int!;
    
    private var actualViewController: UIViewController?{
        didSet{
            removeInactiveViewController(inactiveViewController: oldValue);
            updateActiveViewController();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cont = 0;
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        
        detallesInmueble = storyboard.instantiateViewController(withIdentifier: "DetallesInmueble") as! DetallesInmuebleController ;
        //ubicacionInmueble = storyboard.instantiateViewController(withIdentifier: "UbicacionInmueble") as! UbicacionInmuebleController;
        mapaUbicacionInmueble = storyboard.instantiateViewController(withIdentifier: "ConfirmarUbicacionInmueble") as! MapaUbicacionInmueble;
        ubicacionExtraInmueble = storyboard.instantiateViewController(withIdentifier: "UbicacionExtraInmueble") as! UbicacionExtraInmuebleController;
        fotosInmueble = storyboard.instantiateViewController(withIdentifier: "FotosInmueble") as! FotosInmuebleController;
        
        ubicacionExtraInmueble.subirPropiedad = self;
        fotosInmueble.sizeMax = cnVwFormularios.frame;
        //ubicacionInmueble.subirPropiedad = self;
        
        views = [detallesInmueble,mapaUbicacionInmueble,ubicacionExtraInmueble,fotosInmueble];
        
        btnSig = Utilities.genearSombras(btnSig);
        btnSig.tag = 2;
        
        let laySig = btnSig.layer;
        laySig.cornerRadius = 18;
        btnSig = cambiarBtn(titulo: String.fontAwesomeIcon(name: .chevronRight), btn: btnSig,id: 1, layer: laySig, font: UIFont.fontAwesome(ofSize: 34), accion: #selector(actSig(_:)));
        
        btnAnt = Utilities.genearSombras(btnAnt);
        btnAnt.tag = 1;
        let layAnt = btnAnt.layer;
        layAnt.cornerRadius = 18;
        btnAnt = cambiarBtn(titulo: String.fontAwesomeIcon(name: .chevronLeft), btn: btnAnt, id: 1, layer: layAnt, font: UIFont.fontAwesome(ofSize: 34), accion: #selector(actAnt(_:)));
        
        actualizar();
        
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?){
        if let inactiveVC = inactiveViewController{
            inactiveVC.willMove(toParentViewController: nil);
            inactiveVC.view.removeFromSuperview();
            inactiveVC.removeFromParentViewController();
        }
    }
    
    private func updateActiveViewController(){
        if let activeVC = actualViewController{
            addChildViewController(activeVC);
            activeVC.view.frame = cnVwFormularios.bounds;
            cnVwFormularios.addSubview(activeVC.view);
            activeVC.didMove(toParentViewController: self);
        }
    }
    
    private func actualizar(){
        if(cont == 0){
            let layAnt = btnAnt.layer;
            layAnt.cornerRadius = 0;
            btnAnt = cambiarBtn(titulo: "Cancelar", btn: btnAnt, id: 0, layer: layAnt, font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, accion: #selector(cancelar));
        }else{
            let layAnt = btnAnt.layer;
            layAnt.cornerRadius = 18;
            btnAnt = cambiarBtn(titulo: String.fontAwesomeIcon(name: .chevronLeft), btn: btnAnt, id: 1, layer: layAnt, font: UIFont.fontAwesome(ofSize: 34), accion: #selector(actAnt(_:)));
        }
        if(cont == 3){
            let laySig = btnSig.layer;
            laySig.cornerRadius = 0;
            btnSig = cambiarBtn(titulo: "Guardar", btn: btnSig,id: 0,layer: laySig,font: UIFont(name: "HelveticaNeue-Bold", size: 20)!,accion: #selector(guardar));
        }else{
            let laySig = btnSig.layer;
            laySig.cornerRadius = 18;
            btnSig = cambiarBtn(titulo: String.fontAwesomeIcon(name: .chevronRight), btn: btnSig,id: 1, layer: laySig, font: UIFont.fontAwesome(ofSize: 34), accion: #selector(actSig(_:)));
        }
        
        actualViewController = views[cont];
    }
    
    @IBAction func actSig(_ sender: UIButton) {
        if(validar()){
            
            if(actualViewController is MapaUbicacionInmueble){
                ubicacionExtraInmueble.rows = mapaUbicacionInmueble.obtValores();
            }
            if(cont<4){
                cont = cont + 1;
                actualizar();
            }
        }
    }
    
    public func byPass(){
        OperationQueue.main.addOperation {
            self.cont = self.cont + 1;
            self.actualizar();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true;
    }
    
    @IBAction func actAnt(_ sender: UIButton) {
        if(cont>0){
            cont = cont - 1;
            actualizar();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func validar()->Bool{
        let actual = actualViewController as! FormValidate;
        return actual.esValido();
    }
    
    private func cambiarBtn(titulo:String,btn:UIButton,id:Int,layer: CALayer,font:UIFont,accion: Selector)->UIButton{
        
        btn.layer.cornerRadius = layer.cornerRadius;
        
        btn.titleLabel?.font = font ;

        btn.setTitle(titulo, for: .normal);
        
        btn.removeTarget(nil, action: nil, for: .allEvents);
        btn.addTarget(self, action:accion, for: .touchUpInside);
        
        switch id {
        case 0:
            if(btn.tag == 1){
                altoBtnAnt.constant = 16;
                anchoBtnAnt.constant = 260;
            }else{
                altoBtnSig.constant = 16;
                anchoBtnSig.constant = 260;
            }
            break;
        case 1:
            if(btn.tag == 1){
                altoBtnAnt.constant = 8;
                anchoBtnAnt.constant = 319;
            }else{
                altoBtnSig.constant = 8;
                anchoBtnSig.constant = 319;
            }
            break;
        default:
            print("ERROR");
        }
        
        return btn;
        
    }
    
    @objc func cancelar(){
        navigationController?.popViewController(animated:true);
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func guardar(){
        if(actualViewController as! FormValidate).esValido(){
            let rowsDetalles = (detallesInmueble)?.obtValores()!;
            let rowsUbicacion = (ubicacionExtraInmueble)?.obtValores()!;
            let rowsFotos = (fotosInmueble)?.obtValores()!;
            let rowTotal = [
                "detallesInmueble" : rowsDetalles!,
                "ubicacionInmueble" : rowsUbicacion
            ];
            print(rowTotal);
            do{
                let data = try JSONSerialization.data(withJSONObject: rowTotal , options: .prettyPrinted);
                let dataString:String! = String(data: data, encoding: .utf8);
                 print(dataString);
                subirPropiedad(data: data);
            }catch{
                print(error);
            }
        };
    }
    
    func subirPropiedad(data:Data!){
        let url = "http://18.221.106.92/api/public/apps/prueba";
        guard let urlinfo = URL(string: url) else{print("Error URL"); return};
        var request = URLRequest(url: urlinfo);
        request.httpMethod = "POST";
        request.httpBody = data;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        let session = URLSession.shared;
        session.dataTask(with: request){(data,response,error) in
            if(error == nil){
                print(response);
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                        let status = json["status"] as? Int;
                        if(status == 1){
                            OperationQueue.main.addOperation {
                                self.present(Utilities.showAlertSimple("Exito", "La propiedad se registrado"), animated: true, completion: nil);
                                
                            }
                        }else{
                            OperationQueue.main.addOperation {
                                self.navigationController?.popViewController(animated: true);
                                self.dismiss(animated: true, completion: nil);
                            }
                        }
                        print(json)
                    }catch{
                        print(error);
                    }
                }
            }
            }.resume();
        
        OperationQueue.main.addOperation {
            self.navigationController?.popViewController(animated: true);
            self.dismiss(animated: true, completion: nil);
        }
    
    }
    
}
