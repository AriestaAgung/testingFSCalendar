//
//  ViewController.swift
//  fsCal
//
//  Created by odikk on 19/01/22.
//

import UIKit
import FSCalendar
import HorizonCalendar

class ViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var newBtn: UIButton!
    private var paramDate = Date()
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    private var datesRange: [Date]?
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    let highlightedColorForRange = UIColor(red: 0.31, green: 0.74, blue: 0.73, alpha: 1.00)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        self.calendar.allowsMultipleSelection = true
        self.calendar.register(CustomCell.self, forCellReuseIdentifier: "cell")
        self.calendar.clipsToBounds           = true
        self.calendar.dataSource              = self
        self.calendar.delegate                = self
        
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        //Header
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.headerTitleColor = .black
    
        // Title
        calendar.appearance.weekdayTextColor  = .gray
        calendar.appearance.titleDefaultColor = .black
           
        let dates = [
            self.gregorian.date(byAdding: .day, value: -1, to: Date()),
            Date(),
            self.gregorian.date(byAdding: .day, value: 1, to: Date())
        ]
        dates.forEach { (date) in
            self.calendar.select(date, scrollToDate: false)
        }
        
    }
    
    private func configureVisibleCells(){
        self.calendar.visibleCells().forEach{ (cell) in
            let date = self.calendar.date(for: cell)
            let position = self.calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    
    
//    func datesRange(from: Date, to: Date) -> [Date] {
//        // in case of the "from" date is more than "to" date,
//        // it should returns an empty array:
//        if from > to { return [Date]() }
//
//        var tempDate = from
//        var array = [tempDate]
//
//        while tempDate < to {
//            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
//            array.append(tempDate)
//        }
//
//        return array
//    }
    
//    private func performDateDeselect(_ calendar: FSCalendar, date: Date) {
//        let sorted = calendar.selectedDates.sorted { $0 < $1 }
//        if let index = sorted.firstIndex(of: date)  {
//            let deselectDates = Array(sorted[index...])
//            for item in deselectDates{
//                calendar.deselect(item)
//            }
//        }
//    }
    
//    private func performDateSelection(_ calendar: FSCalendar,_ date: Date) {
//        let sorted = calendar.selectedDates.sorted { $0 < $1 }
//        if let firstDate = sorted.first, let lastDate = sorted.last {
//            let ranges = datesRange(from: firstDate, to: lastDate)
//            for item in ranges{
//                calendar.select(item)
//            }
//        }
//    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! CustomCell)

        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.selectionLayer.isHidden = true
        }
    }
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Calendar.current.date(byAdding: .year, value: -1, to: paramDate)!
//    }
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        return paramDate
//    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        return calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .blue
    }
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    
}

extension Date{
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }
}
