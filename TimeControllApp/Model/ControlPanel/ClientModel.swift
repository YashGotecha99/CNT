//
//  ClientModel.swift
//  TimeControllApp
//
//  Created by prashant on 24/04/23.
//

import Foundation

struct ClientModel : Codable {
    let id : Int?
    let image : String?
    let status : String?
    let biztype : Int?
    let client_type : String?
    let customer_name : String?
    let post_place : String?
    let post_number : String?
    let address : String?
    let name : String?
    let max_users : Int?
    let max_users_requested : Int?
    let tax_number : String?
    let renew_date : String?
    let renew_manual : Bool?
    var data : ClientDataModel?
    let allow_system_document : Bool?
    let allow_visitor_only : Bool?
    let allow_tip : Bool?
    let employment_fee : Int?
    let qrcode_path : String?
    let expiry_date : String?
    let createdAt : String?
    let updatedAt : String?
    let user_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case image = "image"
        case status = "status"
        case biztype = "biztype"
        case client_type = "client_type"
        case customer_name = "customer_name"
        case post_place = "post_place"
        case post_number = "post_number"
        case address = "address"
        case name = "name"
        case max_users = "max_users"
        case max_users_requested = "max_users_requested"
        case tax_number = "tax_number"
        case renew_date = "renew_date"
        case renew_manual = "renew_manual"
        case data = "data"
        case allow_system_document = "allow_system_document"
        case allow_visitor_only = "allow_visitor_only"
        case allow_tip = "allow_tip"
        case employment_fee = "employment_fee"
        case qrcode_path = "qrcode_path"
        case expiry_date = "expiry_date"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case user_id = "user_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        biztype = try values.decodeIfPresent(Int.self, forKey: .biztype)
        client_type = try values.decodeIfPresent(String.self, forKey: .client_type)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        max_users = try values.decodeIfPresent(Int.self, forKey: .max_users)
        max_users_requested = try values.decodeIfPresent(Int.self, forKey: .max_users_requested)
        tax_number = try values.decodeIfPresent(String.self, forKey: .tax_number)
        renew_date = try values.decodeIfPresent(String.self, forKey: .renew_date)
        renew_manual = try values.decodeIfPresent(Bool.self, forKey: .renew_manual)
        data = try values.decodeIfPresent(ClientDataModel.self, forKey: .data)
        allow_system_document = try values.decodeIfPresent(Bool.self, forKey: .allow_system_document)
        allow_visitor_only = try values.decodeIfPresent(Bool.self, forKey: .allow_visitor_only)
        allow_tip = try values.decodeIfPresent(Bool.self, forKey: .allow_tip)
        employment_fee = try values.decodeIfPresent(Int.self, forKey: .employment_fee)
        qrcode_path = try values.decodeIfPresent(String.self, forKey: .qrcode_path)
        expiry_date = try values.decodeIfPresent(String.self, forKey: .expiry_date)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
    }

}
