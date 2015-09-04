
import UIKit

class CalendarViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var daySelected : Int?
    var monthSelected : Int?
    var yearSelected : Int?

    var currentDay : Int?
    var currentMonth : Int?
    var currentYear : Int?
    
    var busquedaViewController: BusquedaViewController?
    
    var esVuelta : Bool = false //para saber si estoy eligiendo la fecha de vuelta

    @IBAction func btnListo(sender: AnyObject) {
        if validateDate(currentDay!, month: currentMonth!, year: currentYear!, day2: daySelected!, month2: monthSelected!, year2: yearSelected!) {
            //si la fecha es valida retorno todo
            if esVuelta{
                busquedaViewController?.fechaVuelta(self.daySelected!, month: self.monthSelected! , year: self.yearSelected!)
            }
            else{
                busquedaViewController?.fechaIda(self.daySelected!, month: self.monthSelected!, year: self.yearSelected!)
            }
            navigationController?.popViewControllerAnimated(true)
        }else{
            var alert = UIAlertView( title: "Error!", message: "La fecha elegida es anterior al dìa de hoy",delegate: nil,  cancelButtonTitle: "Entendido")
            alert.show()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        self.calendarView!.changeDaysOutShowingState(false)
        obtainCurrentDay()
        self.daySelected = currentDay
        self.monthSelected = currentMonth
        self.yearSelected = currentYear
        if (esVuelta){
            navigationItem.title = "Fecha de vuelta"
        }
        else{
            navigationItem.title = "Fecha de ida"
        }
        
    }
    
    //conesto obtengo el dia de hoy y lo gaurdo en variables
    func obtainCurrentDay(){
        let calendar = NSCalendar.currentCalendar()
        let components = Manager.componentsForDate(NSDate()) // from today
        currentDay = components.day
        currentMonth = components.month
        currentYear = components.year
    }
    
    //retorna true si la primer fecha es menor que la segunda
    func validateDate(day: Int, month: Int, year : Int,day2: Int, month2: Int, year2 : Int) -> Bool{
        if(year < year2){
            return true
        }
        if(year > year2){
            return false
        }else{
            if (month < month2){
                return true
            }
            if (month > month2){
                return false
            }else{
                if (day <= day2){
                    return true
                }
                else {
                    return false
                }
            }
        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Monday
    }
    
    // MARK: Optional methods
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        let date = dayView.date
        self.daySelected = date.day
        self.monthSelected = date.month
        self.yearSelected = date.year
        //calendarView.presentedDate.
        //println("\(calendarView.presentedDate.commonDescription) is selected!")
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription  {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let day = dayView.date.day
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = Int(arc4random_uniform(3) + 1)
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
}

// MARK: - CVCalendarViewDelegate

extension CalendarViewController: CVCalendarViewDelegate {
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    
    
}

// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}



// MARK: - Convenience API Demo

extension CalendarViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
}