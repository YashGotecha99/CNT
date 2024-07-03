//
//  VacationListModel.swift
//  TimeControllApp
//
//  Created by yash on 03/02/23.
//

import Foundation

struct VacationListModel : Codable {
    let rows : [VacationRows]?
    let pages : Int?

    enum CodingKeys: String, CodingKey {

        case rows = "rows"
        case pages = "pages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rows = try values.decodeIfPresent([VacationRows].self, forKey: .rows)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
    }

}

struct VacationRows : Codable {
    let id : Int?
    var status : String?
    let client_id : Int?
    let user_id : Int?
    let from : String?
    let to : String?
    let vacation_type : String?
    let total_days : Int?
    let attachments : String?
    let comments : String?
    let created_at : String?
    let updated_at : String?
    let project_id : String?
    let status_note : String?
    let status_changed_by : Int?
    let status_changed_on : String?
    let first_name : String?
    let last_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case client_id = "client_id"
        case user_id = "user_id"
        case from = "from"
        case to = "to"
        case vacation_type = "vacation_type"
        case total_days = "total_days"
        case attachments = "attachments"
        case comments = "comments"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case project_id = "project_id"
        case status_note = "status_note"
        case status_changed_by = "status_changed_by"
        case status_changed_on = "status_changed_on"
        case first_name = "first_name"
        case last_name = "last_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        to = try values.decodeIfPresent(String.self, forKey: .to)
        vacation_type = try values.decodeIfPresent(String.self, forKey: .vacation_type)
        total_days = try values.decodeIfPresent(Int.self, forKey: .total_days)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        project_id = try values.decodeIfPresent(String.self, forKey: .project_id)
        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
        status_changed_by = try values.decodeIfPresent(Int.self, forKey: .status_changed_by)
        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
    }

}

struct createVacationModel : Codable {
    let message : String?
    let vacation : VacationRows?
}
