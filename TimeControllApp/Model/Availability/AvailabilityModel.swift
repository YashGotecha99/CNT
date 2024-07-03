//
//  UserListModel.swift
//  TimeControllApp
//
//  Created by prashant on 13/02/23.
//

import Foundation

struct AvailabilityModel : Codable {
    let rows : [AvailabilityList]?
    let pages : Int?
}

struct AvailabilityList : Codable {
    let id : Int?
    let client_id : Int?
    let user_id : Int?
    let date_submit : String?
    let from_date : String?
    let to_date : String?
    var status : String?
    let availability : [Availability]?
    let created_at : String?
    let updated_at : String?
    let request_type : String?
    let comment : String?
//    let updated_by : String?
    let first_name : String?
    let last_name : String?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case client_id = "client_id"
        case user_id = "user_id"
        case date_submit = "date_submit"
        case from_date = "from_date"
        case to_date = "to_date"
        case status = "status"
        case availability = "availability"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case request_type = "request_type"
        case comment = "comment"
//        case updated_by = "updated_by"
        case first_name = "first_name"
        case last_name = "last_name"
        case image = "image"
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
        availability = try values.decodeIfPresent([Availability].self, forKey: .availability)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        request_type = try values.decodeIfPresent(String.self, forKey: .request_type)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
//        updated_by = try values.decodeIfPresent(String.self, forKey: .updated_by)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }
}

struct Availability : Codable {
    let for_date : String?
    let availability_type : String?
    let comment : String?
    let from : Int?
    let to : Int?

    enum CodingKeys: String, CodingKey {

        case for_date = "for_date"
        case availability_type = "availability_type"
        case comment = "comment"
        case from = "from"
        case to = "to"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        availability_type = try values.decodeIfPresent(String.self, forKey: .availability_type)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
    }
}
