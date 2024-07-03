//
//  AbsenceListModel.swift
//  TimeControllApp
//
//  Created by yash on 06/02/23.
//

import Foundation

struct AbsenceListModel : Codable {
    let rows : [AbsenceRows]?
    let pages : Int?
    let totalCount : Int?

    enum CodingKeys: String, CodingKey {

        case rows = "rows"
        case pages = "pages"
        case totalCount = "totalCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rows = try values.decodeIfPresent([AbsenceRows].self, forKey: .rows)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
    }

}

struct AbsenceRows : Codable {
    let id : Int?
    var status : String?
    let client_id : Int?
    let user_id : Int?
    let from : String?
    let to : String?
    let absence_type : String?
    let total_days : Int?
    let attachments : String?
    let comments : String?
    let created_at : String?
    let updated_at : String?
    let group : Int?
    let status_note : String?
    let status_changed_by : Int?
    let status_changed_on : String?
    let absence_payment_per_day : Int?
    let leave_type : String?
    let employement_grade : Int?
    let hours : Float?
    let first_name : String?
    let last_name : String?
    let from_date : String?
    let to_date : String?
    let requested_date : String?
    let type : String?
    let user_image : String?
    
    

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case client_id = "client_id"
        case user_id = "user_id"
        case from = "from"
        case to = "to"
        case absence_type = "absence_type"
        case total_days = "total_days"
        case attachments = "attachments"
        case comments = "comments"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case group = "group"
        case status_note = "status_note"
        case status_changed_by = "status_changed_by"
        case status_changed_on = "status_changed_on"
        case absence_payment_per_day = "absence_payment_per_day"
        case leave_type = "leave_type"
        case employement_grade = "employement_grade"
        case hours = "hours"
        case first_name = "first_name"
        case last_name = "last_name"
        case from_date = "from_date"
        case to_date = "to_date"
        case requested_date = "requested_date"
        case type = "type"
        case user_image = "user_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        to = try values.decodeIfPresent(String.self, forKey: .to)
        absence_type = try values.decodeIfPresent(String.self, forKey: .absence_type)
        total_days = try values.decodeIfPresent(Int.self, forKey: .total_days)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        group = try values.decodeIfPresent(Int.self, forKey: .group)
        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
        status_changed_by = try values.decodeIfPresent(Int.self, forKey: .status_changed_by)
        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
        absence_payment_per_day = try values.decodeIfPresent(Int.self, forKey: .absence_payment_per_day)
        leave_type = try values.decodeIfPresent(String.self, forKey: .leave_type)
        employement_grade = try values.decodeIfPresent(Int.self, forKey: .employement_grade)
        hours = try values.decodeIfPresent(Float.self, forKey: .hours)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        from_date = try values.decodeIfPresent(String.self, forKey: .from_date)
        to_date = try values.decodeIfPresent(String.self, forKey: .to_date)
        requested_date = try values.decodeIfPresent(String.self, forKey: .requested_date)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
    }

}

struct createAbsenceModel : Codable {
    let message : String?
    let vacation : AbsenceRows?
}


