//
//  ProfileViewModel.swift
//  TimeControllApp
//
//  Created by mukesh on 17/07/22.
//

import Foundation
import UIKit

struct ProfileModel{
    
}

class ProfileViewModel {
    
    var images = ["Edit","kidsinfo","kidsinfo","Location","Setting"]
    var name = [LocalizationKey.personalInfo.localizing(),LocalizationKey.kidsInfo.localizing(),LocalizationKey.closestRelative.localizing(),LocalizationKey.homeLocation.localizing(),LocalizationKey.settings.localizing()]
    
}
