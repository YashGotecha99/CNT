//
//  SideMenuModel.swift
//  TimeControllApp
//
//  Created by mukesh on 13/07/22.
//

import Foundation
import UIKit

struct SideMenuModel {
    var images = ["document-text","note","autobrightness","receipt-discount","Logout"]
//    var name = ["Tasks","Vacations & Absents","Change Language","Reports","Logout"]
    var name = [LocalizationKey.tasks.localizing(),LocalizationKey.vacationsAbsents.localizing(),LocalizationKey.changeLanguage.localizing(),LocalizationKey.reports.localizing(),LocalizationKey.logout.localizing()]
}

class SideMenuViewModel {
    
    var images = ["Profile","Swap","document-text","note","clipboard-text","autobrightness","receipt-discount","Logout"]
//    var name = ["Users","Shift Requests","Tasks","Vacations & Absents","Pending Requests","Change Language","Reports","Logout"]
    var name = [LocalizationKey.users.localizing(),LocalizationKey.shiftRequests.localizing(),LocalizationKey.tasks.localizing(),LocalizationKey.vacationsAbsents.localizing(),LocalizationKey.changeLanguage.localizing(),LocalizationKey.reports.localizing(),LocalizationKey.logout.localizing()]
}
