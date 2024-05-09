//
//  AppointmentView.swift
//  Appointments
//
//  Created by mahesh lad on 26/04/2024.
//
import SwiftUI
import CoreData

struct AppointmentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Appointment.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Appointment.date, ascending: true), NSSortDescriptor(keyPath: \Appointment.time, ascending: true) ]) var appointments: FetchedResults<Appointment>
    
    @State private var selectedDate = Date()
    @State private var showingAddAppointment = false
    
    var body: some View {
        NavigationView {
            VStack {
                CalendarView(selectedDate: $selectedDate)
                Divider()
                Text("Appointments")
                    .font(.headline)
                List {
                    ForEach(appointments.filter { isSameDay($0.date ?? Date(), selectedDate) }, id: \.self) { appointment in
                        NavigationLink(destination: EditAppointmentView(appointment: appointment)) {
                            Text("\(appointment.time?.formatted(date: .omitted, time: .shortened) ?? "") \(appointment.details ?? "")")
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                .navigationBarTitle("Calendar")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: { self.showingAddAppointment = true }) {
                    Image(systemName: "plus")
                })
                .navigationBarItems(leading: Button(action: { self.shareButton() }) {
                    
                    Image(systemName: "square.and.arrow.up")
                    Text("csv")
                })
                .onAppear {
                    requestNotificationPermission()
                }
                .sheet(isPresented: $showingAddAppointment) {
                    AddAppointmentView(selectedDate: self.$selectedDate)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
            }
        }
        .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
    
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs:date2)
    }
    
    func shareButton() {
        let fileName = "export.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Date,Time, Appointment, Reminder\n"
        
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "d.M.yyyy"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm"
        
        for appointment in appointments {
            let formattedDate = dateFormatterDate.string(from: appointment.date ?? Date())
            let formattedTime = dateFormatterTime.string(from: appointment.time ?? Date())
            csvText += "\(formattedDate), \(formattedTime),  \(appointment.details ?? ""), \(appointment.reminder)\n"
        }
        
        do {
            print(csvText)
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        print(path ?? "not found")
        
        var filesToShare = [Any]()
        filesToShare.append(path!)
        
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}

//#Preview {
//    AppointmentView()
//}

struct AppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentView()
    }
}
