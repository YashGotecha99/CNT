//
//  UserListModel.swift
//  TimeControllApp
//
//  Created by prashant on 13/02/23.
//

import Foundation

struct AvailabilityDetailsModel : Codable {
    var availability_request : Availability_request?
}

struct Availability_request : Codable {
    let id : Int?
    var client_id : Int?
    var user_id : Int?
    let date_submit : String?
    var from_date : String?
    var to_date : String?
    var status : String?
    var request_type : String?
    var availability : [AvailabilityData]?
    let comment : String?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case client_id = "client_id"
        case user_id = "user_id"
        case date_submit = "date_submit"
        case from_date = "from_date"
        case to_date = "to_date"
        case status = "status"
        case request_type = "request_type"
        case availability = "availability"
        case comment = "comment"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        date_submit = try values.decodeIfPresent(String.self, forKey: .date_submit)
        from_date = try values.decodeIfPresent(String.self, forKey: .from_date)
        to_date = try values.decodeIfPresent(String.self, forKey: .to_date)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        request_type = try values.decodeIfPresent(String.self, forKey: .request_type)
        availability = try values.decodeIfPresent([AvailabilityData].self, forKey: .availability)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct AvailabilityData : Codable {
    var for_date : String?
    var availability_type : String?
    var comment : String?
    var from : Int?
    var to : Int?
    var isAllDay : Bool?

    enum CodingKeys: String, CodingKey {

        case for_date = "for_date"
        case availability_type = "availability_type"
        case comment = "comment"
        case from = "from"
        case to = "to"
        case isAllDay = "isAllDay"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        availability_type = try values.decodeIfPresent(String.self, forKey: .availability_type)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        isAllDay = try values.decodeIfPresent(Bool.self, forKey: .isAllDay)
    }
}
