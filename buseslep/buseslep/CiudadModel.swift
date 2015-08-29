//
//  CiudadModel.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 29/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation


class Ciudad{

    var id: Int?
    var nombre: String?

    

    init(id: Int , nombre: String){
        self.id = id
        self.nombre = nombre
    }


    class func fromDictionary(dictionary: NSDictionary) ->[Ciudad]{
        var ciudades = [Ciudad]()
        let list = dictionary["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
        list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
                let nombre = item["Localidad"] as!   String //obtengo el nombre de la localidad
                let id = item["ID_Localidad"] as! Int //obtengo el id de la localidad
                let ciudad = Ciudad(id: id , nombre: nombre)
                ciudades.append(ciudad)
            }
        )
        return ciudades
    }
}