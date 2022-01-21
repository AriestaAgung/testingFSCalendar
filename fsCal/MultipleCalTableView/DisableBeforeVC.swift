//
//  DisableBeforeVC.swift
//  fsCal
//
//  Created by odikk on 21/01/22.
//

import UIKit
import FSCalendar

class DisableBeforeVC: UIViewController {

    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    private var selectedDates: [Date]?
    private var firstDate: Date? = Date()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        calendar.dataSource = self
        calendar.delegate = self
        calendar.placeholderType = .none
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.allowsMultipleSelection = true
        previousBtn.isHidden = true
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
    
    @IBAction func nextAction(_ sender: UIButton) {
        calendar.setCurrentPage(DisableNextVC().getNextMonth(date: calendar.currentPage), animated: true)
    }
    @IBAction func prevAction(_ sender: UIButton) {
        calendar.setCurrentPage(DisableNextVC().getPreviousMonth(date: calendar.currentPage), animated: true)
    }
    private func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }

    private func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
}

extension DisableBeforeVC: FSCalendarDataSource{
    func minimumDate(for calendar: FSCalendar) -> Date {
        Date()
    }
}

extension DisableBeforeVC: FSCalendarDelegate{
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        let currentMonth = formatter.date(from: DateFormatter().string(from: calendar.currentPage))
        if firstDate ?? Date() > getPreviousMonth(date: calendar.currentPage) || currentMonth == Date() {
            previousBtn.isHidden = true
        } else {
            previousBtn.isHidden = false
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
