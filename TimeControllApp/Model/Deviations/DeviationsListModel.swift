//
//  DeviationsListModel.swift
//  TimeControllApp
//
//  Created by prashant on 31/03/23.
//

import Foundation

struct DeviationsListModel : Codable {
    let rows : [DeviationsList]?
    let pages : Int?
    let total : String?
}

struct DeviationsList : Codable {
    let id : Int?
//    let deviation_number : Int?
//    let client_id : Int?
//    let reported_by_id : Int?
//    let assigned_id : Int?
//    let project_id : Int?
//    let task_id : Int?
    let subject : String?
    let due_date : String?
//    let txt_description : String?
//    let txt_cause : String?
//    let txt_consequence : String?
//    let txt_tbd : String?
//    let txt_prevent : String?
//    let txt_fix : String?
//    let deviationsData : DeviationsData?
//    let spent_hours : String?
//    let spent_rate : String?
//    let spent_other : String?
//    let spent_total : Int?
//    let urgency : String?
    let status : String?
//    let status_note : String?
//    let status_changed_by : String?
//    let status_changed_on : String?
//    let attachments : String?
//    let comments : String?
//    let created_at : String?
//    let updated_at : String?
//    let txt_how_to_correct : String?
//    let txt_how_to_stop : String?
//    let model : String?
//    let deviations_type : String?
//    let checklist_id : Int?
//    let element_id : Int?
    let project_name : String?
//    let reporter_name : String?
//    let assigned_name : String?
//    let project_image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
//        case deviation_number = "deviation_number"
//        case client_id = "client_id"
//        case reported_by_id = "reported_by_id"
//        case assigned_id = "assigned_id"
//        case project_id = "project_id"
//        case task_id = "task_id"
        case subject = "subject"
        case due_date = "due_date"
//        case txt_description = "txt_description"
//        case txt_cause = "txt_cause"
//        case txt_consequence = "txt_consequence"
//        case txt_tbd = "txt_tbd"
//        case txt_prevent = "txt_prevent"
//        case txt_fix = "txt_fix"
//        case deviationsData = "data"
//        case spent_hours = "spent_hours"
//        case spent_rate = "spent_rate"
//        case spent_other = "spent_other"
//        case spent_total = "spent_total"
//        case urgency = "urgency"
        case status = "status"
//        case status_note = "status_note"
//        case status_changed_by = "status_changed_by"
//        case status_changed_on = "status_changed_on"
//        case attachments = "attachments"
//        case comments = "comments"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//        case txt_how_to_correct = "txt_how_to_correct"
//        case txt_how_to_stop = "txt_how_to_stop"
//        case model = "model"
//        case deviations_type = "deviations_type"
//        case checklist_id = "checklist_id"
//        case element_id = "element_id"
        case project_name = "project_name"
//        case reporter_name = "reporter_name"
//        case assigned_name = "assigned_name"
//        case project_image = "project_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        deviation_number = try values.decodeIfPresent(Int.self, forKey: .deviation_number)
//        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
//        reported_by_id = try values.decodeIfPresent(Int.self, forKey: .reported_by_id)
//        assigned_id = try values.decodeIfPresent(Int.self, forKey: .assigned_id)
//        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
//        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        subject = try values.decodeIfPresent(String.self, forKey: .subject)
        due_date = try values.decodeIfPresent(String.self, forKey: .due_date)
//        txt_description = try values.decodeIfPresent(String.self, forKey: .txt_description)
//        txt_cause = try values.decodeIfPresent(String.self, forKey: .txt_cause)
//        txt_consequence = try values.decodeIfPresent(String.self, forKey: .txt_consequence)
//        txt_tbd = try values.decodeIfPresent(String.self, forKey: .txt_tbd)
//        txt_prevent = try values.decodeIfPresent(String.self, forKey: .txt_prevent)
//        txt_fix = try values.decodeIfPresent(String.self, forKey: .txt_fix)
//        deviationsData = try values.decodeIfPresent(DeviationsData.self, forKey: .deviationsData)
//        spent_hours = try values.decodeIfPresent(String.self, forKey: .spent_hours)
//        spent_rate = try values.decodeIfPresent(String.self, forKey: .spent_rate)
//        spent_other = try values.decodeIfPresent(String.self, forKey: .spent_other)
//        spent_total = try values.decodeIfPresent(Int.self, forKey: .spent_total)
//        urgency = try values.decodeIfPresent(String.self, forKey: .urgency)
        status = try values.decodeIfPresent(String.self, forKey: .status)
//        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
//        status_changed_by = try values.decodeIfPresent(String.self, forKey: .status_changed_by)
//        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
//        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
//        comments = try values.decodeIfPresent(String.self, forKey: .comments)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//        txt_how_to_correct = try values.decodeIfPresent(String.self, forKey: .txt_how_to_correct)
//        txt_how_to_stop = try values.decodeIfPresent(String.self, forKey: .txt_how_to_stop)
//        model = try values.decodeIfPresent(String.self, forKey: .model)
//        deviations_type = try values.decodeIfPresent(String.self, forKey: .deviations_type)
//        checklist_id = try values.decodeIfPresent(Int.self, forKey: .checklist_id)
//        element_id = try values.decodeIfPresent(Int.self, forKey: .element_id)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
//        reporter_name = try values.decodeIfPresent(String.self, forKey: .reporter_name)
//        assigned_name = try values.decodeIfPresent(String.self, forKey: .assigned_name)
//        project_image = try values.decodeIfPresent(String.self, forKey: .project_image)
    }
}

struct DeviationsData : Codable {
    let history : [HistoryData]?

    enum CodingKeys: String, CodingKey {

        case history = "history"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        history = try values.decodeIfPresent([HistoryData].self, forKey: .history)
    }
}

struct HistoryData : Codable {
    let timestamp : String?
    let user : UserDeviationData?
    let transition : String?
//    let params : Params?

    enum CodingKeys: String, CodingKey {

        case timestamp = "timestamp"
        case user = "user"
        case transition = "transition"
//        case params = "params"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        user = try values.decodeIfPresent(UserDeviationData.self, forKey: .user)
        transition = try values.decodeIfPresent(String.self, forKey: .transition)
//        params = try values.decodeIfPresent(Params.self, forKey: .params)
    }
}

//struct Params : Codable {
//
//    enum CodingKeys: String, CodingKey {
//
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//    }
//
//}

struct UserDeviationData : Codable {
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
