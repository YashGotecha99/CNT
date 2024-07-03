//
//  ExtendedRulesModel.swift
//  TimeControllApp
//
//  Created by prashant on 24/04/23.
//

import Foundation

struct ExtendedRulesModel : Codable {
    let kilometersRules : [KilometersRules]?
    let vacation_types : [Vacation_types]?
    let absent_types : [Absent_types]?
    let expense_types : [Expense_types]?
    let extrawork_types : [Extrawork_types]?
    let user_groups : [User_groups]?

    enum CodingKeys: String, CodingKey {

        case kilometersRules = "kilometersRules"
        case vacation_types = "vacation_types"
        case absent_types = "absent_types"
        case expense_types = "expense_types"
        case extrawork_types = "extrawork_types"
        case user_groups = "user_groups"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kilometersRules = try values.decodeIfPresent([KilometersRules].self, forKey: .kilometersRules)
        vacation_types = try values.decodeIfPresent([Vacation_types].self, forKey: .vacation_types)
        absent_types = try values.decodeIfPresent([Absent_types].self, forKey: .absent_types)
        expense_types = try values.decodeIfPresent([Expense_types].self, forKey: .expense_types)
        extrawork_types = try values.decodeIfPresent([Extrawork_types].self, forKey: .extrawork_types)
        user_groups = try values.decodeIfPresent([User_groups].self, forKey: .user_groups)
    }

}

struct KilometersRules : Codable {
    let distance : String?

    enum CodingKeys: String, CodingKey {

        case distance = "distance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
    }

}

struct Vacation_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    init(code:String,name:String) {
        self.code = code
        self.name = name
    }

}

struct Absent_types : Codable {
    let code : String?
    var name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

    init(code:String,name:String) {
        self.code = code
        self.name = name
    }
}

struct Expense_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Extrawork_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}


struct ReligionData : Codable {
    let code : String?
    let country : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case country = "country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }

}
struct User_groups : Codable {
    let code : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}
