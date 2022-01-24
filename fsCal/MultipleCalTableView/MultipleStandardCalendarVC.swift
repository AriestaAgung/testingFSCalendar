//
//  MultipleStandardCalendarVC.swift
//  fsCal
//
//  Created by odikk on 21/01/22.
//

import UIKit
import FSCalendar
class MultipleStandardCalendarVC: UIViewController {

    private var selectedDates: [Date]?
    
    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        calendar.delegate = self
        calendar.placeholderType = .none
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.today = nil
        calendar.allowsMultipleSelection = true
    }
    private func performDateDeselect(_ calendar: FSCalendar, date: Date) {
        let sorted = calendar.selectedDates.sorted { $0 < $1 }
        if let index = sorted.firstIndex(of: date)  {
            let deselectDates = Array(sorted[index...])
//            calendar.deselectDates(deselectDates)
            for item in deselectDates{
                calendar.deselect(item)
            }
        }
    }

    private func performDateSelection(_ calendar: FSCalendar) {
        let sorted = calendar.selectedDates.sorted { $0 < $1 }
        if let firstDate = sorted.first, let lastDate = sorted.last {
            let ranges = datesRange(from: firstDate, to: lastDate)
//            calendar.selectDates(ranges)
            for item in ranges{
                calendar.select(item)
            }
        }
    }


    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }

}

extension MultipleStandardCalendarVC: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        performDateSelection(calendar)
    }
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        performDateDeselect(calendar, date: date)
        return true
    }
   
}
