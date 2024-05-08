//
//  AddAppointmentView.swift
//  Appointments
//
//  Created by mahesh lad on 26/04/2024.
//
import CoreData
import SwiftUI
import UserNotifications

struct AddAppointmentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedDate: Date
    @State private var details = ""
    @State private var selectedTime = Date()
    @State private var reminder = false
    @State private var trigger : UNNotificationTrigger?
    @State private var dateComponentsDateTime = DateComponents()
    let reminderClass = Reminder()

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                TextField("Details", text: $details, axis: .vertical)
                    .lineLimit(10)
                    .textFieldStyle(.roundedBorder)
                  
                Toggle("Reminder", isOn: $reminder)
                               .toggleStyle(SwitchToggleStyle(tint: .green))
            }
            .navigationBarItems(leading: Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Add") {
                let newAppointment = Appointment(context: self.managedObjectContext)
                newAppointment.id = UUID()
                newAppointment.date = self.selectedDate
                newAppointment.time = self.selectedTime
                newAppointment.details = self.details
                newAppointment.reminder = self.reminder

                do {
                    try self.managedObjectContext.save()
                    if self.reminder {
                        reminderClass.addReminder(detail: self.details, id: newAppointment.id ?? UUID(), selectedDate: selectedDate, selectedTime: selectedTime)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    print(error)
                }
            })
        }
    }
    
}
