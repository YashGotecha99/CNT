//
//  MyDelegate.swift
//  TimeControllApp
//
//  Created by prashant on 23/05/23.
//

import Foundation

protocol NotificationDelegate: AnyObject {
    func didReceiveNotification(with userInfo: [AnyHashable: Any])
}
