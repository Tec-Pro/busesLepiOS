//
//  BusquedasModel.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 6/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation


class BusquedasModel{
    
    var id :Int?
    var city_origin :String?
    var city_destiny :String?
    var code_city_origin :Int?
    var code_city_destiny :Int?
    var date_go  :String?
    var date_return  :String?
    var number_tickets  :Int?
    var is_roundtrip  :Bool?
    
    init(id :Int,city_origin :String,city_destiny :String,code_city_origin :Int,code_city_destiny :Int,date_go  :String, date_return  :String,number_tickets  :Int,is_roundtrip  :Bool){
        self.id = id
        self.city_origin = city_origin
        self.city_destiny = city_destiny
        self.code_city_origin = code_city_origin
        self.code_city_destiny = code_city_destiny
        self.date_go = date_go
        self.date_return = date_return
        self.number_tickets = number_tickets
        self.is_roundtrip = is_roundtrip
    }
}