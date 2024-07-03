//
//  ControlPanelModel.swift
//  TimeControllApp
//
//  Created by prashant on 24/04/23.
//

import Foundation

struct ControlPanelModel : Codable {
    var client : ClientModel?
    let biztype : BiztypeModel?
    let integration_details : Integration_details?
    let timezoneGMT : Int?
//    let pms : Pms?
//    let deviationConfig : DeviationConfig?
//    let deviationStrings : DeviationStrings?

    enum CodingKeys: String, CodingKey {

        case client = "client"
        case biztype = "biztype"
        case integration_details = "integration_details"
        case timezoneGMT = "timezoneGMT"
//        case pms = "pms"
//        case deviationConfig = "deviationConfig"
//        case deviationStrings = "deviationStrings"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        client = try values.decodeIfPresent(ClientModel.self, forKey: .client)
        biztype = try values.decodeIfPresent(BiztypeModel.self, forKey: .biztype)
        integration_details = try values.decodeIfPresent(Integration_details.self, forKey: .integration_details)
        timezoneGMT = try values.decodeIfPresent(Int.self, forKey: .timezoneGMT)
//        pms = try values.decodeIfPresent(Pms.self, forKey: .pms)
//        deviationConfig = try values.decodeIfPresent(DeviationConfig.self, forKey: .deviationConfig)
//        deviationStrings = try values.decodeIfPresent(DeviationStrings.self, forKey: .deviationStrings)
    }
}

struct Integration_details : Codable {
    let id : Int?
    let client_id : Int?
    let product : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case client_id = "client_id"
        case product = "product"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        product = try values.decodeIfPresent(String.self, forKey: .product)
    }

}
