//
//  ButacaModel.swift
//  buseslep
//
//  Created by Agustin on 9/6/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation

class Butaca{
    
    var columna: Int?
    var fila: Int?
    var numButaca: Int?
    var ocupado: Int?
    
    
    init(columna: Int , fila: Int, numButaca: Int, ocupado:Int){
        self.columna = columna
        self.fila = fila
        self.numButaca = numButaca
        self.ocupado = ocupado
    }
    
    
    class func fromDictionary(dictionary: NSDictionary) ->[Butaca]{
        var butacas = [Butaca]()
        let list = dictionary["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
        list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
            let col = item["Columna"] as!   Int //obtengo el nombre de la localidad
            let fila = item["Fila"] as! Int //obtengo el id de la localidad
            let numButaca = item["NumButaca"] as! Int
            let ocupado = item["Ocupado"] as! Int
            let butaca = Butaca(columna: col , fila: fila, numButaca: numButaca, ocupado: ocupado)
            butacas.append(butaca)
            }
        )
        return butacas
    }
}
