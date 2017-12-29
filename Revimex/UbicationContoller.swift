//
//  UbicationContoller.swift
//  Revimex
//
//  Created by Seifer on 11/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Mapbox

class UbicationContoller: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var sevicesConatiner: UIView!
    
    //variables para mapbox
    var mapView: MGLMapView = MGLMapView(frame: CGRect(x: 0.0,y: 0.0,width: 0,height: 0), styleURL: URL(string: "mapbox://styles/mapbox/light-v9"))
    var nombreImagenMarker: String = ""
    var degrees: Double = 180
    var marcador = "houseMarker"

    override func viewDidLoad() {
        super.viewDidLoad()
        sevicesConatiner.backgroundColor = UIColor(white: 1, alpha: 0.8)
        view?.backgroundColor = UIColor(white: 1, alpha: 0)
        
        crearMapa()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func crearMapa(){
        //inicia asignacion de valores al mapa
        let screenSize = UIScreen.main.bounds
        
        let url = URL(string: "mapbox://styles/mapbox/light-v9")
        
        mapView = MGLMapView(frame: CGRect(x: 0,y: 0,width: screenSize.width,height: screenSize.height), styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(propiedad.lat)!, longitude: Double(propiedad.lon)!), zoomLevel: 10, animated: false)
        mapView.delegate = self
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        
        //agrega el marcador principal
        addPrincipalMarker()
    }
    
    //funciones para mostrar servicios
    @IBAction func mostrarSuperMercados(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "centroComercial"
        buscarServicios(servicio: "shopping_mall")
        cameraMovement()
    }
    
    @IBAction func mostrarRestaurantes(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "restaurantes"
        buscarServicios(servicio: "restaurant")
        cameraMovement()
    }
    
    @IBAction func mostrarEscuelas(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "escuelas"
        buscarServicios(servicio: "school")
        cameraMovement()
    }
    
    @IBAction func mostrarTiendas(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "Tiendas"
        buscarServicios(servicio: "convenience_store")
        cameraMovement()
    }
    
    @IBAction func mostrarHospitales(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        nombreImagenMarker = "hospitales"
        buscarServicios(servicio: "hospital")
        cameraMovement()
    }
    
    @IBAction func mostrarParques(_ sender: Any) {
        if self.mapView.annotations != nil{
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
            addPrincipalMarker()
        }
        
        nombreImagenMarker = "parques"
        buscarServicios(servicio: "park")
        cameraMovement()
    }
    
    
    //agrega el marcador principal al mapa
    func addPrincipalMarker(){
        
        marcador = "houseMarker"
        let marcadorPrincipal = MGLPointAnnotation()
        marcadorPrincipal.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(propiedad.lat)!, longitude: CLLocationDegrees(propiedad.lon)!)
        marcadorPrincipal.title = propiedad.estado
        marcadorPrincipal.subtitle = propiedad.precio
        
        mapView.addAnnotation(marcadorPrincipal)
    }
    
    //movimiento de camara del mapa
    func cameraMovement(){
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(propiedad.lat)!, longitude: Double(propiedad.lon)!), animated: false)
        
        degrees += 180
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 3000, pitch: 60, heading: degrees)
        
        mapView.setCamera(camera, withDuration: 6, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    //request al api de google para localizar servicios
    func buscarServicios(servicio: String){
        
        marcador = servicio
        
        let apiGoogle = "AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q"
        
        let inicioUrl =  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + propiedad.lat + "," + propiedad.lon
        
        let urlRequestGoogle = inicioUrl+"&radius=2000&types=" + servicio + "&key=" + apiGoogle
        
        print("URL: " + urlRequestGoogle)
        
        guard let url = URL(string: urlRequestGoogle) else { return }
        
        let session  = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("response:")
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    let results = json["results"] as! NSObject
                    
                    for result in results as! NSArray {
                        let result = result as! NSDictionary
                        let geometry = result["geometry"] as! NSDictionary
                        let location = geometry["location"] as! NSDictionary
                        
                        print(result)
                        var nombre = ""
                        var direccion = ""
                        if !(result["name"] is NSNull){
                            nombre = result["name"] as! String
                        }
                        if !(result["vicinity"] is NSNull){
                            direccion = result["vicinity"] as! String
                        }
                        
                        self.agregarMarcadorServicio(latitud: location["lat"] as! Double, longitud: location["lng"] as! Double,nombre: nombre ,direccion: direccion)
                    }
                    
                    
                }catch {
                    print(error)
                }
                
            }
            }.resume()
        
        
    }
    
    //agrega los marcadores de servicios encontrados
    func agregarMarcadorServicio(latitud: Double, longitud: Double,nombre: String,direccion: String){
        
        let servicio = MGLPointAnnotation()
        servicio.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitud), longitude: CLLocationDegrees(longitud))
        servicio.title = nombre
        servicio.subtitle = direccion
        
        mapView.addAnnotation(servicio)
    }
    
    
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 2000, pitch: 50, heading: 180)
        
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "")
        
        if marcador == "houseMarker" {
            annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "marcadorPrincipal")
            
            if annotationImage == nil {
                
                var image = UIImage(named: marcador+".png")!
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
                
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "marcadorPrincipal")
            }
            
        }
        else {
            print(marcador)
            annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: marcador)
            
            var image = UIImage(named: marcador+".png")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: marcador)
            
        }
        
        return annotationImage
        
    }

}
