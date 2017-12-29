//
//  FavoritesController.swift
//  Revimex
//
//  Created by Seifer on 17/11/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class FavoritesController: UIViewController {
    
    var anchoPantalla = CGFloat(0)
    var largoPantalla = CGFloat(0)
    
    var arrayFavoitos = [Favorito]()
    
    class goToDetailsGestureRecognizer: UITapGestureRecognizer {
        var idPropiedad: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar()
        favs = self;
        
        anchoPantalla = view.bounds.width
        largoPantalla = view.bounds.height
        let top = (navigationController?.navigationBar.bounds.height)!+20
        
        let tapGestureRecognizerMisFavoritos = UITapGestureRecognizer(target: self, action: #selector(misFavoritosTapped(tapGestureRecognizer:)))
        let misFavoritos = UIButton()
        misFavoritos.frame = CGRect(x: 0, y: top, width: anchoPantalla/2, height: largoPantalla * (0.07))
        misFavoritos.setTitle("Mis Favoritos", for: .normal)
        misFavoritos.setTitleColor(UIColor.white, for: .normal)
        misFavoritos.layer.borderWidth = 1
        misFavoritos.layer.borderColor = UIColor.white.cgColor
        misFavoritos.addGestureRecognizer(tapGestureRecognizerMisFavoritos)
        
        let tapGestureRecognizerSugerencias = UITapGestureRecognizer(target: self, action: #selector(sugerenciasTapped(tapGestureRecognizer:)))
        let sugerencias = UIButton()
        sugerencias.frame = CGRect(x: anchoPantalla/2, y: top, width: anchoPantalla/2, height: largoPantalla * (0.07))
        sugerencias.setTitle("Sugerencias", for: .normal)
        sugerencias.setTitleColor(UIColor.white, for: .normal)
        sugerencias.layer.borderWidth = 1
        sugerencias.layer.borderColor = UIColor.white.cgColor
        sugerencias.addGestureRecognizer(tapGestureRecognizerSugerencias)
        
        view.addSubview(misFavoritos)
        view.addSubview(sugerencias)
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            msotrarFavoritos(userId: userId)
        }
        else{
            solicitarRegistro()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setCustomBackgroundAndNavbar()
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int,cambioFavoritos{
            msotrarFavoritos(userId: userId);
        }
    }
    
    
    public func msotrarFavoritos(userId: Int){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        arrayFavoitos = []
        
        let urlFvoritos =  "http://18.221.106.92/api/public/favorites/" + String(userId)
        
        guard let url = URL(string: urlFvoritos) else { return }
        
        let session  = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("response:")
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data)
                    
                    for element in json as! NSArray {
                        print("************Empieza Favorito************")
                        print(element)
                        
                        if let favorito = element as? NSDictionary{
                            
                            let objectFavorito = Favorito(idPropiedad: "", estado: "", precio: "", referencia: "", fechaAgregado: "", foto: UIImage(named: "imagenNoEncontrada.png")!, urlPropiedad: "")
                            
                            if let edo = favorito["agregado"] as? String{
                                objectFavorito.fechaAgregado = edo
                            }
                            
                            if let idPropiedad = favorito["idPropiedad"] as? Int{
                                objectFavorito.idPropiedad = String(idPropiedad)
                            }
                            
                            if let favoritoPropiedad = favorito["propiedades"] as? NSArray{
                                for propiedad in favoritoPropiedad{
                                    if let atributoPropiedad = propiedad as? NSDictionary{
                                        
                                        if let estado = atributoPropiedad["Estado__c"] as? String{
                                            objectFavorito.estado = estado
                                        }
                                        if let precio = atributoPropiedad["ValorReferencia__c"] as? String{
                                            objectFavorito.precio = precio
                                        }
                                        if let referencia = atributoPropiedad["Referencia"] as? String{
                                            objectFavorito.referencia = referencia
                                        }
                                        if let urlPropiedad = atributoPropiedad["url_propiedad"] as? String{
                                            objectFavorito.urlPropiedad = urlPropiedad
                                        }
                                        if let urlImagen = atributoPropiedad["url_imagen"] as? String{
                                            objectFavorito.foto = Utilities.traerImagen(urlImagen: urlImagen)
                                        }
                                    }
                                }
                            }
                            
                            self.arrayFavoitos.append(objectFavorito)
                            
                        }
                    }
                    
                }catch {
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    cambioFavoritos = false
                    self.mostrarMisFavoritos()
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })
                
            }
        }.resume()
    }
    
    func mostrarMisFavoritos(){
        
        let largoDeFavorito = (largoPantalla * 0.6)
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        
        let contenedorFavoritos = UIScrollView()
        
        contenedorFavoritos.frame = CGRect(x: 0, y: (largoPantalla * (0.07) + (navigationController?.navigationBar.bounds.height)!+20), width: anchoPantalla, height: (largoPantalla * 0.92) - tabBarHeight!)
        let largoContenido = largoDeFavorito * CGFloat(arrayFavoitos.count) 
        contenedorFavoritos.contentSize = CGSize(width: anchoPantalla, height: largoContenido)
        
        for (index, favorito) in arrayFavoitos.enumerated() {
            
            //tamaño del marco de elemento: 60% de la pantalla
            let marcoFavorito = UIView()
            
            marcoFavorito.frame.origin.x = 0
            marcoFavorito.frame.origin.y = largoDeFavorito * CGFloat(index)
            marcoFavorito.frame.size = CGSize(width: anchoPantalla, height: largoDeFavorito)
            marcoFavorito.addBorder(toSide: .Top, withColor: UIColor.gray.cgColor, andThickness: 1.0)
            marcoFavorito.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1.0)
            
            let background = UIImageView(image: favorito.foto)
            background.frame = marcoFavorito.bounds
            background.frame.size = CGSize(width: anchoPantalla, height: largoDeFavorito - 2)
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            visualEffectView.frame = background.bounds
            visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            background.addSubview(visualEffectView)
            marcoFavorito.addSubview(background)
            marcoFavorito.sendSubview(toBack: background)
            
            let largoContenedor = marcoFavorito.bounds.height
            
            //tamaño de la foto: 60% del marco
            let foto = UIImageView(image: favorito.foto)
            foto.frame = CGRect(x: 0,y: (largoContenedor * 0.05),width: anchoPantalla, height: (largoContenedor * 0.55))
            
            //tamaño de la foto: 40% del marco
            let info = UIView()
            info.frame = CGRect(x: anchoPantalla * 0.02,y: (largoContenedor * 0.62),width: anchoPantalla * 0.96, height: (largoContenedor * 0.36))
            info.backgroundColor = azulClaro!.withAlphaComponent(0.3)
            info.isOpaque = false
            info.layer.cornerRadius = 5
            info.layer.borderWidth = 0.5
            info.layer.borderColor = UIColor.gray.cgColor
            
            let largoInfo = info.bounds.height
            //elementos de info
            let  titulo = UILabel()
            titulo.text = "Detalles"
            titulo.font = titulo.font.withSize(15)
            let estado = UILabel()
            estado.text = "Estado: "+favorito.estado
            let precio = UILabel()
            precio.text = "Precio: $"+favorito.precio
            let referencia = UILabel()
            referencia.text = "Referencia: "+favorito.referencia
            let agregado = UILabel()
            agregado.text = "Agregado: "+favorito.fechaAgregado
            let detallesBtn = UIButton()
            //            let urlReferenciaBtn = UIButton()
            //            urlReferenciaBtn.setTitle("Ver en "+favorito.referencia, for: .normal)
            
            titulo.frame = CGRect(x: 5,y: -5,width: info.bounds.width, height: (largoInfo * 0.2))
            
            estado.frame = CGRect(x: 5,y: (largoInfo * 0.2),width: info.bounds.width, height: (largoInfo * 0.2))
            precio.frame = CGRect(x: 5,y: (largoInfo * 0.4),width: info.bounds.width, height: (largoInfo * 0.2))
            referencia.frame = CGRect(x: 5,y: (largoInfo * 0.6),width: info.bounds.width, height: (largoInfo * 0.2))
            agregado.frame = CGRect(x: 5,y: (largoInfo * 0.8),width: info.bounds.width, height: (largoInfo * 0.2))
            
            let tapGestureRecognizerDetalles = goToDetailsGestureRecognizer(target: self, action: #selector(irDetalles(tapGestureRecognizer: )))
            tapGestureRecognizerDetalles.idPropiedad = favorito.idPropiedad
            detallesBtn.frame = CGRect(x: 0,y: 0,width: marcoFavorito.bounds.width, height: marcoFavorito.bounds.height)
            detallesBtn.addGestureRecognizer(tapGestureRecognizerDetalles)
            //urlReferenciaBtn.frame = CGRect(x: 0,y: (largoContenedor * 0.8),width: anchoPantalla, height: (largoContenedor * 0.33))
            
            info.addSubview(titulo)
            info.addSubview(estado)
            info.addSubview(precio)
            info.addSubview(referencia)
            info.addSubview(agregado)
            //            info.addSubview(urlReferenciaBtn)
            
            
            marcoFavorito.addSubview(foto)
            marcoFavorito.addSubview(info)
            marcoFavorito.addSubview(detallesBtn)
            contenedorFavoritos.addSubview(marcoFavorito)
        }
        
        if let oldContainer = self.view.viewWithTag(100){
            oldContainer.removeFromSuperview()
        }
        contenedorFavoritos.tag = 100
        view.addSubview(contenedorFavoritos)
        view.sendSubview(toBack: contenedorFavoritos)
        
    }
    
    
    func solicitarRegistro(){
        
        let contenedorInfo = UIView()
        contenedorInfo.frame = CGRect(x: anchoPantalla * (0.1), y: (largoPantalla * (0.08)), width: anchoPantalla * (0.8), height: largoPantalla * (0.8))
        
        let image = UIImage(named: "favoritosSinLogin.png")
        let notLoggedMessage = UIImageView(image: image)
        notLoggedMessage.frame = CGRect(x: 0, y: largoPantalla * (0.07), width: contenedorInfo.bounds.width, height: contenedorInfo.bounds.height)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mostrarLogin(tapGestureRecognizer:)))
        let loginBtn = UIButton()
        loginBtn.frame = CGRect(x: anchoPantalla * (0.15), y: largoPantalla * (0.8), width: anchoPantalla * (0.7), height: largoPantalla * (0.06))
        loginBtn.backgroundColor = gris
        loginBtn.setTitle("Registrarse", for: .normal)
        loginBtn.addGestureRecognizer(tapGestureRecognizer)
        
        contenedorInfo.addSubview(notLoggedMessage)
        view.addSubview(contenedorInfo)
        view.addSubview(loginBtn)
        view.sendSubview(toBack: contenedorInfo)
        
    }
    
    
    @objc func mostrarLogin(tapGestureRecognizer: UITapGestureRecognizer){
        print("fue a login")
        navBarStyleCase = 2
        performSegue(withIdentifier: "favoritesToLogin", sender: nil)
    }
    
    
    @objc func misFavoritosTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("favoritos")
    }
    
    
    @objc func sugerenciasTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("sugerencias")
    }
    
    @objc func irDetalles(tapGestureRecognizer: goToDetailsGestureRecognizer){
        print(tapGestureRecognizer.idPropiedad!)
        idOfertaSeleccionada = tapGestureRecognizer.idPropiedad!
        performSegue(withIdentifier: "favoritesToDetails", sender: nil)
    }
    
}
