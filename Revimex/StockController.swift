//
//  StockController.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Darwin


class StockController: UIViewController,UITableViewDataSource {
    
    //variables de referencia en la vista
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contenedorVista: UIScrollView!
    @IBOutlet weak var imagenBinvenida: UIImageView!
    @IBOutlet weak var registroBtn: UIButton!
    @IBOutlet weak var etiquetaBienvenida: UILabel!
    @IBOutlet weak var headerLineas: UILabel!
    @IBOutlet weak var lineasDeNegocio: UIView!
    @IBOutlet weak var contenedorImagenBienvenida: UIView!
    
    //medidas de la barra de navegacion
    var navigationBarSizeWidth: CGFloat = 0
    var navigationBarSizeHeigth: CGFloat = 0
    
    //variables de lineas de negocio
    let contenedorLineas = UIScrollView()
    var arrayLineas = [UIImageView]()
    
    //variables para la siguiente url de cada pagina
    var paginaSiguiente: String = "http://18.221.106.92/api/public/propiedades/lista"
    var haySiguiente: Bool = true
    
    //arreglo para guardar los datos del json
    var arregloOfertas = [Oferta]()
    
    //objeto para guardar los datos del json de lista
    class Oferta {
        var referencia: String
        var estado: String
        var precio: String
        var foto: UIImage
        var id: String
        
        init(referencia: String,id: String,estado: String, precio: String, foto: UIImage ){
            self.referencia = referencia
            self.id = id
            self.estado = estado
            self.precio = precio
            self.foto = foto
        }
    }
    
    //funcion que se ejecuta al cargar la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar()
        
        let navigationBarSize = self.navigationController?.navigationBar.bounds
        navigationBarSizeWidth = (navigationBarSize?.width)!
        navigationBarSizeHeigth = (navigationBarSize?.height)!
        
        tableView.backgroundColor = .clear
        
        //inserta la imagen de Bienvenida
        imagenBinvenida.image = UIImage(named: "revimexBienvenida.jpg")
        
        //genera los botones de ir a perfil o registrarse
        creaBotonesBarra()
        
        //genera el carrusel de lineas de negocio
        creaLineasDeNegocio()
        Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
        //llamado a la lista de propiedades
        creaTablaPropiedades(url: paginaSiguiente)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setCustomBackgroundAndNavbar()
    }
    
    //***********************funciones para crear la vista***************************
    func creaBotonesBarra(){
        
        //si ya se tiene id de usuario muestra el boton de cuenta, si no el de signin
        if (UserDefaults.standard.object(forKey: "userId") as? Int) != nil{
            
            registroBtn.isHidden = true
            etiquetaBienvenida.isHidden = false
            
            let tapGestureRecognizerImgAcct = UITapGestureRecognizer(target: self, action: #selector(imagenCuentaTapped(tapGestureRecognizer:)))
            
            
            let imagenCuenta = UIImage(named: "cuenta.png")
            
            imagenCuentaBtn.frame = CGRect(x: navigationBarSizeWidth-navigationBarSizeHeigth,y: 0.0,width: navigationBarSizeHeigth,height: navigationBarSizeHeigth)
            imagenCuentaBtn.setBackgroundImage(imagenCuenta, for: .normal)
            imagenCuentaBtn.addGestureRecognizer(tapGestureRecognizerImgAcct)
            
            navigationController?.navigationBar.addSubview(imagenCuentaBtn)
        }
        else{
            
            registroBtn.isHidden = false
            etiquetaBienvenida.isHidden = true
            
            let tapGestureRecognizerSignIn = UITapGestureRecognizer(target: self, action: #selector(incioSesionTapped(tapGestureRecognizer:)))
            
            incioSesionBtn.setTitle("SignIn", for: .normal)
            incioSesionBtn.frame = CGRect(x: navigationBarSizeWidth - (navigationBarSizeWidth * (0.2)),y: 0.0,width: navigationBarSizeWidth * (0.2),height: navigationBarSizeHeigth)
            incioSesionBtn.layer.masksToBounds = false
            incioSesionBtn.layer.shadowRadius = 1.0
            incioSesionBtn.layer.shadowColor = UIColor.black.cgColor
            incioSesionBtn.layer.shadowOffset = CGSize(width: 0.7,height: 0.7)
            incioSesionBtn.layer.shadowOpacity = 0.5
            incioSesionBtn.addGestureRecognizer(tapGestureRecognizerSignIn)
            navigationController?.navigationBar.addSubview(incioSesionBtn)
        }
    }
    
    func creaLineasDeNegocio(){
        //genera el carrusel de lineas de negocio
        
        let clienteFinal = UIImageView(image: UIImage(named: "clienteFinal.jpg"))
        let mercadoAbierto = UIImageView(image: UIImage(named: "mercadoAbierto.jpeg"))
        let inversionista = UIImageView(image: UIImage(named: "inversionista.jpg"))
        let brokerage = UIImageView(image: UIImage(named: "brokerage.jpeg"))
        
        arrayLineas.append(clienteFinal)
        arrayLineas.append(mercadoAbierto)
        arrayLineas.append(inversionista)
        arrayLineas.append(brokerage)
        
        contenedorLineas.frame = CGRect(x: 0,y: 0,width: lineasDeNegocio.bounds.width,height: lineasDeNegocio.bounds.height)
        contenedorLineas.contentSize = CGSize(width: (lineasDeNegocio.bounds.width * CGFloat(arrayLineas.count)), height: lineasDeNegocio.bounds.height)
        contenedorLineas.isPagingEnabled = true
        contenedorLineas.showsHorizontalScrollIndicator = false
        contenedorLineas.isUserInteractionEnabled = true
        
        for (index, linea) in arrayLineas.enumerated() {
            linea.frame = CGRect(x: (lineasDeNegocio.bounds.width * CGFloat(index)),y: 0,width: lineasDeNegocio.frame.width,height: lineasDeNegocio.bounds.height)
            
            contenedorLineas.addSubview(linea)
        }
        
        let tapGestureRecognizerLinea = UITapGestureRecognizer(target: self, action: #selector(irLinea(tapGestureRecognizer: )))
        
        lineasDeNegocio.addGestureRecognizer(tapGestureRecognizerLinea)
        
        lineasDeNegocio.addSubview(contenedorLineas)
        lineasDeNegocio.bringSubview(toFront: headerLineas)
        
    }
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = contenedorLineas.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(arrayLineas.count)
        let contentOffset:CGFloat = contenedorLineas.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        contenedorLineas.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:contenedorLineas.frame.height), animated: true)
    }
    
    //llamado a la lista de propiedades
    func creaTablaPropiedades(url: String){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        
        //url para la llamada
        guard let url = URL(string: url) else { return }
        
        //configuracion e incio del request
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        let session  = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    print("json de propiedades: ")
                    print(json["propiedades"]!!)
                    
                    if let propiedades = json["propiedades"] as? NSDictionary {
                        
                        if let data = propiedades["data"]! as? NSArray{
                            for propiedad in data {
                                
                                if let atribute = propiedad as? NSDictionary {
                                    
                                    print("************Inicia propiedad************")
                                    print(atribute)
                                    
                                    let oferta: Oferta = Oferta(referencia: "",id: "",estado: "",precio: "",foto: UIImage(named: "imagenNoEncontrada.png")!)
                                    
                                    if let refer = atribute["Referencia"] as? String{
                                        oferta.referencia = refer
                                    }
                                    
                                    if let idProp = atribute["idp"] as? Int{
                                        oferta.id = String(idProp)
                                    }
                                    
                                    if let nomEst = atribute["estado"] as? String {
                                        oferta.estado = nomEst
                                    }
                                    
                                    if let pecProp = atribute["precio"] as? String {
                                        oferta.precio = pecProp
                                    }
                                    
                                    if let propImage = atribute["fotoPrincipal"] as? String {
                                        oferta.foto = Utilities.traerImagen(urlImagen: propImage)
                                    }
                                    
                                    self.arregloOfertas.append(oferta)
                                    
                                    if let nextPage = propiedades["next_page_url"] as? String{
                                        self.paginaSiguiente = nextPage
                                        self.haySiguiente = true
                                    }
                                }
                                else{
                                    self.haySiguiente = false
                                }
                            }
                        }
                        else{
                            print("ERROR: Hubo un problema al obtener propiedades[\"data\"] ")
                        }
                    }
                    else{
                        print("ERROR: Hubo un problema al obtener json[\"propiedades\"] ")
                    }
                    
                } catch {
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })
                
            }
            }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(arregloOfertas.count)
        return arregloOfertas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let row = tableView.dequeueReusableCell(withIdentifier: "row") as! TableViewCell
        row.idOfertaActual = arregloOfertas[indexPath.row].id
        row.referencia.textColor = UIColor.white
        row.estado.textColor = UIColor.white
        row.precio.textColor = UIColor.white
        row.referencia.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        row.estado.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        row.precio.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        row.referencia.text = arregloOfertas[indexPath.row].referencia
        row.estado.text = arregloOfertas[indexPath.row].estado
        row.precio.text = "$" + arregloOfertas[indexPath.row].precio
        row.vistaFoto.image = arregloOfertas[indexPath.row].foto
        print(indexPath.row)
        
        row.backgroundColor = .clear
        
        if arregloOfertas.count == (indexPath.row + 1){
            if haySiguiente {
                creaTablaPropiedades(url: paginaSiguiente)
            }
        }
        
        return row
    }
    
    
    @objc func incioSesionTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //oculta la barra de navegacion del login
        navBarStyleCase = 1
        performSegue(withIdentifier: "stockToLogin", sender: nil)
    }
    
    @objc func imagenCuentaTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "stockToInfo", sender: nil)
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        //oculta la barra de navegacion del login
        navBarStyleCase = 1
        performSegue(withIdentifier: "stockToLogin", sender: nil)
    }
    
    @objc func irLinea(tapGestureRecognizer: UITapGestureRecognizer) {
        let pageWidth:CGFloat = contenedorLineas.frame.width
        let contentOffset:CGFloat = contenedorLineas.contentOffset.x
        lineaSeleccionada = Int(contentOffset)/Int(pageWidth)
        performSegue(withIdentifier: "stockToLineasInfo", sender: nil)
    }
    
    
}
