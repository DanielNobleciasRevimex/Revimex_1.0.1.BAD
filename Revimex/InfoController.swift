//
//  InfoController.swift
//  Revimex
//
//  Created by Seifer on 11/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class InfoController: UIViewController {
    
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var contenedorCarousel: UIScrollView!
    @IBOutlet weak var favoritosBtn: UIButton!
    @IBOutlet weak var carritoBtn: UIButton!
    
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var municipio: UILabel!
    @IBOutlet weak var tipo: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var metros: UILabel!
    @IBOutlet weak var terreno: UILabel!
    @IBOutlet weak var constuccion: UILabel!
    @IBOutlet weak var habitaciones: UILabel!
    @IBOutlet weak var baños: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var botonesContainer: UIView!
    @IBOutlet weak var headerInfoContainer: UIView!
    @IBOutlet weak var habitacionesImage: UIImageView!
    @IBOutlet weak var bañosImage: UIImageView!
    
    var agregarCarrito = true
    var idCarrito = -1
    
    var activityIndicator = UIActivityIndicatorView()
    var background = UIView()
    
    //variable para el carousel
    var vistaCarouselGrande = UIView()
    var contenedorCarouselGrande = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        habitacionesImage.image = UIImage(named: "habitaciones.png")
        bañosImage.image = UIImage(named: "baños.png")
        estado.font = UIFont.boldSystemFont(ofSize: 17.0)
        municipio.font = UIFont.boldSystemFont(ofSize: 17.0)
        precio.font = UIFont.boldSystemFont(ofSize: 17.0)
        terreno.font = UIFont.boldSystemFont(ofSize: 16.0)
        constuccion.font = UIFont.boldSystemFont(ofSize: 16.0)
        baños.font = UIFont.boldSystemFont(ofSize: 17.0)
        habitaciones.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        botonesContainer.backgroundColor = UIColor(white: 1, alpha: 0.1)
        headerInfoContainer.backgroundColor = UIColor(white: 1, alpha: 0.1)
        view?.backgroundColor = UIColor(white: 1, alpha: 0)
        
        favoritosBtn.setBackgroundImage(UIImage(named: "favorites.png") as UIImage?, for: .normal)
        carritoBtn.setBackgroundImage(UIImage(named: "carritoDisponible.png") as UIImage?, for: .normal)
        
        //verificar favoritos
        self.revisarFavoritos()
        
        //verificar carritos
        self.revisarCarritos()
        
        //request a detalles
        requestDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //llamado a los detalles de la propiedad seleccionada
    func requestDetails() {
        
        //indicador de loading
        activityIndicator = UIActivityIndicatorView()
        background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        let urlRequestDetails = "http://18.221.106.92/api/public/propiedades/detalle"
        
        let parameters = "id=" + idOfertaSeleccionada
        
        guard let url = URL(string: urlRequestDetails) else { return }
        
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        let httpBody = parameters.data(using: .utf8)
        
        request.httpBody = httpBody
        
        let session  = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    
                    if let propiedadSeleccionada = json["propiedad"] as? NSDictionary {
                        print("*********Propiedad seleccionada***********")
                        print(propiedadSeleccionada)
                        
                        if  let id = propiedadSeleccionada["Id"] as? String { propiedad.Id = id }
                        if  let calle = propiedadSeleccionada["calle"] as? String { propiedad.calle = calle }
                        if  let colonia = propiedadSeleccionada["colonia"] as? String { propiedad.colonia = colonia }
                        if  let construccion = propiedadSeleccionada["construccion"] as? String { propiedad.construccion = construccion + "m2"}
                        if  let cp = propiedadSeleccionada["cp"] as? String { propiedad.cp = "C.P. " + cp }
                        if  let estacionamiento = propiedadSeleccionada["estacionamiento"] as? String { propiedad.estacionamiento = estacionamiento}
                        if  let estado = propiedadSeleccionada["estado"] as? String { propiedad.estado = estado }
                        if  let habitaciones = propiedadSeleccionada["habitaciones"] as? String { propiedad.habitaciones = habitaciones}
                        if  let idp = propiedadSeleccionada["idp"] as? String { propiedad.idp = idp }
                        if  let lat = propiedadSeleccionada["lat"] as? String,lat != "" { propiedad.lat = lat }
                        if  let lon = propiedadSeleccionada["lon"] as? String,lon != "" { propiedad.lon = lon }
                        if  let municipio = propiedadSeleccionada["municipio"] as? String { propiedad.municipio = municipio }
                        if  let niveles = propiedadSeleccionada["niveles"] as? String { propiedad.niveles = niveles + " niveles"}
                        if  let origen_propiedad = propiedadSeleccionada["origen_propiedad"] as? String { propiedad.origen_propiedad = origen_propiedad }
                        if  let patios = propiedadSeleccionada["patios"] as? String { propiedad.patios = patios}
                        if  let precio = propiedadSeleccionada["precio"] as? String { propiedad.precio = "$" + precio}
                        if  let terreno = propiedadSeleccionada["terreno"] as? String { propiedad.terreno = terreno + "m2"}
                        if  let tipo = propiedadSeleccionada["tipo"] as? String { propiedad.tipo = tipo}
                        if  let descripcion = propiedadSeleccionada["descripcion"] as? String { propiedad.descripcion = descripcion }
                        if  let pros = propiedadSeleccionada["pros"] as? String { propiedad.pros = pros }
                        if  let wcs = propiedadSeleccionada["wcs"] as? String { propiedad.wcs = wcs }
                        
                        if  let files = propiedadSeleccionada["files"] as? Array<Any?> {
                            for element in files{
                                if let file = element as? NSDictionary {
                                    if  let linkPublico = file["linkPublico"]! as? String{
                                        propiedad.fotos.append(linkPublico)
                                        print(propiedad.fotos)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    self.incio()
                })
                
            }
        }.resume()
        
    }
    
    func incio() {
        
        print("***********Datos de la propiedad***************")
        print(propiedad.Id)
        print(propiedad.calle)
        print(propiedad.colonia)
        print(propiedad.construccion)
        print(propiedad.cp)
        print(propiedad.estacionamiento)
        print(propiedad.estado)
        print(propiedad.habitaciones)
        print(propiedad.idp)
        print(propiedad.lat)
        print(propiedad.lon)
        print(propiedad.municipio)
        print(propiedad.niveles)
        print(propiedad.origen_propiedad)
        print(propiedad.patios)
        print(propiedad.precio)
        print(propiedad.terreno)
        print(propiedad.tipo)
        print(propiedad.wcs)
        print(propiedad.fotos)
        
        //inicia asignacion de valores a descripcion
        if propiedad.descripcion != ""{
            descripcion.text = propiedad.descripcion
        }
        else if propiedad.pros != ""{
            descripcion.text = propiedad.pros
        }
        else {
            descripcion.text = "Descripcion no disponible"
        }
        
        estado.text = propiedad.estado
        municipio.text = propiedad.municipio
        tipo.text = propiedad.tipo
        precio.text = propiedad.precio
        metros.text = "Terreno/Const."
        terreno.text = propiedad.terreno
        constuccion.text = propiedad.construccion
        habitaciones.text = propiedad.habitaciones + " Habitaciones"
        baños.text = propiedad.wcs + " Baños"
        direccion.text = propiedad.calle + " " + propiedad.colonia + " " + propiedad.cp
        
        descripcion.isEditable = false
        
        //muestra las fotos
        showPhotos()
        
        
    }
    
    //muestra las fotos
    func showPhotos() {
        let ancho = contenedorCarousel.bounds.width
        let largo = contenedorCarousel.bounds.height
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(carouselTapped(tapGestureRecognizer:)))
        contenedorCarousel.isUserInteractionEnabled = true
        contenedorCarousel.addGestureRecognizer(tapGestureRecognizer)
        
        contenedorCarousel.contentSize = CGSize(width: ancho * CGFloat(propiedad.fotos.count), height: largo)
        contenedorCarousel.isPagingEnabled = true
        contenedorCarousel.showsHorizontalScrollIndicator = false
        
        
        for (index, url) in propiedad.fotos.enumerated() {
            
            let marco = UIImageView(image: Utilities.traerImagen(urlImagen: url))
            
            marco.frame.origin.x = ancho * CGFloat(index)
            marco.frame.origin.y = 0
            marco.frame.size = CGSize(width: ancho, height: largo)
            contenedorCarousel.addSubview(marco)
            
        }
        
        activityIndicator.stopAnimating()
        background.removeFromSuperview()
    }
    
    
    //accion al presionar en el carousel de fotos pequeño
    @objc func carouselTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        vistaCarouselGrande.frame = CGRect(x: 0 ,y: 0 ,width: self.view.frame.width,height: self.view.frame.height)
        vistaCarouselGrande.backgroundColor = UIColor.black
        vistaCarouselGrande.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        
        let ancho = view.bounds.width
        let largo = view.bounds.height
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageBigCarouselTapped(tapGestureRecognizer:)))
        vistaCarouselGrande.isUserInteractionEnabled = true
        vistaCarouselGrande.addGestureRecognizer(tapGestureRecognizer)
        
        
        contenedorCarouselGrande.frame.size = CGSize(width: view.bounds.width, height: view.bounds.width * (0.8))
        contenedorCarouselGrande.contentSize = CGSize(width: ancho * CGFloat(propiedad.fotos.count), height: view.bounds.width * (0.8))
        contenedorCarouselGrande.frame.origin.x = 0
        contenedorCarouselGrande.frame.origin.y = largo/4
        contenedorCarouselGrande.isPagingEnabled = true
        contenedorCarouselGrande.showsHorizontalScrollIndicator = false
        
        
        for (index, url) in propiedad.fotos.enumerated() {
            
            let marco = UIImageView(image: Utilities.traerImagen(urlImagen: url))
            
            marco.frame.origin.x = ancho * CGFloat(index)
            marco.frame.origin.y = 0
            marco.frame.size = CGSize(width: ancho, height: view.bounds.width * (0.8))
            contenedorCarouselGrande.addSubview(marco)
            
        }
        
        vistaCarouselGrande.addSubview(contenedorCarouselGrande)
        
        view.addSubview(vistaCarouselGrande)
        
    }
    
    //oculta el carousel grande
    @objc func imageBigCarouselTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        contenedorCarouselGrande.removeFromSuperview()
        vistaCarouselGrande.removeFromSuperview()
    }
    
    
    //***************************funciones favoritos**********************************
    @IBAction func favoritos(_ sender: Any) {
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            
            let urlRequestFavoritos = "http://18.221.106.92/api/public/user/favorito"
            
            guard let url = URL(string: urlRequestFavoritos) else { return }
            
            var request = URLRequest (url: url)
            request.httpMethod = "POST"
            
            let parameters: [String:Any] = [
                "user_id" : userId,
                "prop_id" : idOfertaSeleccionada
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print(userId)
            print(idOfertaSeleccionada)
            
            let session  = URLSession.shared
            
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                        
                        print(json)
                        
                    } catch {
                        print("El error es: ")
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        cambioFavoritos = true
                        self.revisarFavoritos()
                    })
                    
                }
                }.resume()
        }
        else{
            navBarStyleCase = 1
            performSegue(withIdentifier: "descriptionToLogin", sender: nil)
        }
        
    }
    
    
    
    func revisarFavoritos(){
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            
            var favoritos: [Int] = []
            
            let urlRequestFavoritos = "http://18.221.106.92/api/public/user/favorito"
            
            guard let url = URL(string: urlRequestFavoritos) else { return }
            
            var request = URLRequest (url: url)
            request.httpMethod = "POST"
            
            let parameters: [String:Any] = [
                "user_id" : userId,
                "consulta" : 1
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print(userId)
            print(idOfertaSeleccionada)
            
            let session  = URLSession.shared
            
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                        
                        print(json)
                        if(favs != nil){
                            
                            favs.msotrarFavoritos(userId: UserDefaults.standard.integer(forKey: "userId"));
                        
                        }
                        if let jsonFavoritos = json["favoritos"] as? [Int]{
                            favoritos = jsonFavoritos
                        }
                        
                    } catch {
                        print("El error es: ")
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        self.favoritosBtn.setBackgroundImage(UIImage(named: "favorites.png") as UIImage?, for: .normal)
                        for favorito in favoritos{
                            if String(favorito) == idOfertaSeleccionada{
                                self.favoritosBtn.setBackgroundImage(UIImage(named: "favoritoSeleccionado.png") as UIImage?, for: .normal)
                                break
                            }
                        }
                    })
                    
                }
            }.resume()
        }
        
    }
    
    //***************************funciones carritos**********************************
    @IBAction func metodoCarrito(_ sender: Any) {
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            if agregarCarrito {
                agregarAlCarrito(userId: userId)
            }
            else{
                removerDeCarrito()
            }
        }
        else{
            navBarStyleCase = 1
            performSegue(withIdentifier: "descriptionToLogin", sender: nil)
        }
    }
    
    
    
    func agregarAlCarrito(userId: Int) {
        
        let urlRequestCarritos = "http://18.221.106.92/api/public/cart"
        
        guard let url = URL(string: urlRequestCarritos) else { return }
        
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        let parameters: [String:Any] = [
            "user_id" : userId,
            "propiedad_id" : idOfertaSeleccionada
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(userId)
        print(idOfertaSeleccionada)
        
        let session  = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    print(json)
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    cambioCarritos = true
                    self.revisarCarritos()
                })
                
            }
            }.resume()
    }
    
    
    
    func removerDeCarrito() {
        let urlRequestCarritos = "http://18.221.106.92/api/public/cart/" + String(idCarrito)
        
        guard let url = URL(string: urlRequestCarritos) else { return }
        
        var request = URLRequest (url: url)
        request.httpMethod = "DELETE"
    
        print(idOfertaSeleccionada)
        
        let session  = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    print(json)
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    cambioCarritos = true
                    self.revisarCarritos()
                })
                
            }
            }.resume()
    }
    
    
    
    func revisarCarritos(){
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            
            var carritos: [Int] = []
            
            let urlCarritos =  "http://18.221.106.92/api/public/cart/" + String(userId)
            
            guard let url = URL(string: urlCarritos) else { return }
            
            let session  = URLSession.shared
            
            session.dataTask(with: url) { (data, response, error) in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject (with: data) as! NSDictionary
                        
                        if let dat = json["data"] as? NSArray {
                            
                            for element in dat {
                                if let carrito = element as? NSDictionary{
                                    if let idPropiedad = carrito["propiedad_id"] as? Int{
                                        carritos.append(idPropiedad)
                                    }
                                    if let idCart = carrito["id"] as? Int{
                                        self.idCarrito = idCart
                                    }
                                }
                            }
                            
                        }
                        
                    } catch {
                        print("El error es: ")
                        print(error)
                    }
                    
                    OperationQueue.main.addOperation({
                        
                        self.carritoBtn.setBackgroundImage(UIImage(named: "carritoDisponible.png") as UIImage?, for: .normal)
                        self.agregarCarrito = true
                        
                        for carrito in carritos{
                            if String(carrito) == idOfertaSeleccionada{
                                self.carritoBtn.setBackgroundImage(UIImage(named: "carritoSeleccionado.png") as UIImage?, for: .normal)
                                self.agregarCarrito = false
                                break
                            }
                        }
                    })
                    
                }
            }.resume()
        }
        
    }
    
    
    
    @IBAction func compartir(_ sender: Any) {
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            
        }
        else{
            navBarStyleCase = 1
            performSegue(withIdentifier: "descriptionToLogin", sender: nil)
        }
        
    }
    

}
