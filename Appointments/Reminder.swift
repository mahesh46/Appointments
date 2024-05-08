//
//  Reminder.swift
//  Appointments
//
//  Created by mahesh lad on 30/04/2024.
//
import Foundation
import UserNotifications

final class Reminder {
    
    func addReminder(detail: String, id: UUID, selectedDate: Date, selectedTime: Date) {
        var dateComponentsDateTime = DateComponents()
        var trigger : UNNotificationTrigger?
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        dateComponentsDateTime.hour = timeComponents.hour
        dateComponentsDateTime.minute = timeComponents.minute
        dateComponentsDateTime.day = dateComponents.day
        dateComponentsDateTime.month = dateComponents.month
        // dateComponentsDateTime.year = dateComponents.year
        //print(dateComponentsDateTime)
        
        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDateTime, repeats: false)
        scheduleNotification(trigger, detail: detail, id: id)
    }
     func removeReminder(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    private func scheduleNotification(_ trigger: UNNotificationTrigger?, detail: String, id: UUID) {
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = detail
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }
}

