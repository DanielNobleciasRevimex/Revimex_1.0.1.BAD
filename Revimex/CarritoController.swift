//
//  CarritoController.swift
//  Revimex
//
//  Created by Seifer on 14/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class CarritoController: UIViewController {
    
    var anchoPantalla = CGFloat(0)
    var largoPantalla = CGFloat(0)
    
    var arrayCarritos = [Carrito]()
    
    class goToDetailsGestureRecognizer: UITapGestureRecognizer {
        var idPropiedad: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar()
        
        anchoPantalla = view.bounds.width
        largoPantalla = view.bounds.height
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int{
            mostrarCarritos(userId: userId)
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
        
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int,cambioCarritos{
            mostrarCarritos(userId: userId)
        }
    }
    
    
    func mostrarCarritos(userId: Int){
        
        //indicador de loading
        let activityIndicator = UIActivityIndicatorView()
        let background = Utilities.activityIndicatorBackground(activityIndicator: activityIndicator)
        background.center = self.view.center
        view.addSubview(background)
        activityIndicator.startAnimating()
        
        arrayCarritos = []
        
        let urlCarritos =  "http://18.221.106.92/api/public/cart/" + String(userId)
        
        guard let url = URL(string: urlCarritos) else { return }
        
        let session  = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("response:")
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! NSDictionary
                    
                    if let dat = json["data"] as? NSArray {
                        
                        for element in dat {
                            if let carrito = element as? NSDictionary{
                                print("************Empieza Carrito************")
                                print(carrito)
                                
                                let objectCarrito = Carrito(idPropiedad: "", estado: "", precio: "", referencia: "", fechaAgregado: "", foto: UIImage(named: "imagenNoEncontrada.png")!, urlPropiedad: "")
                                
                                if let created = carrito["created_at"] as? String{
                                    objectCarrito.fechaAgregado = created
                                }

                                if let idPropiedad = carrito["propiedad_id"] as? Int{
                                    objectCarrito.idPropiedad = String(idPropiedad)
                                }
                                
                                if let favoritoPropiedad = carrito["propiedades"] as? NSArray{
                                    for propiedad in favoritoPropiedad{
                                        if let atributoPropiedad = propiedad as? NSDictionary{
                                            if let estado = atributoPropiedad["Estado__c"] as? String{
                                                objectCarrito.estado = estado
                                            }
                                            if let precio = atributoPropiedad["ValorReferencia__c"] as? String{
                                                objectCarrito.precio = precio
                                            }
                                            if let referencia = atributoPropiedad["Referencia"] as? String{
                                                objectCarrito.referencia = referencia
                                            }
                                            if let urlPropiedad = atributoPropiedad["url_propiedad"] as? String{
                                                objectCarrito.urlPropiedad = urlPropiedad
                                            }
                                            if let urlImagen = atributoPropiedad["url_imagen"] as? String{
                                                objectCarrito.foto = Utilities.traerImagen(urlImagen: urlImagen)
                                            }
                                        }
                                    }
                                }
                                            
                                self.arrayCarritos.append(objectCarrito)
                                
                                
                            }
                            
                        }
                        
                    }
             
                }catch {
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    cambioCarritos = false
                    self.mostrarMisCarritos()
                    activityIndicator.stopAnimating()
                    background.removeFromSuperview()
                })
                
            }
        }.resume()
    }
    
    func mostrarMisCarritos(){

        let largoDeCarrito = (largoPantalla * 0.6)
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height

        let contenedorCarritos = UIScrollView()

        contenedorCarritos.frame = CGRect(x: 0, y: (navigationController?.navigationBar.bounds.height)! + 20, width: anchoPantalla, height: largoPantalla - tabBarHeight!)
        let largoContenido = largoDeCarrito * CGFloat(arrayCarritos.count)
        contenedorCarritos.contentSize = CGSize(width: anchoPantalla, height: largoContenido)

        for (index, carrito) in arrayCarritos.enumerated() {

            //tamaño del marco de elemento: 60% de la pantalla
            let marcoCarrito = UIView()

            marcoCarrito.frame.origin.x = 0
            marcoCarrito.frame.origin.y = largoDeCarrito * CGFloat(index)
            marcoCarrito.frame.size = CGSize(width: anchoPantalla, height: largoDeCarrito)
            marcoCarrito.addBorder(toSide: .Top, withColor: UIColor.gray.cgColor, andThickness: 1.0)
            marcoCarrito.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1.0)

            let background = UIImageView(image: carrito.foto)
            background.frame = marcoCarrito.bounds
            background.frame.size = CGSize(width: anchoPantalla, height: largoDeCarrito - 2)
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            visualEffectView.frame = background.bounds
            visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            background.addSubview(visualEffectView)
            marcoCarrito.addSubview(background)
            marcoCarrito.sendSubview(toBack: background)

            let largoContenedor = marcoCarrito.bounds.height

            //tamaño de la foto: 60% del marco
            let foto = UIImageView(image: carrito.foto)
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
            estado.text = "Estado: "+carrito.estado
            let precio = UILabel()
            precio.text = "Precio: $"+carrito.precio
            let referencia = UILabel()
            referencia.text = "Referencia: "+carrito.referencia
            let agregado = UILabel()
            agregado.text = "Agregado: "+carrito.fechaAgregado
            let detallesBtn = UIButton()
            //            let urlReferenciaBtn = UIButton()
            //            urlReferenciaBtn.setTitle("Ver en "+favorito.referencia, for: .normal)

            titulo.frame = CGRect(x: 5,y: -5,width: info.bounds.width, height: (largoInfo * 0.2))

            estado.frame = CGRect(x: 5,y: (largoInfo * 0.2),width: info.bounds.width, height: (largoInfo * 0.2))
            precio.frame = CGRect(x: 5,y: (largoInfo * 0.4),width: info.bounds.width, height: (largoInfo * 0.2))
            referencia.frame = CGRect(x: 5,y: (largoInfo * 0.6),width: info.bounds.width, height: (largoInfo * 0.2))
            agregado.frame = CGRect(x: 5,y: (largoInfo * 0.8),width: info.bounds.width, height: (largoInfo * 0.2))

            let tapGestureRecognizerDetalles = goToDetailsGestureRecognizer(target: self, action: #selector(irDetalles(tapGestureRecognizer: )))
            tapGestureRecognizerDetalles.idPropiedad = carrito.idPropiedad
            detallesBtn.frame = CGRect(x: 0,y: 0,width: marcoCarrito.bounds.width, height: marcoCarrito.bounds.height)
            detallesBtn.addGestureRecognizer(tapGestureRecognizerDetalles)
            //urlReferenciaBtn.frame = CGRect(x: 0,y: (largoContenedor * 0.8),width: anchoPantalla, height: (largoContenedor * 0.33))

            info.addSubview(titulo)
            info.addSubview(estado)
            info.addSubview(precio)
            info.addSubview(referencia)
            info.addSubview(agregado)
            //            info.addSubview(urlReferenciaBtn)


            marcoCarrito.addSubview(foto)
            marcoCarrito.addSubview(info)
            marcoCarrito.addSubview(detallesBtn)
            contenedorCarritos.addSubview(marcoCarrito)
        }

        if let oldContainer = self.view.viewWithTag(100){
            oldContainer.removeFromSuperview()
        }
        contenedorCarritos.tag = 100
        view.addSubview(contenedorCarritos)
        view.sendSubview(toBack: contenedorCarritos)

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
    
    
    @objc func irDetalles(tapGestureRecognizer: goToDetailsGestureRecognizer){
        print(tapGestureRecognizer.idPropiedad!)
        idOfertaSeleccionada = tapGestureRecognizer.idPropiedad!
        performSegue(withIdentifier: "carritoToDetails", sender: nil)
    }
    
}
