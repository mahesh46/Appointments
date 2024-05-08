//
//  AppointmentsApp.swift
//  Appointments
//
//  Created by mahesh lad on 26/04/2024.
//
import SwiftUI

@main
struct AppointmentsApp: App {
    @StateObject private var persistenceController = PersistenceController()
    var body: some Scene {
        WindowGroup {
            AppointmentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
