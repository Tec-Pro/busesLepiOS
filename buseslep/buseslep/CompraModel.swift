//
//  CompraModel.swift
//  buseslep
//
//  Created by Alan Gonzalez on 19/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation
class Compra{
    
    var destino:String
    var salida:String
    var codigo:Int
    var cantidad:Int
    
    init(dest:String, sal:String, c: Int, ca:Int){
        self.destino = dest
        self.salida = sal
        self.codigo = c
        self.cantidad = ca
    }
    
    class func fromDictionary(dictionary: NSDictionary) ->[Compra]{
        var compras = [Compra]()
        let list = dictionary["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
        list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
            let des = item["Destino"] as!   String
            let sal = item["Salida"] as! String
            let cod = item["CodImpresion"] as! Int
            let c = item["cantidad"] as! Int
            
            var rangeFrom = sal.rangeOfString(" ")?.endIndex
            var rangeTo = sal.rangeOfString(":00", options: .BackwardsSearch)?.startIndex
            var hora = sal.substringWithRange(rangeFrom!..<rangeTo!)
            
            
            
            var fecha_llega = sal.substringToIndex(sal.rangeOfString(" ")!.startIndex)
            
            
            //parseo la fecha para tener el formato 11/11/2015
            var salidaArray = split(fecha_llega) {$0 == "-"}
            var anioLlega: String = salidaArray[0]
            var mesLlega: String = salidaArray[1]
            var diaLlega: String = salidaArray[2]
            
            var salida = diaLlega+"/"+mesLlega+"/"+anioLlega+"  "+hora
            var compra = Compra(dest: des, sal: salida, c: cod, ca: c)
            compras.append(compra)
            })
        return compras
        }
    
}