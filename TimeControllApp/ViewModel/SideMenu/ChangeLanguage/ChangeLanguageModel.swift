//
//  ChangeLanguageModel.swift
//  TimeControllApp
//
//  Created by mukesh on 24/07/22.
//

import Foundation
import UIKit

struct ChangeLanguageModel {
    var languageName: String
    var languageCode: String
    init(languageName:String, languageCode:String) {
        self.languageName = languageName
        self.languageCode = languageCode
    }
}

class ChangeLanguageViewModel {
    
    var Languages = [ChangeLanguageModel(languageName: LocalizationKey.english.localizing(), languageCode: "en"),ChangeLanguageModel(languageName: LocalizationKey.polish.localizing(), languageCode: "pl"),ChangeLanguageModel(languageName: LocalizationKey.lithuanian.localizing(), languageCode: "lt-LT"),ChangeLanguageModel(languageName: LocalizationKey.greek.localizing(), languageCode: "el-GR"),ChangeLanguageModel(languageName: LocalizationKey.norwegian.localizing(), languageCode: "nb"),ChangeLanguageModel(languageName: LocalizationKey.russian.localizing(), languageCode: "ru"),ChangeLanguageModel(languageName: LocalizationKey.spanish.localizing(), languageCode: "es"),ChangeLanguageModel(languageName: LocalizationKey.swedish.localizing(), languageCode: "sv")]
    
//    var Languages = [ChangeLanguageModel(languageName: LocalizationKey.english.localizing(), languageCode: "en"),ChangeLanguageModel(languageName: LocalizationKey.polish.localizing(), languageCode: "pl"),ChangeLanguageModel(languageName: LocalizationKey.norwegian.localizing(), languageCode: "nb"),ChangeLanguageModel(languageName: LocalizationKey.spanish.localizing(), languageCode: "es")]
}
