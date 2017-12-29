//
//  LogInController.swift
//  Revimex
//
//  Created by Seifer on 16/11/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import Material
import Motion

class LogInController: UIViewController {
    
    let passwordField = TextField()
    let emailField = TextField()
    @IBOutlet var invitadoBtn: UIButton!
    
    var usuario = ""
    var contraseña = ""
    
    //para un metodo del sdk de facebbok
    var dict : [String : AnyObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pculta el boton de inicio de secion
        incioSesionBtn.isHidden = true
        
        //permite que el teclado se esconda al hacer click en otro lugar de la pantalla
        self.hideKeyboard()
        
        //asigna color tamaño y logo a la barra de navegacion dependiendo de si ya existe un usuario registrado
        switch navBarStyleCase {
            case 0:
                print("LoggedOut")
                self.setLoginNavigationBar()
                navigationController?.navigationBar.isHidden = true
                break
            case 1,2:
                print("solicitud de registro/solicitud de registro desde navBar con color solido")
                self.setLoginNavigationBar()
                break
            default:
                self.setLoginNavigationBar()

        }
        
        crearCampos()
        
        crearBotones()
        
        
        
        //pide a facebook los datos de ususario en caso de que ya se haya logueado anteriormente
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //muestra nuevamente el boton de inicio de sesion en la barra de navegacion al ocultar la pagina

        incioSesionBtn.isHidden = false

        if let navigationBarSize = self.navigationController?.navigationBar.bounds{
            let navigationBarSizeWidth = (navigationBarSize.width)
            let navigationBarSizeHeigth = (navigationBarSize.height)
            let logo = UIImage(named: "revimex.png")
            let contenedorLogo = UIImageView(image:logo)
            contenedorLogo.frame = CGRect(x: navigationBarSizeWidth*0.3,y: 0.0,width: navigationBarSizeWidth*0.4,height: navigationBarSizeHeigth)
            self.navigationController?.navigationBar.addSubview(contenedorLogo)
        }
        
    }
    
    
    func crearCampos(){
        let screenSize = UIScreen.main.bounds
        emailField.frame = CGRect(x: screenSize.width * 0.15,y:screenSize.height * 0.35,width:screenSize.width * 0.7,height:screenSize.height * 0.05)
        emailField.placeholderNormalColor = UIColor.white
        emailField.placeholder = "Email"
        emailField.textColor = UIColor.white
        emailField.isClearIconButtonEnabled = true
        view.addSubview(emailField)
        
        passwordField.frame = CGRect(x: screenSize.width * 0.15,y:screenSize.height * 0.45,width:screenSize.width * 0.7,height:screenSize.height * 0.05)
        passwordField.placeholderNormalColor = UIColor.white
        passwordField.placeholder = "Contraseña"
        passwordField.textColor = UIColor.white
        passwordField.detailColor = UIColor.white
        passwordField.detail = "Al menos 6 caracteres"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        view.addSubview(passwordField)
    }
    
    
    func crearBotones(){
        let screenSize = UIScreen.main.bounds
        
        let iniciaSesionTapped = UITapGestureRecognizer(target: self, action: #selector(iniciaSesion(tapGestureRecognizer:)))
        
        let iniciarSesion = UIButton()
        iniciarSesion.frame = CGRect(x: screenSize.width * 0.08,y:screenSize.height * 0.58,width:screenSize.width * 0.4,height:screenSize.height * 0.07)
        iniciarSesion.setTitle("Iniciar Sesion", for: .normal)
        iniciarSesion.setTitleColor(UIColor.white, for: .normal)
        iniciarSesion.layer.borderColor = UIColor.white.cgColor
        iniciarSesion.layer.borderWidth = 1
        iniciarSesion.addGestureRecognizer(iniciaSesionTapped)
        view.addSubview(iniciarSesion)
        
        let crearCuentaTapped = UITapGestureRecognizer(target: self, action: #selector(nuevaCuenta(tapGestureRecognizer:)))
        
        let crearCuenta = UIButton()
        crearCuenta.frame = CGRect(x: screenSize.width * 0.54,y:screenSize.height * 0.58,width:screenSize.width * 0.4,height:screenSize.height * 0.07)
        crearCuenta.setTitle("Crear Cuenta", for: .normal)
        crearCuenta.setTitleColor(UIColor.white, for: .normal)
        crearCuenta.layer.borderColor = UIColor.white.cgColor
        crearCuenta.layer.borderWidth = 1
        crearCuenta.addGestureRecognizer(crearCuentaTapped)
        view.addSubview(crearCuenta)
        
        let facebookTapped = UITapGestureRecognizer(target: self, action: #selector(loginButtonClicked(tapGestureRecognizer:)))
        
        let facebook = FABButton(image: UIImage(named: "facebook.png"), tintColor: .white)
        facebook.frame = CGRect(x: screenSize.width * 0.31,y:screenSize.height * 0.73,width:screenSize.width * 0.16,height:screenSize.width * 0.16)
        facebook.pulseColor = .white
        facebook.addGestureRecognizer(facebookTapped)
        view.addSubview(facebook)
        
        let google = FABButton(image: UIImage(named: "google.png"), tintColor: .white)
        google.frame = CGRect(x: screenSize.width * 0.53,y:screenSize.height * 0.73,width:screenSize.width * 0.16,height:screenSize.width * 0.16)
        google.pulseColor = .white
        view.addSubview(google)
        
        invitadoBtn.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20.0)
        invitadoBtn.frame = CGRect(x: 0, y:view.bounds.height - screenSize.height * 0.2 - 20 ,width:screenSize.width,height:screenSize.width * 0.2)
        
    }
        
    
    @IBAction func entrarComoInvitado(_ sender: Any) {
        
    }
    
    
    //genera un alert
    func alerta(titulo: String,mensaje: String){
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //navega a la pagina principal
    func continuar(){
        self.performSegue(withIdentifier: "logedIn", sender: nil)
    }
    
    
    //********************************Funcion de inicio de sesion********************************
    @objc func iniciaSesion(tapGestureRecognizer: UITapGestureRecognizer) {
        
        usuario = emailField.text!
        contraseña = passwordField.text!
        
        if Utilities.isValidEmail(testStr: usuario){
        
            let urlRequestFiltros = "http://18.221.106.92/api/public/user/login"
        
            let parameters: [String:Any] = [
                "email" : usuario,
                "password" : contraseña
            ]
        
            guard let url = URL(string: urlRequestFiltros) else { return }
        
            var request = URLRequest (url: url)
            request.httpMethod = "POST"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session  = URLSession.shared
        
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    print(data);
                    do {
                        let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                        
                        print(json["status"] as! Int)
                        print(json["mensaje"] as! String)
                        
                        if let estatus = json["status"] as? Int{
                            switch estatus {
                            case 0,2:
                                self.alerta(titulo: "Datos Incorrectos",mensaje: "Correo o contraseña no validos")
                            case 1:
                                //guarda los datos del usuario si la respuesta fue exitosa
                                UserDefaults.standard.set(self.usuario, forKey: "usuario")
                                UserDefaults.standard.set(self.contraseña, forKey: "contraseña")
                                if let userId = (json["user_id"] as? Int){
                                    UserDefaults.standard.set(userId, forKey: "userId")
                                }
                            default:
                                print("Status recibido del servidor no especificado")
                            }
                        }
                        
                    } catch {
                        print("El error es: ")
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        if (UserDefaults.standard.object(forKey: "userId") as? Int) != nil{
                            //si se obtuvo un id de usuario, continua a la pagina principal
                            self.continuar()
                        }
                    })
                    
                }
            }.resume()
            
        }
        else{
            alerta(titulo: "Datos Incorrectos",mensaje: "Ingresa un correo valido")
        }
        
    }
    
    
    //********************************Funcion de creacion de cuenta********************************
    @objc func nuevaCuenta(tapGestureRecognizer: UITapGestureRecognizer) {
        
        usuario = emailField.text!
        contraseña = passwordField.text!
        
        if Utilities.isValidEmail(testStr: usuario){
            
            if contraseña.count > 5 {
                
                let urlRequestFiltros = "http://18.221.106.92/api/public/user/register"
            
                let parameters: [String:Any] = [
                    "email" : usuario,
                    "password" : contraseña
                ]
            
                guard let url = URL(string: urlRequestFiltros) else { return }
            
                var request = URLRequest (url: url)
                request.httpMethod = "POST"
            
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                }
            
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
                let session  = URLSession.shared
            
                session.dataTask(with: request) { (data, response, error) in
                    
                    if let response = response {
                        print(response)
                    }
                    
                    if let data = data {
                        
                        do {
                            let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                            
                            print(json["status"] as! Int)
                            print(json["mensaje"] as! String)
                            
                            if (json["status"] as! Int) == 1 {
                                //guarda los datos del usuario si la respuesta fue exitosa
                                UserDefaults.standard.set(self.usuario, forKey: "usuario")
                                UserDefaults.standard.set(self.contraseña, forKey: "contraseña")
                                if let userId = (json["user_id"] as? Int){
                                    UserDefaults.standard.set(userId, forKey: "userId")
                                }
                            }
                            
                        } catch {
                            print("El error es: ")
                            print(error)
                        }
                        
                        OperationQueue.main.addOperation({
                            if (UserDefaults.standard.object(forKey: "userId") as? Int) != nil{
                                //si se obtuvo un id de usuario, continua a la pagina principal
                                self.continuar()
                            }
                        })
                        
                    }
                }.resume()
                
            }
            else{
                alerta(titulo: "Datos Incorrectos",mensaje: "La contraseña debe tener al menos 6 caracteres")
            }
        }
        else{
            alerta(titulo: "Datos Incorrectos",mensaje: "Ingresa un correo valido")
        }
        
    }
    
    
    //*******************************Funciones para loggin con facebook******************************
    //when login button clicked
    @objc func loginButtonClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    

}
