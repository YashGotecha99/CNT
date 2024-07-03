//
//  TasksModel.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 06/11/22.
//

import Foundation

struct TasksModel : Codable {
    let rows : [TaskRows]?
    let pages : Int?

    enum CodingKeys: String, CodingKey {

        case rows = "rows"
        case pages = "pages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rows = try values.decodeIfPresent([TaskRows].self, forKey: .rows)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
    }

}


struct TaskData : Codable {
    let require_hms : Bool?
    let security_analyze : Bool?
    let addressCache : String?

    enum CodingKeys: String, CodingKey {

        case require_hms = "require_hms"
        case security_analyze = "security_analyze"
        case addressCache = "addressCache"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        require_hms = try values.decodeIfPresent(Bool.self, forKey: .require_hms)
        security_analyze = try values.decodeIfPresent(Bool.self, forKey: .security_analyze)
        addressCache = try values.decodeIfPresent(String.self, forKey: .addressCache)
    }

}


struct TaskRows : Codable {
    let id : Int?
    let status : String?
    let client_id : Int?
    let project_id : Int?
    let parent_id : String?
    let task_type : String?
    let task_number : Int?
    let user_id : String?
    let assignee_id : Int?
    let contact_person : String?
    let title : String?
    let name : String?
    let post_place : String?
    let post_number : String?
    let address : String?
    let g_nr : String?
    let b_nr : String?
    let email : String?
    let phone : String?
    let data : TaskData?
    let attachments : String?
    let est_hours : Int?
    let est_work : String?
    let start_date : String?
    let end_date : String?
    let start_time : Int?
    let end_time : Int?
    let description : String?
    let created_at : String?
    let updated_at : String?
    let auto_log_on_days : String?
    let gps_data : String?
    let scheduled_days : String?
    let is_default_for_project : Bool?
    let project_name : String?
    let project_image : String?
    let total_hours : Int?
    let user_name : String?
//    let assigned_users : [Int]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case client_id = "client_id"
        case project_id = "project_id"
        case parent_id = "parent_id"
        case task_type = "task_type"
        case task_number = "task_number"
        case user_id = "user_id"
        case assignee_id = "assignee_id"
        case contact_person = "contact_person"
        case title = "title"
        case name = "name"
        case post_place = "post_place"
        case post_number = "post_number"
        case address = "address"
        case g_nr = "g_nr"
        case b_nr = "b_nr"
        case email = "email"
        case phone = "phone"
        case data = "data"
        case attachments = "attachments"
        case est_hours = "est_hours"
        case est_work = "est_work"
        case start_date = "start_date"
        case end_date = "end_date"
        case start_time = "start_time"
        case end_time = "end_time"
        case description = "description"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case auto_log_on_days = "auto_log_on_days"
        case gps_data = "gps_data"
        case scheduled_days = "scheduled_days"
        case is_default_for_project = "is_default_for_project"
        case project_name = "project_name"
        case project_image = "project_image"
        case total_hours = "total_hours"
        case user_name = "user_name"
//        case assigned_users = "assigned_users"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        parent_id = try values.decodeIfPresent(String.self, forKey: .parent_id)
        task_type = try values.decodeIfPresent(String.self, forKey: .task_type)
        task_number = try values.decodeIfPresent(Int.self, forKey: .task_number)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
        contact_person = try values.decodeIfPresent(String.self, forKey: .contact_person)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        g_nr = try values.decodeIfPresent(String.self, forKey: .g_nr)
        b_nr = try values.decodeIfPresent(String.self, forKey: .b_nr)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        data = try values.decodeIfPresent(TaskData.self, forKey: .data)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        est_hours = try values.decodeIfPresent(Int.self, forKey: .est_hours)
        est_work = try values.decodeIfPresent(String.self, forKey: .est_work)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        auto_log_on_days = try values.decodeIfPresent(String.self, forKey: .auto_log_on_days)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        scheduled_days = try values.decodeIfPresent(String.self, forKey: .scheduled_days)
        is_default_for_project = try values.decodeIfPresent(Bool.self, forKey: .is_default_for_project)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        project_image = try values.decodeIfPresent(String.self, forKey: .project_image)
        total_hours = try values.decodeIfPresent(Int.self, forKey: .total_hours)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
//        assigned_users = try values.decodeIfPresent([Int].self, forKey: .assigned_users)
    }

}

struct LookupTasks : Codable {
    let id : Int?
    let name : String?
    let address : String?
    let start_time : Int?
    let end_time : Int?
    let gps_data : String?
    let description : String?
//    let is_default_for_project : String?
    let project_id : Int?
    let project_name : String?
//    let assigned_users : [String]?
//    let scheduled : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case address = "address"
        case start_time = "start_time"
        case end_time = "end_time"
        case gps_data = "gps_data"
        case description = "description"
//        case is_default_for_project = "is_default_for_project"
        case project_id = "project_id"
        case project_name = "project_name"
//        case assigned_users = "assigned_users"
//        case scheduled = "scheduled"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        description = try values.decodeIfPresent(String.self, forKey: .description)
//        is_default_for_project = try values.decodeIfPresent(String.self, forKey: .is_default_for_project)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
//        assigned_users = try values.decodeIfPresent([String].self, forKey: .assigned_users)
//        scheduled = try values.decodeIfPresent(String.self, forKey: .scheduled)
    }

}
