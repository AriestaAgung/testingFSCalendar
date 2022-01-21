//
//  DisableNextVC.swift
//  fsCal
//
//  Created by odikk on 21/01/22.
//

import UIKit
import FSCalendar

class DisableNextVC: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    private var selectedDates: [Date]?
    private var firstDate: Date? = Date()
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var prevMonthBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        calendar.dataSource = self
        calendar.delegate = self
        calendar.placeholderType = .none
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.allowsMultipleSelection = true
        nextMonthBtn.isHidden = true        
    }
    
    private func performDateDeselect(_ calendar: FSCalendar, date: Date) {
        let sorted = calendar.selectedDates.sorted { $0 < $1 }
        if let index = sorted.firstIndex(of: date)  {
            let deselectDates = Array(sorted[index...])
            for item in deselectDates{
                calendar.deselect(item)
            }
        }
    }

    private func performDateSelection(_ calendar: FSCalendar) {
        let sorted = calendar.selectedDates.sorted { $0 < $1 }
        if let firstDate = sorted.first, let lastDate = sorted.last {
            let ranges = datesRange(from: firstDate, to: lastDate)
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
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }

    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    @IBAction func prevMonthAction(_ sender: UIButton) {
        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
    }
    
    @IBAction func nextMonthAction(_ sender: UIButton) {
        
        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
        
    }
    
}

extension DisableNextVC: FSCalendarDataSource{
    func maximumDate(for calendar: FSCalendar) -> Date {
        return firstDate!
    }
}

extension DisableNextVC: FSCalendarDelegate{

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        let currentMonth = formatter.date(from: DateFormatter().string(from: calendar.currentPage))
        if firstDate ?? Date() < getNextMonth(date: calendar.currentPage) || currentMonth == Date() {
            nextMonthBtn.isHidden = true
        } else {
            nextMonthBtn.isHidden = false
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        performDateSelection(calendar)
        if selectedDates != nil{
            if selectedDates!.count < 1{
                firstDate = date
                
            } else {
                firstDate = nil
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        performDateDeselect(calendar, date: date)
        firstDate = nil
        return true
    }
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
