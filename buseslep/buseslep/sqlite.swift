
import SQLite
import CVCalendar


class Sqlite {

    var db :Database;
    var searches :Query
    let id = Expression<Int>("id")
    let city_origin = Expression<String?>("city_origin")
    let city_destiny = Expression<String>("city_destiny")
    let code_city_origin = Expression<Int>("code_city_origin")
    let code_city_destiny = Expression<Int>("code_city_destiny")
    let date_go = Expression<String>("date_go")
    let date_return = Expression<String>("date_return")
    let number_tickets = Expression<Int>("number_tickets")
    let is_roundtrip = Expression<Bool>("is_roundtrip")
    
     init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first as! String
        
        self.db = Database("\(path)/db.sqlite3")
        self.searches = db["searches"]
        

        // db.drop(table: searches)
        db.execute("CREATE TABLE IF NOT EXISTS searches(id INTEGER PRIMARY KEY AUTOINCREMENT, city_origin TEXT NOT NULL, city_destiny TEXT NOT NULL, code_city_origin INTEGER NOT NULL, code_city_destiny INTEGER NOT NULL, date_go DATE NOT NULL, date_return DATE , number_tickets INTEGER NOT NULL, is_roundtrip INTEGER NOT NULL)")

        // CREATE TABLE "users" (
        //     "id" INTEGER PRIMARY KEY NOT NULL,
        //     "name" TEXT,
        //     "email" TEXT NOT NULL UNIQUE
        // )

    }

    func insert( city_origin: String , city_destiny: String , code_city_origin: Int , code_city_destiny: Int , date_go: String , date_return :String , number_tickets: Int , is_roundtrip: Bool){

        
        
            let stmt = db.prepare("INSERT INTO searches (city_origin,city_destiny,code_city_origin,code_city_destiny,date_go,date_return,number_tickets,is_roundtrip) VALUES (?,?,?,?,?,?,?,?)")
        stmt.run(city_origin,city_destiny,code_city_origin,code_city_destiny,date_go,date_return,number_tickets,is_roundtrip)
    
    }
    
    
    /**
    * borra TODAS las busquedas realizadas
    */
    func delete(){
        self.searches.delete()
    }
    

    func getSearches() -> [BusquedasModel]{
        var ret : [BusquedasModel] = [BusquedasModel]()
          for search in searches {
              //println("id: \(search[city_origin]), city_origin: \(search[city_origin]), city_destiny: \(search[city_destiny])")
            println("\(search[id]) \(search[city_origin]!) \(search[city_destiny]) \(search[code_city_origin]) \(search[code_city_destiny]) \(search[date_go]) \(search[date_return]) \(search[number_tickets]) \(search[is_roundtrip]) ")
            var busqueda = BusquedasModel(id: search[id], city_origin: search[city_origin]!,city_destiny: search[city_destiny], code_city_origin: search[code_city_origin], code_city_destiny: search[code_city_destiny], date_go: search[date_go], date_return: search[date_return], number_tickets: search[number_tickets], is_roundtrip: search[is_roundtrip])
            ret.append(busqueda)
        }
       return ret
    }
    
    func deleteOldSearches(){
        let calendar = NSCalendar.currentCalendar()
        let components = Manager.componentsForDate(NSDate()) // from today
        var currentDay = components.day
        var currentMonth = components.month
        var currentYear = components.year
        let stmt = db.prepare("DELETE FROM searches WHERE CAST(strftime('%s', date_go)  AS  integer) < CAST(strftime('%s', '\(convertirFecha(currentDay, month: currentMonth, year: currentYear))')  AS  integer)")
        stmt.run();
   //     stmt.run("CAST(strftime('%s', '\(convertirFecha(currentDay, month: currentMonth, year: currentYear))')  AS  integer) ") //quiero ver si esto funca
        //let stmt = db.prepare("DELETE FROM searches WHERE date_go < ?")
        //stmt.run(convertirFecha(currentDay, month: currentMonth, year: currentYear))
    }
      //  var alice: Query?
      //  if let rowid = users.insert(name <- "Alice", email <- "alice@mac.com").rowid {
      //      println("inserted id: \(rowid)")
            // inserted id: 1
            //alice = users.filter(id == rowid)
      //  }
        // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')
        
      //  for user in users {
      //      println("id: \(user[id]), name: \(user[name]), email: \(user[email])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
      //  }
        // SELECT * FROM "users"
        
       // alice?.update(email <- replace(email, "mac.com", "me.com"))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)
        
       // alice?.delete()
        // DELETE FROM "users" WHERE ("id" = 1)
        
        //println(users.count)
        // SELECT count(*) FROM "users"
    
    func convertirFecha(day: Int, month: Int, year:Int) -> String{
        var result :String = year.description
        if count(month.description) < 2{ // es el dia 1-9
            result.extend("-0\(month)")
        }else{
            result.extend("-\(month)")
        }
        if count(day.description) < 2{ // es el dia 1-9
            result.extend("-0\(day)")
        }else{
            result.extend("-\(day)")
        }
        return result
    }
}
