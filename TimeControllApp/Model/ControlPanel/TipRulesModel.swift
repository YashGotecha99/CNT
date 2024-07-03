//
//  TipRulesModel.swift
//  TimeControllApp
//
//  Created by prashant on 24/04/23.
//

import Foundation

struct TipRulesModel : Codable {
    let tipEditor : String?
    let tipAllocation : String?
    let profiles : [Profiles]?

    enum CodingKeys: String, CodingKey {

        case tipEditor = "tipEditor"
        case tipAllocation = "tipAllocation"
        case profiles = "profiles"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tipEditor = try values.decodeIfPresent(String.self, forKey: .tipEditor)
        tipAllocation = try values.decodeIfPresent(String.self, forKey: .tipAllocation)
        profiles = try values.decodeIfPresent([Profiles].self, forKey: .profiles)
    }

}

struct Profiles : Codable {
    let employee_type : String?
    let percentage : Int?

    enum CodingKeys: String, CodingKey {

        case employee_type = "employee_type"
        case percentage = "percentage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        employee_type = try values.decodeIfPresent(String.self, forKey: .employee_type)
        percentage = try values.decodeIfPresent(Int.self, forKey: .percentage)
    }

}
