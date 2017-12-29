//
//  ConfirmarUbicacionController.swift
//  Revimex
//
//  Created by Maquina 53 on 21/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import AudioToolbox;
import Material;
import Mapbox;
import MapboxGeocoder;

class MapaUbicacionInmueble: UIViewController,MGLMapViewDelegate,UIGestureRecognizerDelegate,FormValidate{
    var rows: [String : Any?]?
    
    @IBOutlet weak var mapContainer: UIView!
    
    @IBOutlet var txFlCodigoPostal:TextField!;
    @IBOutlet weak var txFlEstado: TextField!
    @IBOutlet weak var txFlMunicipio: TextField!
    @IBOutlet weak var txFlColonia: TextField!
    @IBOutlet weak var txFlCalle: TextField!
    @IBOutlet weak var txFlNumero: TextField!
    @IBOutlet weak var typeMap: Switch!
    
    
    
    private var mapbox:MGLMapView!;
    //public var queryDireccion:String!;
    private var empezo:Bool! = false;
    private var miPropiedadFlag:Bool! = false;
    private var miPropiedad:MGLPointAnnotation!;
    private let geocoder:Geocoder! = Geocoder.shared;
    private var posiblesPropiedades:[MGLPointAnnotation]!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rows = [:];
        navigationController?.navigationBar.isHidden = true;
        posiblesPropiedades = [];
        mapbox = MGLMapView(frame: mapContainer.frame, styleURL: URL(string: "mapbox://styles/mapbox/light-v9"));
        mapbox.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longPress(tap:)));
        longTap.delegate = self;
        
        for recognizer in mapbox.gestureRecognizers! where recognizer is UILongPressGestureRecognizer {
            longTap.require(toFail: recognizer);
        }
        
        mapbox.addGestureRecognizer(longTap);
        
        mapContainer.addSubview(mapbox);
        mapbox.delegate = self;
        iniTextFilds();
        
        let alert = UIAlertController(title: "Aviso!", message: "Indique donde se encuentra su propiedad, para esto realice una pulsación larga en el mapa", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
            let consejo = Utilities.showAlertSimple("Consejo: ", "Se recomienda colocar su Código Postal, esto le ayudara a encontrar su propiedad.");
            consejo.addAction(UIAlertAction(title:"Buscar mi Código Postal", style: .default, handler:{ action in
                UIApplication.shared.open(URL(string: "http://www.correosdemexico.gob.mx/ServiciosLinea/Paginas/ccpostales.aspx")!,options:[:],completionHandler: nil);
            }));
            self.present(consejo , animated: true, completion: nil);
        }));
        
        present(alert, animated: true, completion: nil);
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func longPress(tap: UILongPressGestureRecognizer){
        if(empezo == true && miPropiedadFlag == false){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate));
            let coordenadas: CLLocationCoordinate2D = mapbox.convert(tap.location(in: mapbox), toCoordinateFrom: mapbox);
            print("latitud: \(coordenadas.latitude) <--> longitud: \(coordenadas.longitude)");
            miPropiedad = MGLPointAnnotation();
            miPropiedad.coordinate = coordenadas;
            mapbox.addAnnotation(miPropiedad);
            self.getDatoByLatLng();
            empezo = false;
            miPropiedadFlag = true;
        }
    }
    
    func getDatoByLatLng(){
        Utilities.getDireccion(lat: miPropiedad.coordinate.latitude, lng: miPropiedad.coordinate.longitude){ datos in
            for component in datos{
                for tipo in (component?.types)!{
                    let tipo:AddressComponent.Tipo = tipo;
                    switch tipo {
                    case .street_number:
                        OperationQueue.main.addOperation {
                            self.txFlNumero.text = component?.longName;
                        }
                        break;
                    case .route:
                        OperationQueue.main.addOperation {
                            self.txFlCalle.text = component?.longName;
                        }
                        break;
                    case .sublocality_level_1:
                        OperationQueue.main.addOperation {
                            self.txFlColonia.text = component?.longName;
                        }
                        break;
                    case .administrative_area_level_2:
                        OperationQueue.main.addOperation {
                            self.txFlMunicipio.text = component?.longName;
                        }
                        break;
                    case .administrative_area_level_1:
                        OperationQueue.main.addOperation {
                            self.txFlEstado.text = component?.longName;
                        }
                        break;
                    default:
                        break;
                    }
                }
            }
            
        }
    }
    
    func generateOptions(query:String!)->ForwardGeocodeOptions!{
        //let ss = queryDireccion.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil) as String!;
        let option = ForwardGeocodeOptions(query: query);
        option.allowedISOCountryCodes = ["MX"];
        option.allowedScopes = [.address];
        return option;
    }
    
    func buscarPuntos(options: ForwardGeocodeOptions!){
        geocoder.geocode(options){ (placemarks, attribution, error) in
            guard let marcas = placemarks else{return;};
            for marca in  marcas{
                let tempAnnotation = MGLPointAnnotation();
                tempAnnotation.coordinate = marca.location.coordinate;
                self.posiblesPropiedades.append(tempAnnotation);
            }
            
            print(attribution);
            self.colocarPuntos();
        }
    }
    
    func colocarPuntos(){
        for annotation in posiblesPropiedades{
            /*self.miPropiedad = MGLPointAnnotation();
             self.miPropiedad.coordinate = coordenada;*/
            OperationQueue.main.addOperation {
                self.mapbox.addAnnotation(annotation);
                if(annotation == self.posiblesPropiedades.first){
                    self.mapbox.setCenter(annotation.coordinate,zoomLevel:18 ,animated: true);
                }
            }
        }
    }
    
    private func datosByZipCode(_ urlZip:String!,completado:@escaping (_ datos:[String:Any?])->Void){
        var datos:[String:Any?] = [:];
        if let url = URL(string: urlZip){
            var request = URLRequest(url: url);
            request.httpMethod = "GET";
            let session = URLSession.shared;
            session.dataTask(with: request){(data,response,error) in
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                        let datosD = json as NSDictionary;
                        datos["colonias"] = datosD["colonias"] as! NSArray;
                        datos["municipio"] = datosD["municipio"] as! String;
                        datos["estado"] = datosD["estado"] as! String;
                        completado(datos as [String:Any?]);
                    }catch{
                        OperationQueue.main.addOperation {
                            self.present(Utilities.showAlertSimple("ERROR", "Error en JSON_ZIP_CODE"), animated: true);
                        }
                    }
                }
                }.resume();
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let draggable = DraggableAnnotation(reuseIdentifier: "draggablePoint", size: 22,img: UIImage(named: "houseMarker.png")!);
        draggable.mapaUbiciacion = self;
        return draggable;
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        print(annotation.coordinate);
        return true;
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        empezo = true;
        return true;
    }
    
    func obtValores() -> [String : Any?]! {
        
        rows!["codigoPostal"] = self.txFlCodigoPostal.getActualText()!;
        rows!["estado"] = self.txFlEstado.getActualText()!;
        rows!["municipio"] = self.txFlMunicipio.getActualText()!;
        rows!["colonia"] = self.txFlColonia.getActualText()!;
        rows!["calle"] = self.txFlCalle.getActualText()!;
        rows!["numeroExterior"] = self.txFlNumero.getActualText()!;
        
        return rows;
    }
    
    func esValido() -> Bool {
        if(miPropiedad != nil){
            return true;
        }else{
            let alert = UIAlertController(title: "¡Aviso!", message: "Porfavor marque la ubicación de su propiedad en el mapa, para esto realice una pulsación larga", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true, completion: nil);
        }
        return false;
    }
    
    func iniTextFilds(){
        
        txFlCodigoPostal.placeholder = "Código Postal: ";
        txFlCodigoPostal.placeholderAnimation = .default;
        txFlCodigoPostal.keyboardType = .numbersAndPunctuation;
        txFlCodigoPostal.delegate = self;
        
        txFlEstado.placeholder = "Estado: ";
        txFlEstado.placeholderAnimation = .default;
        
        txFlMunicipio.placeholder = "Municipio: ";
        txFlMunicipio.placeholderAnimation = .default;
        
        txFlColonia.placeholder = "Colonia: ";
        txFlColonia.placeholderAnimation = .default;
        
        txFlCalle.placeholder = "Calle: ";
        txFlCalle.placeholderAnimation = .default;
        
        txFlNumero.placeholder = "Número: ";
        txFlNumero.placeholderAnimation = .default;
        
        typeMap.delegate = self;
        
        iniStyleTexTField();
        change_stateTextField();
    
    }
    
    private func change_stateTextField(){
        dis_enable(txFlEstado);
        dis_enable(txFlMunicipio);
        dis_enable(txFlColonia);
        dis_enable(txFlCalle);
        dis_enable(txFlNumero);
    }
    
    private func iniStyleTexTField(){
        styleTextField(txFlCodigoPostal);
        styleTextField(txFlEstado);
        styleTextField(txFlMunicipio);
        styleTextField(txFlColonia);
        styleTextField(txFlCalle);
        styleTextField(txFlNumero);
        
        typeMap.setSwitchState(state: .off);
        typeMap.backgroundColor = UIColor(white:1, alpha:0);
        typeMap.switchStyle = .dark;
        typeMap.switchSize = .medium;
        
    }
    
    private func styleTextField(_ textFiled:TextField!){
        textFiled.layer.backgroundColor = UIColor(white: 1, alpha: 0.5).cgColor;
        textFiled.layer.cornerRadius = 8;
        textFiled.layer.borderWidth = 0.5;
        textFiled.layer.borderColor = UIColor.gray.cgColor;
        textFiled.textAlignment = .center;
    }
    
    private func dis_enable(_ textField:TextField!){
        textField.isEnabled = !textField.isEnabled;
        textField.colorEnable();
    }
    
}



extension MapaUbicacionInmueble: TextFieldDelegate,SwitchDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(!(textField.text?.isEmpty)!){
            let urlZip = Utilities.ZIPCODES_URL+(textField.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))!;
            datosByZipCode(urlZip){ datosZip in
                print(datosZip);
                if((datosZip["estado"] as? String!) != ""){
                let direccion:String! = "estado "+(datosZip["estado"] as? String!)!+" municipio "+(datosZip["municipio"] as? String!)!
                Utilities.getDireccion(direccion: direccion){datos in
                    OperationQueue.main.addOperation {
                        self.mapbox.setCenter(CLLocationCoordinate2D(latitude: datos["lat"]! as Double!, longitude: datos["lng"]! as Double!), zoomLevel: 12, animated: false);
                        let camera = MGLMapCamera(lookingAtCenter: self.mapbox.centerCoordinate, fromDistance: 8000, pitch: 0, heading: 0);
                        self.mapbox.setCamera(camera, animated: true);
                        self.change_stateTextField();
                    }
                    
                }
                
                OperationQueue.main.addOperation {
                    self.txFlEstado.text = datosZip["estado"] as? String;
                    self.txFlMunicipio.text = datosZip["municipio"] as? String;
                }
                }else{
                    OperationQueue.main.addOperation {
                        self.present(Utilities.showAlertSimple("Error!", "El código postal no muestra resultados"), animated: true, completion: nil);
                    }
                }
            };
            
        }
    }
    
    func switchDidChangeState(control: Switch, state: SwitchState) {
        switch state {
        case .on:
            self.mapbox.styleURL = MGLStyle.satelliteStreetsStyleURL(withVersion: 9);
        default:
            self.mapbox.styleURL = MGLStyle.lightStyleURL();
        }
    }
}

class DraggableAnnotation: MGLAnnotationView {
    var image:UIImageView!;
    var mapaUbiciacion:MapaUbicacionInmueble!;
    
    init(reuseIdentifier:String!, size:CGFloat,img:UIImage!){
        super.init(reuseIdentifier: reuseIdentifier);
        isDraggable = true;
        scalesWithViewingDistance = false;
        image = UIImageView(image: img);
        image.frame.size = CGSize(width: size*2.2, height: size*2.2);
        addSubview(image);
        frame = image.frame;
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)
        switch dragState {
        case .starting:
            startDragging()
        case .dragging:
            break;
        case .ending, .canceling:
            mapaUbiciacion.getDatoByLatLng();
            endDragging()
        case .none:
            return
        }
    }
    
    func startDragging() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 0.8
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.8, y: 1.8)
        }, completion: nil)
    }
    
    func endDragging() {
        transform = CGAffineTransform.identity.scaledBy(x: 1.8, y: 1.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 1
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }, completion: nil)
    }
    
}
