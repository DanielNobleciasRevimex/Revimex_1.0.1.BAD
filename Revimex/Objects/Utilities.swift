//
//  Utilities.swift
//  Revimex
//
//  Created by Seifer on 13/11/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import Material


/*USERDEAFULTS
    usuario -> almacena el email del usuario
    contraseña -> almacena la contraseña de usuario
    userId -> almacena el id de usuario
*/

//genera un borde inferior en un campo de texto


extension UITextField {
    func borderBottom(color: UIColor,borderSize: CGFloat){
        let border = CALayer()
        let width = borderSize
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

//define el fondo de la vista y le da transparencia a la navbar o el fondo blanco y navabar solida
extension UIViewController{
    
    func setCustomBackgroundAndNavbar(){
        
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"fondo.png")!)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let navigationBarSize = self.navigationController?.navigationBar.bounds
        let navigationBarSizeWidth = (navigationBarSize?.width)!
        let navigationBarSizeHeigth = (navigationBarSize?.height)!
        
        let logo = UIImage(named: "revimex.png")
        let contenedorLogo = UIImageView(image:logo)
        contenedorLogo.frame = CGRect(x: navigationBarSizeWidth*0.3,y: 0.0,width: navigationBarSizeWidth*0.4,height: navigationBarSizeHeigth)
        
        self.navigationController?.navigationBar.addSubview(contenedorLogo)
    }
    
    
    func setLoginNavigationBar(){
        
        if let vistas = navigationController?.navigationBar.subviews{
            for vista in vistas {
                print(vista)
                print(type(of: vista))
                if type(of: vista) == type(of: UIImageView()){
                    vista.removeFromSuperview()
                }
            }
        }
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let screenSize = UIScreen.main.bounds
        
        let logo = UIImage(named: "revimex.png")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: screenSize.width * 0.125,y: screenSize.height * 0.15,width: screenSize.width * 0.75,height: screenSize.height * 0.125)
        
        view.addSubview(imageView)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"fondo.png")!)

    }
}

//oculta el teclado al dar tap fuera del campo de texto
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class AddressComponent{
    
    enum Tipo: String{
        case
        street_number = "street_number",
        political = "political",
        sublocality = "sublocality",
        neighborhood = "neighborhood",
        route = "route",
        sublocality_level_1 = "sublocality_level_1",
        locality = "locality",
        administrative_area_level_1 = "administrative_area_level_1",
        administrative_area_level_2 = "administrative_area_level_2",
        administrative_area_level_3 = "administrative_area_level_3",
        administrative_area_level_4 = "administrative_area_level_4",
        administrative_area_level_5 = "administrative_area_level_5",
        country = "country",
        postal_code = "postal_code",
        colloquial_area = "coloquial_area"
    };
    
    public var longName:String!;
    public var shortName:String!;
    public var types:[Tipo]!;
    
    init(longName:String!,shortName:String!,types:[Tipo]!) {
        self.longName = longName;
        self.shortName = shortName;
        self.types = types;
    }
}

protocol InfoCells{
    var idTipo:String!{get set};
    var controller:UITableViewCell!{get};
    func setController(controller: UITableViewCell!);
}


extension TextField{
    
    // Cambia el color del TextField si esta habilitado o deshabilitado
    func colorEnable(){
        if(isEnabled == false){
            placeholderNormalColor = Color.lightGray;
            placeholderActiveColor = Color.lightGray;
            dividerActiveColor = Color.lightGray;
            dividerNormalColor = Color.lightGray;
            textColor = Color.lightGray;
        }else{
            placeholderNormalColor = Color.black;
            placeholderActiveColor = Color.blue.base;
            dividerActiveColor = Color.blue.base;
            dividerNormalColor = Color.blue.base;
            textColor = Color.black;
        }
    }
    
    func colorHighlight(){
        placeholderNormalColor = Color.black;
        placeholderActiveColor = Color.black;
        dividerActiveColor = Color.black;
        dividerNormalColor = Color.black;
        textColor = Color.lightGray;
    }
    
    // Devuelve la cadena actual que contiene el TextField
    func getActualText() -> String! {
        return self.text
    }
}

//para generar bordes
extension UIView {
    
    // Example use: myView.addBorder(toSide: .Bottom, withColor: UIColor.red.cgColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

//permite generar un color personalizado a partir de un codigo hexadecimal
extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}


var azul = UIColor(hexString: "#48B1F3ff")
var azulClaro = UIColor(hexString: "#F0F5F6ff")
var gris = UIColor(hexString: "#3B3B3Bff")

//variable global, obtiene un valor en TableViewCell.swift dependiendo de la propiedad que se selecciono(StockConroller,SearchController,InfoController,UbicationController,FavoritosController,TableViewCell)
var idOfertaSeleccionada = ""

//botones de la barra de navegacion (StockController)
var incioSesionBtn = UIButton()
var imagenCuentaBtn = UIButton()

//indica el tipo de estilo para la barra de navegacion(LoginController,StockCotroller,FavoritosController,InfoUserController)
var navBarStyleCase = 0

//bandera para refresacar la vista de favoritos (InfoController,FavoritosController)
var cambioFavoritos = false

//bandera para refresacar la vista de carrito (InfoController,CarritoController)
var cambioCarritos = false

//indicador de linea de negocio (StockController,LineasInfoController)
var lineaSeleccionada = 0

//variable para contener los datos entregados por el json de detalles(InfoController,UbicationController)
var propiedad: Details = Details(Id: "",calle: "",colonia: "",construccion: "",cp: "",estacionamiento: "",estado: "",habitaciones: "",idp: "",lat: "0",lon: "0",municipio: "",niveles: "",origen_propiedad: "",patios: "",precio: "",terreno: "",tipo: "",descripcion: "",pros: "",wcs: "",fotos: [])

//variable para obtener la imagen de fondo de la descripcion
var descriptionImageBackground = UIImage()

var favs:FavoritesController!;

class Utilities: NSObject {

    public static let GEOCODING_URL:String! = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q&components=country:MX&address=";
    public static let ZIPCODES_URL:String! = "https://api-codigos-postales.herokuapp.com/v2/codigo_postal/";
    
    public static let ESTADOS:String! = "http://18.221.106.92/api/public/propiedades/comboEstado";
    
    public static let MUNICIPIOS:String! = "http://18.221.106.92/api/public/propiedades/comboMunicipio";
    
    public static func formatURLLatLng(lat:Double!,lng:Double!)->String!{
        let latlng = "latlng=\(String(format: "%.13f", lat)),\(String(format: "%.13f", lng))";
        let latlngCode:String! = latlng.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!;
        let urlGeocoding = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q&"+latlngCode;
        return urlGeocoding;
    }
    
    //recibe una url en tipo string, la procesa y la regresa como imagen
    public static func traerImagen(urlImagen: String) -> UIImage{
        var imagen = UIImage(named: "imagenNoEncontrada.png")
        
        let imgURL = NSURL(string: urlImagen)
        
        if let data = imgURL as URL?{
            if let data = NSData(contentsOf: data){
                imagen = UIImage(data: data as Data)
            }
        }
        
        return imagen!
    }
    
    //recibe una cadena de texto y regresa true si es un correo valido
    public static func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //recibe un string y comprueba que se un codigo postal valido
    public static func isValidZip(_ zipcode: String)-> Bool{
        let zipRegEx = "0[1-9][0-9]{3}|[1-4][0-9]{4}|5[0-9][0-9]{3}";
        let zipTest = NSPredicate(format:"SELF MATCHES %@",zipRegEx);
        return zipTest.evaluate(with: zipcode);
    }
    
    //crea el fondo del UIActivityIndicatorView
    public static func activityIndicatorBackground(activityIndicator: UIActivityIndicatorView)->UIView{
        
        let background = UIView()
        
        background.frame.size = CGSize(width: 80, height: 80)
        background.layer.backgroundColor = UIColor.black.withAlphaComponent(0.8).cgColor
        background.layer.cornerRadius = 10
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = background.center
        background.addSubview(activityIndicator)
        
        return background
    }
    
    //Genera sombras en botones
    public static func genearSombras(_ button: UIButton!)->UIButton!{
        button.layer.shadowRadius = 0.5;
        button.layer.masksToBounds = false;
        button.backgroundColor = UIColor.white;
        button.layer.shadowColor = UIColor.black.cgColor;
        button.layer.shadowOffset = CGSize(width: 0.8, height: 0.8);
        button.layer.shadowOpacity = 0.8;
        return button;
    }
    
    //Genera un alert y lo devuelve
    public static func showAlertSimple(_ titulo:String!,_ mensaje:String!)->UIAlertController{
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert;
    }
    
    //Genera una imagen con blur a partir de un UIImage
    public static func blur(img:UIImage!,blurVal:Double)->UIImage{
        let context = CIContext(options: nil);
        let cFilter = CIFilter(name: "CIGaussianBlur");
        let nwImg = CIImage(image: img);
        cFilter?.setValue(nwImg, forKey: kCIInputImageKey);
        cFilter?.setValue(blurVal, forKey: kCIInputRadiusKey);
        
        let output:CIImage! = cFilter?.outputImage;
        let ciImg = context.createCGImage(output, from: output.extent);
        let fnlImg = UIImage(cgImage: ciImg!);
        return fnlImg;
    }
    
    //Reescala una imagen
    public static func escalar(img:UIImage!,nwAncho:CGSize,sizeOriginal: CGRect)->UIImage{
        let widthFactor = img.size.width / nwAncho.width ;
        let heightFactor = img.size.height / nwAncho.height;
        
        var resizeFactor = widthFactor*0.04;
        if img.size.height > img.size.width {
            resizeFactor = heightFactor*0.04;
        }
        
        let newSize = CGSize(width: img.size.width/resizeFactor, height: img.size.height/resizeFactor);
        
        UIGraphicsBeginImageContext(newSize);
        
        img.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let imgOut = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //let fImg = CIImage(image: imgOut!);
        //return recortarImg(img: fImg, vector: sizeOriginal);
        return imgOut!;
    }
    
    //Recorta una Imgen
    public static func recortarImg(img:CIImage!,vector:CGRect!)->UIImage!{
        let imgRef = img.cropped(to: vector);
        return UIImage(ciImage: imgRef);
    }
    
    
    public static func getDireccion(lat:Double!,lng:Double!,completado:@escaping(_ datos:[AddressComponent?])->Void){
        var datos:[AddressComponent?] = [];
        let urlLatLng:String! = formatURLLatLng(lat: lat, lng: lng);
        guard let url = URL(string: urlLatLng) else{return;};
        var request = URLRequest(url:url);
        request.httpMethod = "POST";
        let session = URLSession.shared;
        session.dataTask(with: request){(data,response,error) in
            if let data = data{
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                    let result = json["results"] as? NSArray;
                    let element = (result?.firstObject) as? NSDictionary;
                    let addressComponents = element!["address_components"] as? NSArray;
                    
                    for component in addressComponents!{
                        let component = (component as! NSDictionary);
                        let tiposString = component["types"] as! NSArray;
                        let longName = component["long_name"] as! String!;
                        let shortName = component["short_name"] as! String!;
                        var tipos:[AddressComponent.Tipo] = [];
                        for tipo in tiposString{
                            tipos.append(AddressComponent.Tipo(rawValue: tipo as! String)!);
                        }
                        datos.append(AddressComponent(longName: longName, shortName: shortName, types:tipos));
                    }
                    
                    completado(datos);
                    
                }catch{
                    print(error);
                }
            }
            }.resume();
        
    }
    
    //Devuelve una funcion asincrona,donde se encuentra una latitud y una longitud, recive una Direccion
    public static func getDireccion(direccion:String!,completado:@escaping(_ datos:[String:Double?])->Void){
        var datos:[String:Double?] = [:];
        let encodeDireccion = direccion.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!;
        let urlRequest = GEOCODING_URL+(encodeDireccion);
        guard let url = URL(string: urlRequest) else{return;};
        var request = URLRequest(url: url);
        request.httpMethod = "POST";
        let session = URLSession.shared;
        session.dataTask(with: request){ (data,response,error) in
            
            if let data = data{
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any?];
                    let result = json["results"] as? NSArray;
                    let element = (result?.firstObject as? NSDictionary);
                    let geometry = element!["geometry"] as? NSDictionary;
                    
                    datos["lat"] = ((geometry!["location"] as? NSDictionary)!["lat"] as! Double!);
                    datos["lng"] = ((geometry!["location"] as? NSDictionary)!["lng"] as! Double!);
                    completado(datos);
                }catch{
                    print(error);
                }
            }
            
            }.resume();
    }
}
