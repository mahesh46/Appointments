//
//  CalendarView.swift
//  Appointments
//
//  Created by mahesh lad on 26/04/2024.
//
import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
        }
    }
}
