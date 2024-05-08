//
//  EditAppointmentView.swift
//  Appointments
//
//  Created by mahesh lad on 26/04/2024.
//
import SwiftUI
import CoreData

struct EditAppointmentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var appointment: Appointment
    @State private var textFieldDetails: String
    @State private var timeFieldDetails: Date
    @State private var dateFieldDetails: Date
    @State private var reminderFieldDetails: Bool
    @State private var idFieldDetails: UUID
    let reminderClass = Reminder()
    init(appointment: Appointment) {
        _appointment = ObservedObject(wrappedValue: appointment)
        _textFieldDetails = State(initialValue: appointment.details ?? "")
        _timeFieldDetails = State(initialValue: appointment.time ?? Date())
        _dateFieldDetails = State(initialValue: appointment.date ?? Date())
        _reminderFieldDetails = State(initialValue: appointment.reminder)
        _idFieldDetails = State(initialValue: appointment.id ?? UUID())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    DatePicker("Time", selection: $timeFieldDetails, displayedComponents: .hourAndMinute)
                    TextField("Details", text: $textFieldDetails, axis: .vertical)
                        .lineLimit(10)
                        .textFieldStyle(.roundedBorder)
                    Toggle("Reminder", isOn: $reminderFieldDetails)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                    
                }
                Button("Delete") {
                    managedObjectContext.delete(appointment)
                    do {
                        try self.managedObjectContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        // handle the Core Data error
                    }
                } .tint(Color.red)
            }
            .navigationBarItems(leading: Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                
                self.appointment.details = self.textFieldDetails
                self.appointment.reminder = self.reminderFieldDetails
                self.appointment.time = self.timeFieldDetails
                
                if self.reminderFieldDetails {
                    reminderClass.addReminder(detail: self.textFieldDetails, id: self.idFieldDetails, selectedDate: self.dateFieldDetails, selectedTime: self.timeFieldDetails)
                } else {
                    reminderClass.removeReminder(withIdentifier:  self.idFieldDetails.uuidString)
                }
                
                do {
                    try self.managedObjectContext.save()
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    // handle the Core Data error
                }
            })
        }
    }
}
