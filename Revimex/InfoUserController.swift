//
//  InfoUserController.swift
//  
//
//  Created by Maquina 53 on 30/11/17.
//

import UIKit

class InfoUserController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableInfoUser: UITableView!
    
    
    private var user_id : String!;
    private var cuentaBtn: UIButton!;
    private var tapGesture: UITapGestureRecognizer!;
    private var menuContainer: UIView!;
    
    public var data:[InfoCells]?;
    
    public var imgUser:UIImage!;
    public var imgBack:UIImage!;
    public var cargado:Bool = false;
    public var infoCargada:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar();
        self.hideKeyboard();
        data = [];
        self.navigationController?.isNavigationBarHidden = false;
        
        //Se obtiene de las subviews el Boton de información de usuario
        let a = self.navigationController?.navigationBar.subviews;
        cuentaBtn = a![5] as! UIButton;
        
        cuentaBtn.setBackgroundImage(UIImage(named:"menu-horizontal-100.png"), for: .normal);
        tapGesture = UITapGestureRecognizer(target: self,action: #selector(InfoUserController.menuTapped(tapGestureRecognizer:)));
        cuentaBtn.addGestureRecognizer(tapGesture);
        
        iniMenu();
        
        user_id = UserDefaults.standard.string(forKey: "userId")!;
        
        tableInfoUser.register(UINib(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: UserInfoCell.KEY);
        
        tableInfoUser.backgroundColor = UIColor(white: 1, alpha: 0);
        data?.append(UserInfoCellContent());
        data?.append(DatosPrincipalesCellContent());
        data?.append(DatosPersonalesCellContent());
        data?.append(CuentasAsociadasCellContent());
        data?.append(RowButtonsCellContent(imgBtn: UIImage.fontAwesomeIcon(name: .edit, textColor: UIColor.black, size: CGSize(width: 500, height: 500))));
        
        tableInfoUser.dataSource = self;
        tableInfoUser.delegate = self;
        tableInfoUser.rowHeight = UITableViewAutomaticDimension;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.data?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tipo = data![indexPath.row];
        if(indexPath.row>=((data?.count)! - 1) && !infoCargada){
            obtInfoUser();
            infoCargada = true;
        }
        return getCell(tipo: tipo, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch data![indexPath.row] {
        case is UserInfoCellContent:
            return 180;
        case is DatosPrincipalesCellContent:
            return (data![indexPath.row].controller as! DatosPrincipalesCellController).content.bounds.height;
        case is DatosPersonalesCellContent:
            return 500;
        case is CuentasAsociadasCellContent:
            return 175;
        case is RowButtonsCellContent:
            return 62;
        default:
            return 100;
        }
    }
    
    private func getCell(tipo:InfoCells!,indexPath:IndexPath)->UITableViewCell{
        switch tipo.idTipo{
        case UserInfoCell.KEY:
            let item = tableInfoUser.dequeueReusableCell(withIdentifier: UserInfoCell.KEY) as! UserInfoCell;
            if(!cargado){
                let imgUs = UIImage.fontAwesomeIcon(name: .userO, textColor: UIColor.black, size: CGSize(width: 500, height: 500 ));
                (data![indexPath.row] as! UserInfoCellContent).imgUser = imgUs;
                
                var imgBack = Utilities.escalar(img: imgUs, nwAncho: item.imgUser.frame.size, sizeOriginal: CGRect(x: 0, y: 0, width: item.imgBackground.bounds.width, height: item.imgBackground.bounds.height));
                imgBack = Utilities.blur(img: imgBack, blurVal: 80);
                (data![indexPath.row] as! UserInfoCellContent).imgBackground = imgBack;
                item.set(datos:(data![indexPath.row] as! UserInfoCellContent));
                cargado = true;
            }else{
                item.set(datos: (data![indexPath.row]) as! UserInfoCellContent);
            }
            //item.backgroundColor = UIColor(white: 1, alpha: 0);
            data![indexPath.row].setController(controller: item);
            
            return item;
        case DatosPrincipalesCellController.KEY:
            let item = tableInfoUser.dequeueReusableCell(withIdentifier: DatosPrincipalesCellController.KEY) as! DatosPrincipalesCellController;
            data![indexPath.row].setController(controller: item);
            item.table = tableInfoUser;
            item.infoUserController = self;
            //item.backgroundColor = UIColor(white: 1, alpha: 0);
            return item;
        case DatosPersonalesCellController.KEY:
            let item = tableInfoUser.dequeueReusableCell(withIdentifier: DatosPersonalesCellController.KEY) as! DatosPersonalesCellController;
            data![indexPath.row].setController(controller: item);
            item.infoUserController = self;
            //item.backgroundColor = UIColor(white: 1, alpha: 0);
            return item;
        case CuentasAsociadasCellController.KEY:
            let item = tableInfoUser.dequeueReusableCell(withIdentifier: CuentasAsociadasCellController.KEY) as!
            CuentasAsociadasCellController;
            data![indexPath.row].setController(controller: item);
            item.infoUserController = self;
            //item.backgroundColor = UIColor(white: 1, alpha: 0);
            return item;
        case RowButtonsCellController.KEY:
            let item = tableInfoUser.dequeueReusableCell(withIdentifier: RowButtonsCellController.KEY) as! RowButtonsCellController;
            data![indexPath.row].setController(controller: item);
            item.infoUserController = self;
            //item.backgroundColor = UIColor(white: 1, alpha: 0);
            return item;
        default:
            return TableViewCell(style: .default, reuseIdentifier: nil);
        }
    }
    
    func actionGuardar() {
        
        let principal = (data![1] as! DatosPrincipalesCellContent).controller as! DatosPrincipalesCellController;
        let personales = (data![2] as! DatosPersonalesCellContent).controller as! DatosPersonalesCellController;
        let cuentas = (data![3] as! CuentasAsociadasCellContent).controller as! CuentasAsociadasCellController;
        
        if(Utilities.isValidEmail(testStr: cuentas.txFlFacebook.getActualText())){
            self.setInfoUser(principal: principal, personales: personales, cuentas: cuentas);
        }
        
    }
    
    //Actualiza la información de usuario
    private func setInfoUser(principal:DatosPrincipalesCellController, personales:DatosPersonalesCellController, cuentas: CuentasAsociadasCellController){
        
        let url = "http://18.221.106.92/api/public/user";
        guard let urlUpdate = URL(string:url)else{print("ERROR UPDATE");return};
        let parameters: [String:Any?] = [
            "user_id" :  user_id,
            "email" : principal.txFlNombreUsuario.getActualText(),
            "name" : personales.txFlNombre.getActualText(),
            "apellidoPaterno" : personales.txFlPApellido.getActualText(),
            "apellidoMaterno" : personales.txFlSApellido.getActualText(),
            "estado" : principal.txFlResidencia.getActualText(),
            "tel" : personales.txFlTelefono.getActualText(),
            "facebook" : cuentas.txFlFacebook.getActualText(),
            "google" : cuentas.txFlGmail.getActualText(),
            "fecha_nacimiento" : personales.tcFlNacimiento.getActualText(),
            "direccion" : personales.txFlDireccion.getActualText(),
            "rfc" : personales.txFlRFC.getActualText()
        ];
        
        var request = URLRequest(url: urlUpdate);
        request.httpMethod = "POST";
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted);
        }catch{
            print(error);
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        let session = URLSession.shared;
        session.dataTask(with: request){ (data,response,error) in
            
            
            if(error == nil){
                
                if let data = data{
                    do{
                        _ = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                    }catch{
                        print(error);
                    }
                }
                OperationQueue.main.addOperation {
                    let alert = UIAlertController(title: "Exito", message: "Los datos se han guardado", preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert,animated:true,completion:nil);
                }
            }else{
                OperationQueue.main.addOperation {
                    let alert = UIAlertController(title: "Error", message: "error: "+error.debugDescription, preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert,animated:true,completion:nil);
                }
            }
            }.resume();
        
    }
    
    //Crear menu contextual
    private func iniMenu(){
        
        let screenSize = UIScreen.main.bounds;
        let navigation = navigationController?.navigationBar.frame;
        let posY = navigation?.maxY;
        let posX = navigation?.maxX;
        
        menuContainer = UIView(frame: CGRect(/*x: 200, y: 500, width: 100, height: 100*/));
        menuContainer.frame = CGRect(x: posX! - (screenSize.width*(0.3)) - 5, y: posY!, width: screenSize.width*(0.3), height: 100);
        menuContainer.backgroundColor = UIColor.white;
        menuContainer.layer.masksToBounds = false;
        menuContainer.layer.shadowRadius = 2.0;
        menuContainer.layer.shadowColor = UIColor.black.cgColor;
        menuContainer.layer.shadowOffset = CGSize(width: 0.7, height: 0.7);
        menuContainer.layer.shadowOpacity = 0.5;
        menuContainer.isHidden = true;
        
        let subScreen = menuContainer.bounds;
        let logOutBtn = UIButton(type: .system);
        logOutBtn.frame = CGRect(x: subScreen.minX + 4, y:0, width: subScreen.width * (0.90), height: screenSize.height * (0.04));
        logOutBtn.setTitle("Cerrar Sesión", for: .normal);
        logOutBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 16);
        logOutBtn.setTitleColor(UIColor.black, for: .normal);
        logOutBtn.backgroundColor = UIColor.white;
        logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside);
        
        menuContainer.frame.size = CGSize(width: menuContainer.frame.width, height: logOutBtn.frame.height);
        menuContainer.addSubview(logOutBtn);
        
        view.addSubview(menuContainer);
    }
    
    //Obtiene la informacion del usuraio a partir de su numero de ID
    private func obtInfoUser(){
        print(UserDefaults.standard.integer(forKey: "userId"));
        
        let principal = (data![1] as! DatosPrincipalesCellContent).controller as! DatosPrincipalesCellController;
        let personales = (data![2] as! DatosPersonalesCellContent).controller as! DatosPersonalesCellController;
        let cuentas = (data![3] as! CuentasAsociadasCellContent).controller as! CuentasAsociadasCellController;
        
        let url = "http://18.221.106.92/api/public/user/" + (user_id);
        guard let urlInfo = URL(string: url) else{ print("ERROR en URL"); return};
        
        var request = URLRequest(url: urlInfo);
        request.httpMethod = "GET";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        
        let session = URLSession.shared;
        
        session.dataTask(with: request){(data,response,error) in
            if(error == nil){
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                        
                        //let dataImg: NSData? = Utilities.traerImagen(urlImagen: Utilities.sinFoto);
                        
                        self.colocarInfo(json,data: Utilities.traerImagen(urlImagen: ""), principal: principal, personales: personales,cuentas: cuentas);
                    }catch{
                        print(error);
                    }
                };
            }
            }.resume();
        
    }
    
    
    //Coloca la información del usuario en los TextFields
    private func colocarInfo(_ json:[String:Any?],data: UIImage!, principal:DatosPrincipalesCellController, personales:DatosPersonalesCellController, cuentas: CuentasAsociadasCellController){
        OperationQueue.main.addOperation {
            principal.txFlNombreUsuario.text = json["email"] as? String;
            personales.txFlNombre.text = json["name"] as? String;
            personales.txFlPApellido.text = json["apellidoPaterno"] as? String;
            personales.txFlSApellido.text = json["apellidoMaterno"] as? String;
            principal.txFlResidencia.text = json["estado"] as? String;
            personales.txFlTelefono.text = json["tel"] as? String;
            cuentas.txFlFacebook.text = json["facebook"] as? String;
            cuentas.txFlGmail.text = json["google"] as? String;
            personales.tcFlNacimiento.text = json["fecha_nacimiento"] as? String;
            personales.txFlDireccion.text = json["direccion"] as? String;
            personales.txFlRFC.text = json["rfc"] as? String;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cuentaBtn.setBackgroundImage(UIImage(named: "cuenta.png"), for: .normal);
        cuentaBtn.removeGestureRecognizer(tapGesture);
        super.viewWillDisappear(animated);
    }
    
    public func disable_EnableAllSub(){
        for item in data!{
            switch item{
            case is UserInfoCellContent:
                break;
            case is DatosPrincipalesCellContent:
                (item.controller as! DatosPrincipalesCellController).dis_enable();
                break;
            case is DatosPersonalesCellContent:
                (item.controller as! DatosPersonalesCellController).dis_enable();
                break;
            case is CuentasAsociadasCellContent:
                (item.controller as! CuentasAsociadasCellController).dis_enable();
                break;
            default:
                break;
            }
        }
    }
    
    @objc func menuTapped(tapGestureRecognizer: UITapGestureRecognizer){
        menuContainer.isHidden = !menuContainer.isHidden
    }
    
    @objc func logOut(){
        UserDefaults.standard.removeObject(forKey: "usuario");
        UserDefaults.standard.removeObject(forKey: "contraseña");
        UserDefaults.standard.removeObject(forKey: "userId");
        navBarStyleCase = 0;
        performSegue(withIdentifier: "infoToLogin", sender: nil)
    }
    
    @objc func EnableEdit(){
        
        let alert = UIAlertController(title: "Aviso", message: "Ahora puede editar su perfil", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated:true,completion:nil);
        disable_EnableAllSub();
        
    }
    
    
}
