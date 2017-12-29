//
//  LineasInfoController.swift
//  Revimex
//
//  Created by Seifer on 07/12/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit

class LineasInfoController: UIViewController {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var botonComenzar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomBackgroundAndNavbar()

        switch lineaSeleccionada {
        case 0:
            clienteFinal()
            break
        case 1:
            mercadoAbierto()
            break
        case 2:
            inversionista()
            break
        case 3:
            brokerage()
            break
        default:
            clienteFinal()
            break
        }
    }
    
    
    
    func clienteFinal(){
        titulo.text = "Cliente Final"
        descripcion.text = "Compra tu casa con Revimex!!"
    }
    
    func mercadoAbierto(){
        titulo.text = "Mercado Abierto"
        descripcion.text = "Anunciate con notros!!!"
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mercadoAbiertoTapped(tapGestureRecognizer:)))
        botonComenzar.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func inversionista(){
        titulo.text = "Inversionista"
        descripcion.text = "Invertir tu dinero en casas adjudicadas es una estrategia que te permitirá preservar y mejorar tu capital.\n\nAdquiere inmuebles a un precio entre el 30% y 60% de su valor real.\n\nAdquiere estos inmuebles de primera mano; su valor es menor al que podrías obtener al adquirirlos en los juzgados.\n\nGarantia en los bienes inmuebles.\n\nSeguimiento de status del juicio cada ves que quieras por medio de nuestra plataforma a revisar el expediente al juzgado correspondiente.\n\nRespaldo en el proceso judicial hasta la entrega física del inmueble."
    }
    
    func brokerage(){
        titulo.text = "Brokerage"
        descripcion.text = "Empieza a invertir en uno de los rendimientos mas rentables del mundo.\n\nRendimientos hasta un 20%.\n\nContrato de compraventa.\n\nUna de las clases de activos más rentables del mundo.\n\nMonitorea el avance y rendimientos de cada proyecto.\n\nDescubre las posibilidades que BROKERAGE tiene para ti."
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(brokeragetapped(tapGestureRecognizer:)))
        botonComenzar.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setCustomBackgroundAndNavbar()
    }
    
    
    @objc func brokeragetapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let formContainer = storyboard.instantiateViewController(withIdentifier: "FormContainer");
        navigationController?.pushViewController(formContainer, animated: true);
    }
    
    @objc func mercadoAbiertoTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "lineasInfoToMercadoAbierto", sender: nil)
    }

}
