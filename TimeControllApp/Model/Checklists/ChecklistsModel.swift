//
//  ChecklistsModel.swift
//  TimeControllApp
//
//  Created by yash on 20/02/23.
//

import Foundation
struct ChecklistsModel : Codable {
    let rows : [ChecklistsRows]?
    let pages : Int?

    enum CodingKeys: String, CodingKey {

        case rows = "rows"
        case pages = "pages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rows = try values.decodeIfPresent([ChecklistsRows].self, forKey: .rows)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
    }

}

struct CheckListCheck : Codable {
    let checklist : ChecklistsRows?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case checklist = "checklist"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checklist = try values.decodeIfPresent(ChecklistsRows.self, forKey: .checklist)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

struct CheckListDetail : Codable {
    let checklist : [ChecklistsRows]?

    enum CodingKeys: String, CodingKey {

        case checklist = "checklist"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checklist = try values.decodeIfPresent([ChecklistsRows].self, forKey: .checklist)
    }

}

struct ChecklistsRows : Codable {
    let id : Int?
    let checklist_templates_id : Int?
    let name : String?
    let status : String?
    let project_id : Int?
    let user_id : Int?
    let client_id : Int?
    let created_by : Int?
    let updated_by : Int?
    let completed_at : String?
    let created_at : String?
    let updated_at : String?
    let status_note : String?
    let status_changed_by : Int?
    let status_changed_on : String?
    let element_data : [Elements]?
    let to_project : Bool?
    let isobligatory : Bool?
    let allow_check_all : Bool?
    let project_name : String?
    let created_by_first_name : String?
    let created_by_last_name : String?
    let first_name : String?
    let last_name : String?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case checklist_templates_id = "checklist_templates_id"
        case name = "name"
        case status = "status"
        case project_id = "project_id"
        case user_id = "user_id"
        case client_id = "client_id"
        case created_by = "created_by"
        case updated_by = "updated_by"
        case completed_at = "completed_at"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case status_note = "status_note"
        case status_changed_by = "status_changed_by"
        case status_changed_on = "status_changed_on"
        case element_data = "element_data"
        case to_project = "to_project"
        case isobligatory = "isobligatory"
        case allow_check_all = "allow_check_all"
        case project_name = "project_name"
        case created_by_first_name = "created_by_first_name"
        case created_by_last_name = "created_by_last_name"
        case first_name = "first_name"
        case last_name = "last_name"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        checklist_templates_id = try values.decodeIfPresent(Int.self, forKey: .checklist_templates_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        created_by = try values.decodeIfPresent(Int.self, forKey: .created_by)
        updated_by = try values.decodeIfPresent(Int.self, forKey: .updated_by)
        completed_at = try values.decodeIfPresent(String.self, forKey: .completed_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
        status_changed_by = try values.decodeIfPresent(Int.self, forKey: .status_changed_by)
        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
        element_data = try values.decodeIfPresent([Elements].self, forKey: .element_data)
        to_project = try values.decodeIfPresent(Bool.self, forKey: .to_project)
        isobligatory = try values.decodeIfPresent(Bool.self, forKey: .isobligatory)
        allow_check_all = try values.decodeIfPresent(Bool.self, forKey: .allow_check_all)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        created_by_first_name = try values.decodeIfPresent(String.self, forKey: .created_by_first_name)
        created_by_last_name = try values.decodeIfPresent(String.self, forKey: .created_by_last_name)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}

//struct Element_data : Codable {
//    let id : Int?
//    let name : String?
//    let parent_id : Int?
//    let client_id : Int?
//    let comment : String?
//    let attachments : String?
//    let created_by : Int?
//    let updated_by : Int?
//    let created_at : String?
//    let updated_at : String?
//    let hints : String?
//    let elements : [Elements]?
//    let siginig_required : Bool?
//    let due_date_required : Bool?
//    let photo_required : Bool?
//    let all_required : Bool?
//    let comment_by_user : String?
//    let attachments_by_user : String?
//    let due_date : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case name = "name"
//        case parent_id = "parent_id"
//        case client_id = "client_id"
//        case comment = "comment"
//        case attachments = "attachments"
//        case created_by = "created_by"
//        case updated_by = "updated_by"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//        case hints = "hints"
//        case elements = "elements"
//        case siginig_required = "siginig_required"
//        case due_date_required = "due_date_required"
//        case photo_required = "photo_required"
//        case all_required = "all_required"
//        case comment_by_user = "comment_by_user"
//        case attachments_by_user = "attachments_by_user"
//        case due_date = "due_date"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        parent_id = try values.decodeIfPresent(Int.self, forKey: .parent_id)
//        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
//        comment = try values.decodeIfPresent(String.self, forKey: .comment)
//        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
//        created_by = try values.decodeIfPresent(Int.self, forKey: .created_by)
//        updated_by = try values.decodeIfPresent(Int.self, forKey: .updated_by)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//        hints = try values.decodeIfPresent(String.self, forKey: .hints)
//        elements = try values.decodeIfPresent([Elements].self, forKey: .elements)
//        siginig_required = try values.decodeIfPresent(Bool.self, forKey: .siginig_required)
//        due_date_required = try values.decodeIfPresent(Bool.self, forKey: .due_date_required)
//        photo_required = try values.decodeIfPresent(Bool.self, forKey: .photo_required)
//        all_required = try values.decodeIfPresent(Bool.self, forKey: .all_required)
//        comment_by_user = try values.decodeIfPresent(String.self, forKey: .comment_by_user)
//        attachments_by_user = try values.decodeIfPresent(String.self, forKey: .attachments_by_user)
//        due_date = try values.decodeIfPresent(String.self, forKey: .due_date)
//    }
//
//}

struct Elements : Codable {
    let id : Int?
    let name : String?
    let parent_id : Int?
    let client_id : Int?
    let comment : String?
    let attachments : String?
    let created_by : Int?
    let updated_by : Int?
    let created_at : String?
    let updated_at : String?
    let hints : String?
    let elements : [Elements]?
    let status : String?
    let updated_by_name : String?
    let comment_by_user : String?
    let attachments_by_user : String?
    let due_date : String?
    let signature : String?
    let siginig_required : Bool?
    let due_date_required : Bool?
    let photo_required : Bool?
    let all_required : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case parent_id = "parent_id"
        case client_id = "client_id"
        case comment = "comment"
        case attachments = "attachments"
        case created_by = "created_by"
        case updated_by = "updated_by"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case hints = "hints"
        case elements = "elements"
        case status = "status"
        case updated_by_name = "updated_by_name"
        case comment_by_user = "comment_by_user"
        case attachments_by_user = "attachments_by_user"
        case due_date = "due_date"
        case signature = "signature"
        case siginig_required = "siginig_required"
        case due_date_required = "due_date_required"
        case photo_required = "photo_required"
        case all_required = "all_required"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        parent_id = try values.decodeIfPresent(Int.self, forKey: .parent_id)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        created_by = try values.decodeIfPresent(Int.self, forKey: .created_by)
        updated_by = try values.decodeIfPresent(Int.self, forKey: .updated_by)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        hints = try values.decodeIfPresent(String.self, forKey: .hints)
        elements = try values.decodeIfPresent([Elements].self, forKey: .elements)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        updated_by_name = try values.decodeIfPresent(String.self, forKey: .updated_by_name)
        comment_by_user = try values.decodeIfPresent(String.self, forKey: .comment_by_user)
        attachments_by_user = try values.decodeIfPresent(String.self, forKey: .attachments_by_user)
        due_date = try values.decodeIfPresent(String.self, forKey: .due_date)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        siginig_required = try values.decodeIfPresent(Bool.self, forKey: .siginig_required)
        due_date_required = try values.decodeIfPresent(Bool.self, forKey: .due_date_required)
        photo_required = try values.decodeIfPresent(Bool.self, forKey: .photo_required)
        all_required = try values.decodeIfPresent(Bool.self, forKey: .all_required)
    }

}
