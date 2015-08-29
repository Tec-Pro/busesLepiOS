//
//  CiudadModel.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 29/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation


class CiudadOrigen{

    var id: Int?
    var nombre: String?

    

    init(id: Int , nombre: String){
        self.id = id
        self.nombre = nombre
    }


    class func fromDictionary(dictionary: NSDictionary) ->[CiudadOrigen]{
        var ciudades = [CiudadOrigen]()
        let list = dictionary["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
        list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
                let nombre = item["Localidad"] as!   String //obtengo el nombre de la localidad
                let id = item["ID_Localidad"] as! Int //obtengo el id de la localidad
                let ciudad = CiudadOrigen(id: id , nombre: nombre)
                ciudades.append(ciudad)
            }
        )
        return ciudades
    }
}

class CiudadDestino{
    var id_localidad_origen: Int?
    var id_localidad_destino: Int?
    var hasta: String?
    var desde: String?
    
    
    init(id_localidad_origen: Int , id_localidad_destino: Int, hasta: String, desde: String){
        self.id_localidad_origen = id_localidad_origen
        self.id_localidad_destino = id_localidad_destino
        self.hasta = hasta
        self.desde = desde
    }
    
    
    class func fromDictionary(dictionary: NSDictionary) ->[CiudadDestino]{
        var ciudades = [CiudadDestino]()
        let list = dictionary["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
        list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
            let id_localidad_origen = item["id_localidad_origen"] as!   Int
            let id_localidad_destino = item["id_localidad_destino"] as! Int
            let hasta = item["hasta"] as! String
            let desde = item["desde"] as! String

            let ciudad = CiudadDestino(id_localidad_origen: id_localidad_origen, id_localidad_destino: id_localidad_destino, hasta: hasta, desde: desde)
            ciudades.append(ciudad)
            }
        )
        return ciudades
    }

}