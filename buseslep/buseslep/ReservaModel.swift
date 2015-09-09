//
//  ReservaModel.swift
//  buseslep
//
//  Created by Alan Gonzalez on 8/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation

class Reserva{
    var sentido: String?
    var fechaReserva: String?
    var salida: String?
    var destino: String?
    var cantidad: Int
    
    
    
    init(sentido: String , fechaReserva: String, salida:String, destino: String, cantidad: Int){
        self.sentido = sentido
        self.fechaReserva = fechaReserva
        self.salida = salida
        self.destino = destino
        self.cantidad = cantidad
    }
    
    
    class func fromDictionary(dictionary: NSDictionary) ->[Reserva]{
        var reservas = [Reserva]()
        let list = dictionary["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
        list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
            let sen = item["Sentido"] as!   String
            let fechaReser = item["FechaHoraReserva"] as! String
            let sal = item["Salida"] as! String
            let dest = item["Destino"] as! String
            let cant = item["cantidad"] as! Int
            let reserva = Reserva(sentido: sen, fechaReserva: fechaReser, salida: sal, destino: dest, cantidad: cant)
            reservas.append(reserva)
            }
        )
        return reservas
    }
}