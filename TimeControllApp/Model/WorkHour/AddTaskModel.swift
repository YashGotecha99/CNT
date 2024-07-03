//
//  AddTaskModel.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 14/11/22.
//

import Foundation


struct AddTaskModel : Codable {
    let message : String?
    let task : AddTask?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case task = "task"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        task = try values.decodeIfPresent(AddTask.self, forKey: .task)
    }

}


struct AddTaskMembers : Codable {
    let id : Int?
    let task_id : Int?
    let user_id : Int?
    let hours : Int?
    let timeframe : String?
  //  let data : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case task_id = "task_id"
        case user_id = "user_id"
        case hours = "hours"
        case timeframe = "timeframe"
    //    case data = "data"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        hours = try values.decodeIfPresent(Int.self, forKey: .hours)
        timeframe = try values.decodeIfPresent(String.self, forKey: .timeframe)
  //      data = try values.decodeIfPresent(String.self, forKey: .data)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

struct AddTaskProject : Codable {
    let id : Int?
    let status : String?
    let image : String?
    let project_number : Int?
    let assignee_id : Int?
    let parent_id : String?
    let project_type : String?
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
    let description : String?
    let est_hours : String?
    let est_work : String?
    let gps_data : String?
    let data : AddTaskData?
    let attachments : String?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
    let user_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case image = "image"
        case project_number = "project_number"
        case assignee_id = "assignee_id"
        case parent_id = "parent_id"
        case project_type = "project_type"
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
        case description = "description"
        case est_hours = "est_hours"
        case est_work = "est_work"
        case gps_data = "gps_data"
        case data = "data"
        case attachments = "attachments"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
        case user_id = "user_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        project_number = try values.decodeIfPresent(Int.self, forKey: .project_number)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
        parent_id = try values.decodeIfPresent(String.self, forKey: .parent_id)
        project_type = try values.decodeIfPresent(String.self, forKey: .project_type)
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
        description = try values.decodeIfPresent(String.self, forKey: .description)
        est_hours = try values.decodeIfPresent(String.self, forKey: .est_hours)
        est_work = try values.decodeIfPresent(String.self, forKey: .est_work)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        data = try values.decodeIfPresent(AddTaskData.self, forKey: .data)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
    }

}


struct AddTaskData : Codable {
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


struct AddTask : Codable {
    let id : Int?
    let status : String?
    let task_number : Int?
    let assignee_id : Int?
//    let parent_id : String?
//    let task_type : String?
//    let contact_person : String?
//    let title : String?
//    let name : String?
//    let is_default_for_project : String?
//    let post_place : String?
//    let post_number : String?
//    let address : String?
//    let g_nr : String?
//    let b_nr : String?
//    let email : String?
//    let phone : String?
//    let description : String?
//    let est_hours : String?
//    let est_work : String?
//    let data : Data?
//    let start_date : String?
//    let end_date : String?
//    let start_time : Int?
//    let end_time : Int?
////    let attachments : String?
//    let auto_log_on_days : String?
//    let gps_data : String?
//    let scheduled_days : String?
//    let createdAt : String?
//    let updatedAt : String?
//    let client_id : Int?
//    let project_id : Int?
//    let members : [AddTaskMembers]?
//    let attachments : [String]?
//    let project : AddTaskProject?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case task_number = "task_number"
        case assignee_id = "assignee_id"
//        case parent_id = "parent_id"
//        case task_type = "task_type"
//        case contact_person = "contact_person"
//        case title = "title"
//        case name = "name"
//        case is_default_for_project = "is_default_for_project"
//        case post_place = "post_place"
//        case post_number = "post_number"
//        case address = "address"
//        case g_nr = "g_nr"
//        case b_nr = "b_nr"
//        case email = "email"
//        case phone = "phone"
//        case description = "description"
//        case est_hours = "est_hours"
//        case est_work = "est_work"
//        case data = "data"
//        case start_date = "start_date"
//        case end_date = "end_date"
//        case start_time = "start_time"
//        case end_time = "end_time"
//    //    case attachments = "attachments"
//        case auto_log_on_days = "auto_log_on_days"
//        case gps_data = "gps_data"
//        case scheduled_days = "scheduled_days"
//        case createdAt = "createdAt"
//        case updatedAt = "updatedAt"
//        case client_id = "client_id"
//        case project_id = "project_id"
//        case members = "Members"
//        case attachments = "Attachments"
//        case project = "Project"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        task_number = try values.decodeIfPresent(Int.self, forKey: .task_number)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
//        parent_id = try values.decodeIfPresent(String.self, forKey: .parent_id)
//        task_type = try values.decodeIfPresent(String.self, forKey: .task_type)
//        contact_person = try values.decodeIfPresent(String.self, forKey: .contact_person)
//        title = try values.decodeIfPresent(String.self, forKey: .title)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        is_default_for_project = try values.decodeIfPresent(String.self, forKey: .is_default_for_project)
//        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
//        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
//        address = try values.decodeIfPresent(String.self, forKey: .address)
//        g_nr = try values.decodeIfPresent(String.self, forKey: .g_nr)
//        b_nr = try values.decodeIfPresent(String.self, forKey: .b_nr)
//        email = try values.decodeIfPresent(String.self, forKey: .email)
//        phone = try values.decodeIfPresent(String.self, forKey: .phone)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        est_hours = try values.decodeIfPresent(String.self, forKey: .est_hours)
//        est_work = try values.decodeIfPresent(String.self, forKey: .est_work)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
//        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
//        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
//        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
//        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
//    //    attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
//        auto_log_on_days = try values.decodeIfPresent(String.self, forKey: .auto_log_on_days)
//        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
//        scheduled_days = try values.decodeIfPresent(String.self, forKey: .scheduled_days)
//        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
//        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
//        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
//        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
//        members = try values.decodeIfPresent([AddTaskMembers].self, forKey: .members)
//        attachments = try values.decodeIfPresent([String].self, forKey: .attachments)
//        project = try values.decodeIfPresent(AddTaskProject.self, forKey: .project)
    }

}
