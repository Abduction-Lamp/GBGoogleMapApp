//
//  NotificationManager.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 16.04.2022.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func authorization()
    func reminderAbsentLongTime()
}


final class NotificationManager: NotificationServiceProtocol {
    
    static var badgeCount: NSNumber = 0

    
    let center = UNUserNotificationCenter.current()
    
    func authorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
//            self.sendNotificatioRequest(content: self.makeNotificationContent(), trigger: self.makeIntervalNotificatioTrigger())
        }
    }
    
    func reminderAbsentLongTime() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            self.sendNotificatioRequest(content: self.makeNotificationContent(), trigger: self.makeIntervalNotificatioTrigger())
        }
    }
    
    
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.subtitle = "Google map"
        content.body = "Have you been away for a long time"
        return content
    }
    
    private func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false )
    }
    
    private func sendNotificatioRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alaram", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
