//
//  HorarioModel.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 30/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation


class Horario{
    
    var ServicioPrestado: String?
    var fecha_llega: String?
    var hora_llega: String?
    var fecha_sale: String?
    var hora_sale: String?
    var cod_horario: Int?
    var Id_Empresa: Int?
    var id_destino: Int?
    

    
    
    init(ServicioPrestado: String , fecha_llega: String, hora_llega: String, fecha_sale: String, hora_sale: String, cod_horario: Int, Id_Empresa: Int, id_destino: Int){
        self.ServicioPrestado = ServicioPrestado
        self.fecha_llega = fecha_llega
        self.hora_llega = hora_llega
        self.fecha_sale = fecha_sale
        self.hora_sale = hora_sale
        self.cod_horario = cod_horario
        self.Id_Empresa = Id_Empresa
        self.id_destino = id_destino

    }
    

    
    
    class func fromDictionary(dictionary: NSDictionary) ->[Horario]{
        var horarios = [Horario]()
        let list = dictionary["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
        list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
            let ServicioPrestado = item["ServicioPrestado"] as!   String //obtengo el nombre de la localidad
            let fecha_llega = item["FechaHoraLlegada"] as! String //obtengo el id de la localidad
            let hora_llega = item["FechaHoraLlegada"] as! String
            let fecha_sale = item["fechahora"] as! String
            let hora_sale = item["fechahora"] as! String
            let cod_horario = item["cod_horario"] as! Int
            let Id_Empresa = item["Id_Empresa"] as! Int
            let id_destino = item["id_destino"] as! Int
            let horario = Horario(ServicioPrestado: ServicioPrestado, fecha_llega: fecha_llega.substringToIndex(fecha_llega.rangeOfString(" ")!.startIndex), hora_llega: hora_llega.substringFromIndex(hora_llega.rangeOfString(" ")!.startIndex), fecha_sale: fecha_sale.substringToIndex(fecha_sale.rangeOfString(" ")!.startIndex), hora_sale: hora_sale.substringFromIndex(hora_sale.rangeOfString(" ")!.startIndex), cod_horario: cod_horario, Id_Empresa: Id_Empresa, id_destino: id_destino)
            horarios.append(horario)
            }
        )
        return horarios
    }
}
