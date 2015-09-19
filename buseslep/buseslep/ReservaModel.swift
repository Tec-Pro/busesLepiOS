//
//  ReservaModel.swift
//  buseslep
//
//  Created by Alan Gonzalez on 8/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation

class Reserva{
    var sentidoIda: String?
    var fechaReservaIda: String?
    var salidaIda: String?
    var destinoIda: String?
    var cantidadIda: Int
    
    var sentidoVuelta: String?
    var fechaReservaVuelta: String?
    var salidaVuelta: String?
    var destinoVuelta: String?
    var cantidadVuelta: Int
    
    
    
    init(sentido: String , fechaReserva: String, salida:String, destino: String, cantidad: Int,sentidoV: String , fechaReservaV: String, salidaV:String, destinoV: String, cantidadV: Int){
        self.sentidoIda = sentido
        self.fechaReservaIda = fechaReserva
        self.salidaIda = salida
        self.destinoIda = destino
        self.cantidadIda = cantidad
        
        self.sentidoVuelta = sentidoV
        self.fechaReservaVuelta = fechaReservaV
        self.salidaVuelta = salidaV
        self.destinoVuelta = destinoV
        self.cantidadVuelta = cantidadV
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
            
            var rangeFrom = sal.rangeOfString(" ")?.endIndex
            var rangeTo = sal.rangeOfString(":00", options: .BackwardsSearch)?.startIndex
            var hora = sal.substringWithRange(rangeFrom!..<rangeTo!)
            
            
            
            var fecha_llega = sal.substringToIndex(sal.rangeOfString(" ")!.startIndex)
            
            
            //parseo la fecha para tener el formato 11/11/2015
            var fechaLlegaArray = split(fecha_llega) {$0 == "-"}
            var anioLlega: String = fechaLlegaArray[0]
            var mesLlega: String = fechaLlegaArray[1]
            var diaLlega: String = fechaLlegaArray[2]
            
            
            let reserva = Reserva(sentido: sen, fechaReserva: fechaReser, salida: diaLlega+"/"+mesLlega+"/"+anioLlega+"   "+hora, destino: dest, cantidad: cant, sentidoV:"",fechaReservaV:"",salidaV:"",destinoV:"",cantidadV:0)
            reservas.append(reserva)
            }
        )
        var reservasFinal = [Reserva]()
        if reservas.count > 1{
            var i: Int = 0
            var j: Int = 0
            
            for i in 0 ... reservas.count-1{
                for j in i ... reservas.count-1{
                    if(reservas[i].sentidoIda! == "Ida"){
                        if((reservas[i].fechaReservaIda! == reservas[j].fechaReservaIda!) && reservas[i].sentidoIda != reservas[j].sentidoIda){
                            reservas[i].destinoVuelta = reservas[j].destinoIda
                            reservas[i].cantidadVuelta = reservas[j].cantidadIda
                            reservas[i].sentidoVuelta = reservas[j].sentidoIda
                            reservas[i].fechaReservaVuelta = reservas[j].fechaReservaIda
                            reservas[i].salidaVuelta = reservas[j].salidaIda
                            
                        }
                    }
                }
            }
            
            for i in 0 ... reservas.count-1{
                if reservas[i].sentidoIda! == "Ida"{
                    reservasFinal.append(reservas[i])
                }
            }
            return reservasFinal
        }else{
            return reservas
        }
        
    }
}