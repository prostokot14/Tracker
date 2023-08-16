//
//  Schedule.swift
//  Tracker
//
//  Created by Антон Кашников on 02.08.2023.
//

struct Schedule {
    enum DayOfWeek: String, CaseIterable {
        case monday = "Понедельник"
        case tuesday = "Вторник"
        case wednesday = "Среда"
        case thursday = "Четверг"
        case friday = "Пятница"
        case saturday = "Суббота"
        case sunday = "Воскресенье"
        
        private func getIndexOfCase() -> Int {
            return Self.allCases.firstIndex {
                self == $0
            } ?? -1
        }
        
        func getNumberOfDay() -> Int? {
            let index = getIndexOfCase()
            
            if index == 6 {
                return 1
            }
            
            return index + 2
        }
        
        func getBriefDayOfWeek() -> String {
            let index = getIndexOfCase()
            
            switch index {
            case 0:
                return "Пн"
            case 1:
                return "Вт"
            case 2:
                return "Ср"
            case 3:
                return "Чт"
            case 4:
                return "Пт"
            case 5:
                return "Сб"
            case 6:
                return "Вс"
            default:
                return ""
            }
        }
    }
    
//    enum BriefDayOfWeek: String, CaseIterable {
//        case monday = "Пн"
//        case tuesday = "Вт"
//        case wednesday = "Ср"
//        case thursday = "Чт"
//        case friday = "Пт"
//        case saturday = "Сб"
//        case sunday = "Вс"
//    }
    
    let daysOfWeek: Set<DayOfWeek>
}
