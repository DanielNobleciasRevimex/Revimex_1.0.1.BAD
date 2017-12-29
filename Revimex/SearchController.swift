//
//  SearchController.swift
//  Revimex
//
//  Created by Seifer on 09/11/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Mapbox
import GooglePlaces


class SearchController: UIViewController, MGLMapViewDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate {
    
    
    var mapView: MGLMapView = MGLMapView(frame: CGRect(x: 0.0,y: 0.0,width: 0,height: 0), styleURL: URL(string: "mapbox://styles/mapbox/light-v9"))
    
    
    var formatedAddress = "México"
    var searchField = UITextField()
    var filtrosContainer = UIView()
    let step: Float = 1
    let stepPrecio: Float = 50000
    var terrenoLabel = UILabel()
    var construccionLabel = UILabel()
    var recamarasLabel = UILabel()
    var banosLabel = UILabel()
    var precioMaxLabel = UILabel()
    var terreno = 0
    var construccion = 0
    var recamaras = 0
    var banos = 0
    var precioMax = 1000000000
    var precioMaxBase = 1000000000
    var precioMin = 0
    
    
    var northeastLat: Double = 32.7186534
    var northeastLng: Double = -86.5887
    var southwestLat: Double = 14.3895
    var southwestLng: Double = -118.6523001
    var locationLat: Double = 23.634501
    var locationLng: Double = -102.552784
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCustomBackgroundAndNavbar()
        
        terrenoLabel.text = "0"
        construccionLabel.text = "0"
        recamarasLabel.text = "0"
        banosLabel.text = "0"
        precioMaxLabel.text = "0"
        
        self.hideKeyboard()
        inicio()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setCustomBackgroundAndNavbar()
    }
    
    
    //*****************************funcion para mostrar la vista inicial*******************************
    func inicio() {
        
        let screenSize = UIScreen.main.bounds
        
        let url = URL(string: "mapbox://styles/mapbox/light-v9")
        
        print(searchField.bounds.height)
        
        mapView = MGLMapView(frame: CGRect(x: 0.0,y: (navigationController?.navigationBar.bounds.height)! + 20,width: screenSize.width,height: screenSize.height - ((navigationController?.navigationBar.bounds.height)! + 20)), styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 23.634501, longitude: -102.552784), zoomLevel: 4, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchFieldTapped(tapGestureRecognizer:)))
        searchField.frame = CGRect(x: (screenSize.width * (0.06))+(screenSize.height * (0.06)),y: screenSize.height/6,width: (screenSize.width * (0.88))-(screenSize.height * (0.06)),height: screenSize.height * (0.06))
        searchField.placeholder = "Donde quieres tu casa?"
        searchField.textAlignment = NSTextAlignment.center
        searchField.backgroundColor = UIColor.white
        searchField.layer.masksToBounds = false
        searchField.layer.shadowRadius = 2.0
        searchField.layer.shadowColor = UIColor.black.cgColor
        searchField.layer.shadowOffset = CGSize(width: 0.7,height: 0.7)
        searchField.layer.shadowOpacity = 0.5
        searchField.delegate = self
        searchField.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(searchField)
        
        
        let tapGestureRecognizerFilter = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped(tapGestureRecognizer:)))
        let filterButton = UIButton()
        let image = UIImage(named: "filterButton.png") as UIImage?
        filterButton.setBackgroundImage(image, for: .normal)
        filterButton.frame = CGRect(x: screenSize.width * (0.06),y: screenSize.height/6,width: screenSize.height * (0.06),height: screenSize.height * (0.06))
        filterButton.layer.masksToBounds = false
        filterButton.layer.shadowRadius = 2.0
        filterButton.layer.shadowColor = UIColor.black.cgColor
        filterButton.layer.shadowOffset = CGSize(width: 0.7,height: 0.7)
        filterButton.layer.shadowOpacity = 0.5
        filterButton.addGestureRecognizer(tapGestureRecognizerFilter)
        view.addSubview(filterButton)
        
        filtrosContainer.frame = CGRect(x: filterButton.frame.origin.x ,y: (searchField.frame.origin.y + searchField.bounds.height),width: searchField.bounds.width + filterButton.bounds.width,height: view.bounds.height * (0.6))
        filtrosContainer.backgroundColor = UIColor.white
        filtrosContainer.layer.masksToBounds = false
        filtrosContainer.layer.shadowRadius = 2.0
        filtrosContainer.layer.shadowColor = UIColor.black.cgColor
        filtrosContainer.layer.shadowOffset = CGSize(width: 0.7,height: 0.7)
        filtrosContainer.layer.shadowOpacity = 0.5
        filtrosContainer.isHidden = true
        
        let filtrosContainerWidth = filtrosContainer.bounds.width
        let filtrosContainerHeight = filtrosContainer.bounds.height
        let altura = filtrosContainerHeight * (0.13)
        
        let titulo = UILabel()
        titulo.text = "Filtros"
        titulo.textAlignment = NSTextAlignment.center
        titulo.frame = CGRect(x: filtrosContainerWidth * (0.3),y: 0,width: filtrosContainerWidth * (0.3),height: altura/2)
        
        
        let terreno = crearSlider(posicion: 1,titulo: "Metros de Terreno",minValue: 0,maxValue: 4,label: terrenoLabel)
        terreno.addTarget(self, action: #selector(sliderValueDidChangeTerreno(_:)), for: .valueChanged)
        
        let construccion = crearSlider(posicion: 2,titulo: "Metros de Construccion",minValue: 0,maxValue: 4,label: construccionLabel)
        construccion.addTarget(self, action: #selector(sliderValueDidChangeConstruccion(_:)), for: .valueChanged)
        
        let recamaras = crearSlider(posicion: 3,titulo: "Recamaras",minValue: 0,maxValue: 4,label: recamarasLabel)
        recamaras.addTarget(self, action: #selector(sliderValueDidChangeRecamaras(_:)), for: .valueChanged)
        
        let banos = crearSlider(posicion: 4,titulo: "Baños",minValue: 0,maxValue: 3,label: banosLabel)
        banos.addTarget(self, action: #selector(sliderValueDidChangeBanos(_:)), for: .valueChanged)
        
        let precio = crearSlider(posicion: 5,titulo: "Precio Maximo",minValue: 0,maxValue: 10000000,label: precioMaxLabel)
        precio.addTarget(self, action: #selector(sliderValueDidChangePrecio(_:)), for: .valueChanged)
        
        
        let tapGestureRecognizerSearch = UITapGestureRecognizer(target: self, action: #selector(searchButtonTapped(tapGestureRecognizer:)))
        let searchButton = UIButton()
        let imageSearch = UIImage(named: "buscarFiltros.png") as UIImage?
        searchButton.setBackgroundImage(imageSearch, for: .normal)
        searchButton.frame = CGRect(x: filtrosContainerWidth - altura,y: filtrosContainerHeight - altura,width: altura,height: altura)
        searchButton.addGestureRecognizer(tapGestureRecognizerSearch)
        
        
        filtrosContainer.addSubview(titulo)
        filtrosContainer.addSubview(terreno)
        filtrosContainer.addSubview(construccion)
        filtrosContainer.addSubview(recamaras)
        filtrosContainer.addSubview(banos)
        filtrosContainer.addSubview(precio)
        filtrosContainer.addSubview(searchButton)
        view.addSubview(filtrosContainer)
    }
    
    
    //***********************funciones al hacer tap en un elemento*******************************
    //muestra la vista de autocomplete al hacer top en el campo de busqueda
    @objc func searchFieldTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //filtro para autocomplete
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.country = "MX"
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
        
    }
    //"toggle" para la vista de los filtros al presionar el boton
    @objc func filterButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.filtrosContainer.isHidden = !self.filtrosContainer.isHidden
    }
    //"toggle" para la vista de los filtros al presionar el boton
    @objc func searchButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        beforeRequest()
    }
    
    
    
    //***********************funciones para los sliders de filtros******************************
    //crea un slider
    func crearSlider(posicion: Float,titulo: String,minValue: Float,maxValue: Float,label: UILabel) -> UISlider{
        
        let filtrosContainerWidth = filtrosContainer.bounds.width
        let filtrosContainerHeight = filtrosContainer.bounds.height
        let altura = filtrosContainerHeight * (0.14)
        
        let tituloTerreno = UILabel()
        tituloTerreno.text = titulo
        tituloTerreno.frame = CGRect(x: 0,y: altura * CGFloat(posicion),width: filtrosContainerWidth,height: altura/2)
        
        filtrosContainer.addSubview(tituloTerreno)
        
        label.frame = CGRect(x: filtrosContainerWidth*(0.75),y: altura * CGFloat(posicion),width: filtrosContainerWidth*(0.25),height: altura)
        label.textAlignment = NSTextAlignment.center
        
        filtrosContainer.addSubview(label)
        
        let slider = UISlider()
        slider.frame = CGRect(x: 0,y: (altura * CGFloat(posicion))+(altura/2),width: filtrosContainerWidth*(0.75),height: altura/2)
        slider.layer.borderColor = UIColor.black.cgColor
        slider.layer.borderWidth = 0.2
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.isContinuous = true
        slider.tintColor = UIColor.green
        
        return slider
    }
    //maneja el cambio de valores en el filtro de terreno
    @objc func sliderValueDidChangeTerreno(_ sender:UISlider!){
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        
        switch Int(roundedStepValue) {
        case 0:
            terrenoLabel.text = "0"
        case 1:
            terrenoLabel.text = "1-50"
        case 2:
            terrenoLabel.text = "51-100"
        case 3:
            terrenoLabel.text = "101-200"
        case 4:
            terrenoLabel.text = "200+"
        default:
            terrenoLabel.text = "0"
        }
        
        terreno = Int(roundedStepValue)
        
    }
    //maneja el cambio de valores en el filtro de construccion
    @objc func sliderValueDidChangeConstruccion(_ sender:UISlider!){
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        
        switch Int(roundedStepValue) {
        case 0:
            construccionLabel.text = "0"
        case 1:
            construccionLabel.text = "1-50"
        case 2:
            construccionLabel.text = "51-100"
        case 3:
            construccionLabel.text = "101-200"
        case 4:
            construccionLabel.text = "200+"
        default:
            construccionLabel.text = "0"
        }
        
        construccion = Int(roundedStepValue)
        
    }
    //maneja el cambio de valores en el filtro de recamaras
    @objc func sliderValueDidChangeRecamaras(_ sender:UISlider!){
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        recamarasLabel.text = String(Int(roundedStepValue))
        recamaras = Int(roundedStepValue)
        
    }
    //maneja el cambio de valores en el filtro de baños
    @objc func sliderValueDidChangeBanos(_ sender:UISlider!){
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        banosLabel.text = String(Int(roundedStepValue))
        banos = Int(roundedStepValue)
        
    }
    //maneja el cambio de valores en el filtro de precio
    @objc func sliderValueDidChangePrecio(_ sender:UISlider!){
        let roundedStepValue = round(sender.value / stepPrecio) * stepPrecio
        sender.value = roundedStepValue
        if Int(roundedStepValue) == 0 {
            precioMax = precioMaxBase
            precioMaxLabel.text = String(Int(roundedStepValue))
        }
        else if Int(roundedStepValue) == 10000000{
            precioMax = precioMaxBase
            precioMaxLabel.text = "+10000000"
        }
        else{
            precioMax = Int(roundedStepValue)
            precioMaxLabel.text = String(Int(roundedStepValue))
        }
    }
    
    
    //*************************funciones del GMSAutocompleteViewControllerDelegate****************************
    //Maneja la direccion del autocomplete seleccionada por el ususario
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        //asigna la direccion seleccionada en el autocomplete
        print("Place: \(place)")
        formatedAddress = place.formattedAddress!
        beforeRequest()
        dismiss(animated: true, completion: nil)
        
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    //*********************request del geojson a google con la direccion seleccionada**************************
    func beforeRequest(){
        if self.mapView.annotations != nil {
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations!)
        }
        if formatedAddress != "" {
            getLocationDetails()
        }
        self.filtrosContainer.isHidden = true
    }
    func getLocationDetails(){
        
        searchField.text = formatedAddress
        
        let encodedAddress = formatedAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var urlRequestDetails = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q&components=country:MX&address="+encodedAddress
        
        
        print(urlRequestDetails)
        
        guard let url = URL(string: urlRequestDetails) else { return }
        
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
                    
                    print(json)
                    if let selectedAdress = json["results"] as? NSArray,
                        let adress = selectedAdress[0] as? NSDictionary,
                        let adressGeometry = adress["geometry"] as? NSDictionary,
                        let location = adressGeometry["location"] as? NSDictionary,
                        let bounds = adressGeometry ["viewport"] as? NSDictionary,
                        let northeast = bounds["northeast"] as? NSDictionary,
                        let southwest = bounds["southwest"] as? NSDictionary {
                    
                        self.northeastLat = northeast["lat"] as! Double
                        self.northeastLng = northeast["lng"] as! Double
                        self.southwestLat = southwest["lat"] as! Double
                        self.southwestLng = southwest["lng"] as! Double
                        self.locationLat = location["lat"] as! Double
                        self.locationLng = location["lng"] as! Double
                    }
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                OperationQueue.main.addOperation({
                    self.getPropertiesNearTo(lat: self.locationLat,lng: self.locationLng,swlat: self.southwestLat,swlng: self.southwestLng,nelat: self.northeastLat,nelng: self.northeastLng)
                    
                })
                
            }
        }.resume()
    }
    
    
    
    //**********request a las propiedades dentro de los limites del lugar elegido de las sugerencias*************
    func getPropertiesNearTo(lat: Double,lng: Double,swlat: Double,swlng: Double,nelat: Double,nelng: Double){
        
        /*
        let bounds = MGLCoordinateBounds(
            sw: CLLocationCoordinate2D(latitude: 43.7115, longitude: 10.3725),
            ne: CLLocationCoordinate2D(latitude: 43.7318, longitude: 10.4222))
        mapView.setVisibleCoordinateBounds(bounds, animated: false)
        */
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lng ), zoomLevel: 15, animated: false)
        
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 5000, pitch: 12, heading: 180)
        
        mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        let urlRequestFiltros = "http://18.221.106.92/api/public/propiedades/filtros"

        let parameters: [String:Any] = [
            "lat" : lat,
            "lng" : lng,
            "swlat" : swlat,
            "swlng" : swlng,
            "nelat" : nelat,
            "nelng" : nelng,
            "inv" : 0,
            "filters" : [
                "terreno" : terreno,
                "const" : construccion,
                "rec" : recamaras,
                "banos" : banos,
                "order" : 0,
                "escritura" : 0,
                "invasion" : 0
            ],
            "precio" : [
                "minPrecio" : precioMin,
                "maxPrecio" : precioMax
            ],
            "todos" : 0
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
                    
                    print(json)
                    if (json["error"] as! String) != "No hay resultados" {
                        for element in json["features"] as! NSArray{

                            let propiedad = element as! NSDictionary
                            let gemoetry = propiedad["geometry"] as! NSDictionary
                            let coordinates = gemoetry["coordinates"] as! NSArray
                            
                            if !(coordinates[0] is NSNull) && !(coordinates[1] is NSNull){
                                
                                let lat = Double(coordinates[1] as! String)!
                                let lng = Double(coordinates[0] as! String)!
                                
                                let properties = propiedad["properties"] as! NSDictionary
                                
                                var direccion = ""
                                var precio = ""
                                var idOferta = 0
                                
                                if properties["calle"] != nil{
                                    direccion = direccion + (properties["calle"] as! String)
                                }
                                if properties["estado"] != nil{
                                    direccion = direccion + (properties["estado"] as! String)
                                }
                                if properties["precio"] != nil{
                                    precio = "Precio: $" + (properties["precio"] as! String)
                                }
                                if properties["ai"] != nil{
                                    idOferta = (properties["ai"] as! Int)
                                }
                                
                                self.agregarMarcadorPropiedad(latitud:lat, longitud: lng,direccion: direccion,precio: precio,idOferta: idOferta)
                            }
                            
                        }
                    }
                    else{
                        let alert = UIAlertController(title: "Aviso", message: "No se encontraron propiedades", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }

                } catch {
                    print("El error es: ")
                    print(error)
                }

                OperationQueue.main.addOperation({
                    
                })

            }
        }.resume()
        
    }
    
    
    //***********************************funciones del mapa**************************************
    //obtiene la ubicacion actual del usuario y centra la vista ahi
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                let userLoc = mapView.userLocation!
                
                let userLat = userLoc.coordinate.latitude as Double
                let userLon = userLoc.coordinate.longitude as Double
                
                mapView.setCenter(CLLocationCoordinate2D(latitude: userLat, longitude: userLon), zoomLevel: 8, animated: false)
                let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 3000, pitch: 15, heading: 180)
                mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    //agrega un marcador en la propiedad
    func agregarMarcadorPropiedad(latitud: Double, longitud: Double,direccion: String,precio: String,idOferta: Int){
        
        let propiedad = MGLPointAnnotation()
        propiedad.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitud), longitude: CLLocationDegrees(longitud))
        propiedad.title = direccion
        propiedad.subtitle = String(idOferta)
        
        mapView.addAnnotation(propiedad)
    }
    //permite anotaciones en el mapa
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    //asigna una imagen personalizada al marcador
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "propiedad")
        
        if annotationImage == nil {
            
            var image = UIImage(named: "houseMarker.png")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "propiedad")
        }
        return annotationImage
        
    }
    //agrega un boton al pop up de la anotacion
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        
        let image = UIImage(named: "info.png") as UIImage?
        let detailsButton = UIButton()
        
        detailsButton.setImage(image, for: .normal)
        detailsButton.frame = CGRect(x: 0.0,y: 0.0,width: 30,height: 30)
        
        return detailsButton
    }
    //realiza una accion al presionar el boton de la anotacion
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        print("ocultar id de la informacion")
        idOfertaSeleccionada = annotation.subtitle as! String
        performSegue(withIdentifier: "searchToDetails", sender: nil)
    }
    

}
