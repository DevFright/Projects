//
//  ContentView.swift
//  Local Notifications
//
//  Created by Matthew Newill on 25/03/2022.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var calendarEntryTitle: String = ""
    @State private var selectedDateTime = Date()
    
    var body: some View {
        VStack {
            Text("Local Notification Test")
                .font(.largeTitle)
                .padding(.bottom, 40.0)
            
            HStack {
                Text("Calendar Entry:")
                    .padding(.leading)
                TextField("Title", text: $calendarEntryTitle)
            }
            
            DatePicker(selection: $selectedDateTime, label: { Text("")
                    .multilineTextAlignment(.trailing)
                .padding(.leading) })
            .padding(.trailing)
            .datePickerStyle(.wheel)
            
            Button("Schedule Notification") {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    
                    if let error = error {
                        // Handle the error here.
                    }
                }
                
                let content = UNMutableNotificationContent()
                content.title = calendarEntryTitle
                content.body = selectedDateTime.description
                
                
                var dateComponents = DateComponents()
                dateComponents = Calendar.current.dateComponents([.hour, .day, .minute], from: selectedDateTime)
                
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents, repeats: false)
                
                let locationCenter = CLLocationCoordinate2D(latitude: 37.335400, longitude: -122.009201)
                let region = CLCircularRegion(center: locationCenter, radius: 2000.0, identifier: "Headquarters")
                region.notifyOnEntry = true
                region.notifyOnExit = false
                let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
                
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString,
                                                    content: content, trigger: trigger)
                
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        // Handle any errors.
                    }
                }
            }
            .padding(.top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
