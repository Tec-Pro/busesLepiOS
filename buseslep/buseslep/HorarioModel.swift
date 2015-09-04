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
            let FechaHoraLlegada = item["FechaHoraLlegada"] as! String //obtengo el id de la localidad
            //let FechaHoraLlegada = item["FechaHoraLlegada"] as! String
            let fechahora = item["fechahora"] as! String
            //let hora_sale = item["fechahora"] as! String
            let cod_horario = item["cod_horario"] as! Int
            let Id_Empresa = item["Id_Empresa"] as! Int
            let id_destino = item["id_destino"] as! Int
            
            var rangeFrom = FechaHoraLlegada.rangeOfString(" ")?.endIndex
            var rangeTo = FechaHoraLlegada.rangeOfString(":00", options: .BackwardsSearch)?.startIndex
            var hora_llega = FechaHoraLlegada.substringWithRange(rangeFrom!..<rangeTo!)
            
            rangeFrom = fechahora.rangeOfString(" ")?.endIndex
            rangeTo = fechahora.rangeOfString(":00", options: .BackwardsSearch)?.startIndex
            var hora_sale = fechahora.substringWithRange(rangeFrom!..<rangeTo!)
            
            var fecha_llega = FechaHoraLlegada.substringToIndex(FechaHoraLlegada.rangeOfString(" ")!.startIndex)
            var fecha_sale = fechahora.substringToIndex(fechahora.rangeOfString(" ")!.startIndex)

            //parseo la fecha para tener el formato 11/11/2015
            var fechaLlegaArray = split(fecha_llega) {$0 == "-"}
            var anioLlega: String = fechaLlegaArray[0]
            var mesLlega: String = fechaLlegaArray[1]
            var diaLlega: String = fechaLlegaArray[2]
            
            //parseo la fecha para tener el formato 11/11/2015
            var fechaSaleArray = split(fecha_llega) {$0 == "-"}
            var anioSale: String = fechaSaleArray[0]
            var mesSale: String = fechaSaleArray[1]
            var diaSale: String = fechaSaleArray[2]
            
            let horario = Horario(ServicioPrestado: ServicioPrestado, fecha_llega: "\(diaLlega)/\(mesLlega)/\(anioLlega)", hora_llega: hora_llega, fecha_sale: "\(diaSale)/\(mesSale)/\(anioSale)", hora_sale: hora_sale, cod_horario: cod_horario, Id_Empresa: Id_Empresa, id_destino: id_destino)
            horarios.append(horario)
            }
        )
        return horarios
    }
}
