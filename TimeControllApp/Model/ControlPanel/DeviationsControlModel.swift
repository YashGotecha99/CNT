//
//  DeviationsControlModel.swift
//  TimeControllApp
//
//  Created by prashant on 24/04/23.
//

import Foundation

struct DeviationsControlModel : Codable {
    let dueDateEmailToBeSentBeforeDays : String?
    let strings : [StringsData]?

    enum CodingKeys: String, CodingKey {

        case dueDateEmailToBeSentBeforeDays = "dueDateEmailToBeSentBeforeDays"
        case strings = "strings"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dueDateEmailToBeSentBeforeDays = try values.decodeIfPresent(String.self, forKey: .dueDateEmailToBeSentBeforeDays)
        strings = try values.decodeIfPresent([StringsData].self, forKey: .strings)
    }

}

struct StringsData : Codable {
    let key : String?
    let isRichText : Bool?
    let translations : [Translations]?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case isRichText = "isRichText"
        case translations = "translations"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        isRichText = try values.decodeIfPresent(Bool.self, forKey: .isRichText)
        translations = try values.decodeIfPresent([Translations].self, forKey: .translations)
    }

}

struct Translations : Codable {
    let lang : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case lang = "lang"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lang = try values.decodeIfPresent(String.self, forKey: .lang)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}

