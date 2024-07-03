//
//  DeviationsDetailsModel.swift
//  TimeControllApp
//
//  Created by prashant on 03/04/23.
//

import Foundation

struct DeviationsDetailsModel : Codable {
    let deviation : DeviationDetails?
}

struct DeviationDetails : Codable {
    let id : Int?
    let reported_by_id : Int?
    let assigned_id : Int?
    let project_id : Int?
    let deviation_number : Int?
    let task_id : Int?
    var subject : String?
    var due_date : String?
    var comments : String?
    let txt_description : String?
    var txt_cause : String?
    var txt_consequence : String?
    var txt_tbd : String?
    var txt_prevent : String?
    var txt_fix : String?
    var txt_how_to_correct : String?
    var txt_how_to_stop : String?
    var spent_hours : Int?
    var spent_rate : Int?
    var spent_other : Int?
    var spent_total : Int?
    var urgency : String?
    let status : String?
    let status_note : String?
    let status_changed_by : String?
    let status_changed_on : String?
    let attachments : String?
    let data : DeviationsDetailsData?
    let deviations_type : String?
    let checklist_id : Int?
    let element_id : Int?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
    var deviationAttachments : [DeviationsAttachments]?
    let project : DeviationsProject?
    let task : DeviationsTask?
    let pM : PM?
    var assignee : Assignee?
    let reporter : Reporter?
    let transitions : [Transitions]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case reported_by_id = "reported_by_id"
        case assigned_id = "assigned_id"
        case project_id = "project_id"
        case deviation_number = "deviation_number"
        case task_id = "task_id"
        case subject = "subject"
        case due_date = "due_date"
        case comments = "comments"
        case txt_description = "txt_description"
        case txt_cause = "txt_cause"
        case txt_consequence = "txt_consequence"
        case txt_tbd = "txt_tbd"
        case txt_prevent = "txt_prevent"
        case txt_fix = "txt_fix"
        case txt_how_to_correct = "txt_how_to_correct"
        case txt_how_to_stop = "txt_how_to_stop"
        case spent_hours = "spent_hours"
        case spent_rate = "spent_rate"
        case spent_other = "spent_other"
        case spent_total = "spent_total"
        case urgency = "urgency"
        case status = "status"
        case status_note = "status_note"
        case status_changed_by = "status_changed_by"
        case status_changed_on = "status_changed_on"
        case attachments = "attachments"
        case data = "data"
        case deviations_type = "deviations_type"
        case checklist_id = "checklist_id"
        case element_id = "element_id"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
        case deviationAttachments = "Attachments"
        case project = "Project"
        case task = "Task"
        case pM = "PM"
        case assignee = "Assignee"
        case reporter = "Reporter"
        case transitions = "Transitions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        reported_by_id = try values.decodeIfPresent(Int.self, forKey: .reported_by_id)
        assigned_id = try values.decodeIfPresent(Int.self, forKey: .assigned_id)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        deviation_number = try values.decodeIfPresent(Int.self, forKey: .deviation_number)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        subject = try values.decodeIfPresent(String.self, forKey: .subject)
        due_date = try values.decodeIfPresent(String.self, forKey: .due_date)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        txt_description = try values.decodeIfPresent(String.self, forKey: .txt_description)
        txt_cause = try values.decodeIfPresent(String.self, forKey: .txt_cause)
        txt_consequence = try values.decodeIfPresent(String.self, forKey: .txt_consequence)
        txt_tbd = try values.decodeIfPresent(String.self, forKey: .txt_tbd)
        txt_prevent = try values.decodeIfPresent(String.self, forKey: .txt_prevent)
        txt_fix = try values.decodeIfPresent(String.self, forKey: .txt_fix)
        txt_how_to_correct = try values.decodeIfPresent(String.self, forKey: .txt_how_to_correct)
        txt_how_to_stop = try values.decodeIfPresent(String.self, forKey: .txt_how_to_stop)
        spent_hours = try values.decodeIfPresent(Int.self, forKey: .spent_hours)
        spent_rate = try values.decodeIfPresent(Int.self, forKey: .spent_rate)
        spent_other = try values.decodeIfPresent(Int.self, forKey: .spent_other)
        spent_total = try values.decodeIfPresent(Int.self, forKey: .spent_total)
        urgency = try values.decodeIfPresent(String.self, forKey: .urgency)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
        status_changed_by = try values.decodeIfPresent(String.self, forKey: .status_changed_by)
        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        data = try values.decodeIfPresent(DeviationsDetailsData.self, forKey: .data)
        deviations_type = try values.decodeIfPresent(String.self, forKey: .deviations_type)
        checklist_id = try values.decodeIfPresent(Int.self, forKey: .checklist_id)
        element_id = try values.decodeIfPresent(Int.self, forKey: .element_id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        deviationAttachments = try values.decodeIfPresent([DeviationsAttachments].self, forKey: .deviationAttachments)
        project = try values.decodeIfPresent(DeviationsProject.self, forKey: .project)
        task = try values.decodeIfPresent(DeviationsTask.self, forKey: .task)
        pM = try values.decodeIfPresent(PM.self, forKey: .pM)
        assignee = try values.decodeIfPresent(Assignee.self, forKey: .assignee)
        reporter = try values.decodeIfPresent(Reporter.self, forKey: .reporter)
        transitions = try values.decodeIfPresent([Transitions].self, forKey: .transitions)
    }

}

struct DeviationsDetailsData : Codable {
    let history : [DeviationsHistory]?

    enum CodingKeys: String, CodingKey {

        case history = "history"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        history = try values.decodeIfPresent([DeviationsHistory].self, forKey: .history)
    }
    
}

struct DeviationsHistory : Codable {
    let timestamp : String?
    let user : DeviationsUser?
//    let transition : String?
    let transitionState : String?

    enum CodingKeys: String, CodingKey {

        case timestamp = "timestamp"
        case user = "user"
//        case transition = "transition"'
        case transitionState = "transitionState"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        user = try values.decodeIfPresent(DeviationsUser.self, forKey: .user)
//        transition = try values.decodeIfPresent(String.self, forKey: .transition)
        transitionState = try values.decodeIfPresent(String.self, forKey: .transitionState)
    }

}

struct DeviationsUser : Codable {
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

struct DeviationsAttachments : Codable {
    var id : Int?
    var filename : String?
    var filetype : String?
    var user_id : Int?
    var location : String?
    var to_model : String?
    var to_id : Int?
//    let data : Data?
    var created_at : String?
    var updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case filename = "filename"
        case filetype = "filetype"
        case user_id = "user_id"
        case location = "location"
        case to_model = "to_model"
        case to_id = "to_id"
//        case data = "data"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        filename = try values.decodeIfPresent(String.self, forKey: .filename)
        filetype = try values.decodeIfPresent(String.self, forKey: .filetype)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        to_model = try values.decodeIfPresent(String.self, forKey: .to_model)
        to_id = try values.decodeIfPresent(Int.self, forKey: .to_id)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}


//struct DeviationsDetailsData : Codable {
//    let kids : [String]?
//    let is_single_parent : Bool?
//    let nomines : [String]?
//    let enable_pause_button : Bool?
//    let disable_manual_log : Bool?
//    let lang : String?
//    let lastNotificationTime : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case kids = "kids"
//        case is_single_parent = "is_single_parent"
//        case nomines = "nomines"
//        case enable_pause_button = "enable_pause_button"
//        case disable_manual_log = "disable_manual_log"
//        case lang = "lang"
//        case lastNotificationTime = "lastNotificationTime"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        kids = try values.decodeIfPresent([String].self, forKey: .kids)
//        is_single_parent = try values.decodeIfPresent(Bool.self, forKey: .is_single_parent)
//        nomines = try values.decodeIfPresent([String].self, forKey: .nomines)
//        enable_pause_button = try values.decodeIfPresent(Bool.self, forKey: .enable_pause_button)
//        disable_manual_log = try values.decodeIfPresent(Bool.self, forKey: .disable_manual_log)
//        lang = try values.decodeIfPresent(String.self, forKey: .lang)
//        lastNotificationTime = try values.decodeIfPresent(String.self, forKey: .lastNotificationTime)
//    }
//
//}

struct DeviationsTask : Codable {
    let id : Int?
    let status : String?
    let task_number : Int?
    let assignee_id : Int?
    let parent_id : String?
    let task_type : String?
    let contact_person : String?
    let title : String?
    let name : String?
    let is_default_for_project : Bool?
    let post_place : String?
    let post_number : String?
    let address : String?
    let g_nr : String?
    let b_nr : String?
    let email : String?
    let phone : String?
    let description : String?
    let est_hours : Int?
    let est_work : String?
    let data : DeviationsTaskData?
    let start_date : String?
    let end_date : String?
    let start_time : Int?
    let end_time : Int?
    let attachments : String?
    let auto_log_on_days : String?
    let gps_data : String?
    let scheduled_days : String?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
    let project_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case task_number = "task_number"
        case assignee_id = "assignee_id"
        case parent_id = "parent_id"
        case task_type = "task_type"
        case contact_person = "contact_person"
        case title = "title"
        case name = "name"
        case is_default_for_project = "is_default_for_project"
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
        case data = "data"
        case start_date = "start_date"
        case end_date = "end_date"
        case start_time = "start_time"
        case end_time = "end_time"
        case attachments = "attachments"
        case auto_log_on_days = "auto_log_on_days"
        case gps_data = "gps_data"
        case scheduled_days = "scheduled_days"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
        case project_id = "project_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        task_number = try values.decodeIfPresent(Int.self, forKey: .task_number)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
        parent_id = try values.decodeIfPresent(String.self, forKey: .parent_id)
        task_type = try values.decodeIfPresent(String.self, forKey: .task_type)
        contact_person = try values.decodeIfPresent(String.self, forKey: .contact_person)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        is_default_for_project = try values.decodeIfPresent(Bool.self, forKey: .is_default_for_project)
        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        g_nr = try values.decodeIfPresent(String.self, forKey: .g_nr)
        b_nr = try values.decodeIfPresent(String.self, forKey: .b_nr)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        est_hours = try values.decodeIfPresent(Int.self, forKey: .est_hours)
        est_work = try values.decodeIfPresent(String.self, forKey: .est_work)
        data = try values.decodeIfPresent(DeviationsTaskData.self, forKey: .data)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        auto_log_on_days = try values.decodeIfPresent(String.self, forKey: .auto_log_on_days)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        scheduled_days = try values.decodeIfPresent(String.self, forKey: .scheduled_days)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
    }

}

struct DeviationsTaskData : Codable {
    let addressCache : String?

    enum CodingKeys: String, CodingKey {

        case addressCache = "addressCache"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addressCache = try values.decodeIfPresent(String.self, forKey: .addressCache)
    }
}

struct DeviationsProject : Codable {
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
    let data : DeviationsProjectData?
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
        data = try values.decodeIfPresent(DeviationsProjectData.self, forKey: .data)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
    }

}


struct DeviationsProjectData : Codable {
    let addressCache : String?

    enum CodingKeys: String, CodingKey {

        case addressCache = "addressCache"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addressCache = try values.decodeIfPresent(String.self, forKey: .addressCache)
    }
}

struct PM : Codable {
    let id : Int?
    let image : String?
    let status : String?
    let added : String?
    let username : String?
    let hash : String?
    let salt : String?
    let user_type : String?
    let first_name : String?
    let last_name : String?
//    let internal_number : String?
    let email : String?
    let employee_percent : String?
    let address : String?
    let post_number : String?
    let post_place : String?
    let title : String?
    let full_name : String?
    let phone : String?
    let g_nr : String?
    let b_nr : String?
    let description : String?
    let timelog_start_from : String?
    let timelog_last_filled : String?
    let birthday : String?
    let generic_login : String?
    let generic_pin : String?
//    let is_now_locked : String?
    let social_number : String?
    let social_hash : String?
    let attachments : String?
    let disable_autolog : Bool?
    let vacation_days : Int?
    let payment_mode : String?
    let hourly_rate : Int?
    let allow_tip : Bool?
    let employee_type : String?
//    let data : Data?
    let home_payment_enabled : Bool?
    let reset_pwd_otp : String?
    let gps_data : String?
    let register_type : String?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case image = "image"
        case status = "status"
        case added = "added"
        case username = "username"
        case hash = "hash"
        case salt = "salt"
        case user_type = "user_type"
        case first_name = "first_name"
        case last_name = "last_name"
//        case internal_number = "internal_number"
        case email = "email"
        case employee_percent = "employee_percent"
        case address = "address"
        case post_number = "post_number"
        case post_place = "post_place"
        case title = "title"
        case full_name = "full_name"
        case phone = "phone"
        case g_nr = "g_nr"
        case b_nr = "b_nr"
        case description = "description"
        case timelog_start_from = "timelog_start_from"
        case timelog_last_filled = "timelog_last_filled"
        case birthday = "birthday"
        case generic_login = "generic_login"
        case generic_pin = "generic_pin"
//        case is_now_locked = "is_now_locked"
        case social_number = "social_number"
        case social_hash = "social_hash"
        case attachments = "attachments"
        case disable_autolog = "disable_autolog"
        case vacation_days = "vacation_days"
        case payment_mode = "payment_mode"
        case hourly_rate = "hourly_rate"
        case allow_tip = "allow_tip"
        case employee_type = "employee_type"
//        case data = "data"
        case home_payment_enabled = "home_payment_enabled"
        case reset_pwd_otp = "reset_pwd_otp"
        case gps_data = "gps_data"
        case register_type = "register_type"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        added = try values.decodeIfPresent(String.self, forKey: .added)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        hash = try values.decodeIfPresent(String.self, forKey: .hash)
        salt = try values.decodeIfPresent(String.self, forKey: .salt)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
//        internal_number = try values.decodeIfPresent(String.self, forKey: .internal_number)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        employee_percent = try values.decodeIfPresent(String.self, forKey: .employee_percent)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        g_nr = try values.decodeIfPresent(String.self, forKey: .g_nr)
        b_nr = try values.decodeIfPresent(String.self, forKey: .b_nr)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        timelog_start_from = try values.decodeIfPresent(String.self, forKey: .timelog_start_from)
        timelog_last_filled = try values.decodeIfPresent(String.self, forKey: .timelog_last_filled)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
        generic_login = try values.decodeIfPresent(String.self, forKey: .generic_login)
        generic_pin = try values.decodeIfPresent(String.self, forKey: .generic_pin)
//        is_now_locked = try values.decodeIfPresent(String.self, forKey: .is_now_locked)
        social_number = try values.decodeIfPresent(String.self, forKey: .social_number)
        social_hash = try values.decodeIfPresent(String.self, forKey: .social_hash)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        disable_autolog = try values.decodeIfPresent(Bool.self, forKey: .disable_autolog)
        vacation_days = try values.decodeIfPresent(Int.self, forKey: .vacation_days)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        hourly_rate = try values.decodeIfPresent(Int.self, forKey: .hourly_rate)
        allow_tip = try values.decodeIfPresent(Bool.self, forKey: .allow_tip)
        employee_type = try values.decodeIfPresent(String.self, forKey: .employee_type)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
        home_payment_enabled = try values.decodeIfPresent(Bool.self, forKey: .home_payment_enabled)
        reset_pwd_otp = try values.decodeIfPresent(String.self, forKey: .reset_pwd_otp)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        register_type = try values.decodeIfPresent(String.self, forKey: .register_type)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
    }

}

struct Assignee : Codable {
    var id : Int?
    let image : String?
    let status : String?
    let added : String?
    let username : String?
    let hash : String?
    let salt : String?
    let user_type : String?
    let first_name : String?
    let last_name : String?
//    let internal_number : String?
    let email : String?
    let employee_percent : String?
    let address : String?
    let post_number : String?
    let post_place : String?
    let title : String?
    let full_name : String?
    let phone : String?
    let g_nr : String?
    let b_nr : String?
    let description : String?
    let timelog_start_from : String?
    let timelog_last_filled : String?
    let birthday : String?
    let generic_login : String?
    let generic_pin : String?
//    let is_now_locked : String?
    let social_number : String?
    let social_hash : String?
    let attachments : String?
    let disable_autolog : Bool?
    let vacation_days : Int?
    let payment_mode : String?
    let hourly_rate : Int?
    let allow_tip : Bool?
    let employee_type : String?
//    let data : Data?
    let home_payment_enabled : Bool?
    let reset_pwd_otp : String?
    let gps_data : String?
    let register_type : String?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case image = "image"
        case status = "status"
        case added = "added"
        case username = "username"
        case hash = "hash"
        case salt = "salt"
        case user_type = "user_type"
        case first_name = "first_name"
        case last_name = "last_name"
//        case internal_number = "internal_number"
        case email = "email"
        case employee_percent = "employee_percent"
        case address = "address"
        case post_number = "post_number"
        case post_place = "post_place"
        case title = "title"
        case full_name = "full_name"
        case phone = "phone"
        case g_nr = "g_nr"
        case b_nr = "b_nr"
        case description = "description"
        case timelog_start_from = "timelog_start_from"
        case timelog_last_filled = "timelog_last_filled"
        case birthday = "birthday"
        case generic_login = "generic_login"
        case generic_pin = "generic_pin"
//        case is_now_locked = "is_now_locked"
        case social_number = "social_number"
        case social_hash = "social_hash"
        case attachments = "attachments"
        case disable_autolog = "disable_autolog"
        case vacation_days = "vacation_days"
        case payment_mode = "payment_mode"
        case hourly_rate = "hourly_rate"
        case allow_tip = "allow_tip"
        case employee_type = "employee_type"
//        case data = "data"
        case home_payment_enabled = "home_payment_enabled"
        case reset_pwd_otp = "reset_pwd_otp"
        case gps_data = "gps_data"
        case register_type = "register_type"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        added = try values.decodeIfPresent(String.self, forKey: .added)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        hash = try values.decodeIfPresent(String.self, forKey: .hash)
        salt = try values.decodeIfPresent(String.self, forKey: .salt)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
//        internal_number = try values.decodeIfPresent(String.self, forKey: .internal_number)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        employee_percent = try values.decodeIfPresent(String.self, forKey: .employee_percent)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        g_nr = try values.decodeIfPresent(String.self, forKey: .g_nr)
        b_nr = try values.decodeIfPresent(String.self, forKey: .b_nr)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        timelog_start_from = try values.decodeIfPresent(String.self, forKey: .timelog_start_from)
        timelog_last_filled = try values.decodeIfPresent(String.self, forKey: .timelog_last_filled)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
        generic_login = try values.decodeIfPresent(String.self, forKey: .generic_login)
        generic_pin = try values.decodeIfPresent(String.self, forKey: .generic_pin)
//        is_now_locked = try values.decodeIfPresent(String.self, forKey: .is_now_locked)
        social_number = try values.decodeIfPresent(String.self, forKey: .social_number)
        social_hash = try values.decodeIfPresent(String.self, forKey: .social_hash)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        disable_autolog = try values.decodeIfPresent(Bool.self, forKey: .disable_autolog)
        vacation_days = try values.decodeIfPresent(Int.self, forKey: .vacation_days)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        hourly_rate = try values.decodeIfPresent(Int.self, forKey: .hourly_rate)
        allow_tip = try values.decodeIfPresent(Bool.self, forKey: .allow_tip)
        employee_type = try values.decodeIfPresent(String.self, forKey: .employee_type)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
        home_payment_enabled = try values.decodeIfPresent(Bool.self, forKey: .home_payment_enabled)
        reset_pwd_otp = try values.decodeIfPresent(String.self, forKey: .reset_pwd_otp)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        register_type = try values.decodeIfPresent(String.self, forKey: .register_type)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
    }

}

struct Reporter : Codable {
    let id : Int?
    let image : String?
    let status : String?
    let added : String?
    let username : String?
    let hash : String?
    let salt : String?
    let user_type : String?
    let first_name : String?
    let last_name : String?
//    let internal_number : String?
    let email : String?
    let employee_percent : String?
    let address : String?
    let post_number : String?
    let post_place : String?
    let title : String?
    let full_name : String?
    let phone : String?
    let g_nr : String?
    let b_nr : String?
    let description : String?
    let timelog_start_from : String?
    let timelog_last_filled : String?
    let birthday : String?
    let generic_login : String?
    let generic_pin : String?
//    let is_now_locked : String?
    let social_number : String?
    let social_hash : String?
    let attachments : String?
    let disable_autolog : Bool?
    let vacation_days : Int?
    let payment_mode : String?
    let hourly_rate : Int?
    let allow_tip : Bool?
    let employee_type : String?
//    let data : Data?
    let home_payment_enabled : Bool?
    let reset_pwd_otp : String?
    let gps_data : String?
    let register_type : String?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case image = "image"
        case status = "status"
        case added = "added"
        case username = "username"
        case hash = "hash"
        case salt = "salt"
        case user_type = "user_type"
        case first_name = "first_name"
        case last_name = "last_name"
//        case internal_number = "internal_number"
        case email = "email"
        case employee_percent = "employee_percent"
        case address = "address"
        case post_number = "post_number"
        case post_place = "post_place"
        case title = "title"
        case full_name = "full_name"
        case phone = "phone"
        case g_nr = "g_nr"
        case b_nr = "b_nr"
        case description = "description"
        case timelog_start_from = "timelog_start_from"
        case timelog_last_filled = "timelog_last_filled"
        case birthday = "birthday"
        case generic_login = "generic_login"
        case generic_pin = "generic_pin"
//        case is_now_locked = "is_now_locked"
        case social_number = "social_number"
        case social_hash = "social_hash"
        case attachments = "attachments"
        case disable_autolog = "disable_autolog"
        case vacation_days = "vacation_days"
        case payment_mode = "payment_mode"
        case hourly_rate = "hourly_rate"
        case allow_tip = "allow_tip"
        case employee_type = "employee_type"
//        case data = "data"
        case home_payment_enabled = "home_payment_enabled"
        case reset_pwd_otp = "reset_pwd_otp"
        case gps_data = "gps_data"
        case register_type = "register_type"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        added = try values.decodeIfPresent(String.self, forKey: .added)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        hash = try values.decodeIfPresent(String.self, forKey: .hash)
        salt = try values.decodeIfPresent(String.self, forKey: .salt)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
//        internal_number = try values.decodeIfPresent(String.self, forKey: .internal_number)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        employee_percent = try values.decodeIfPresent(String.self, forKey: .employee_percent)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        g_nr = try values.decodeIfPresent(String.self, forKey: .g_nr)
        b_nr = try values.decodeIfPresent(String.self, forKey: .b_nr)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        timelog_start_from = try values.decodeIfPresent(String.self, forKey: .timelog_start_from)
        timelog_last_filled = try values.decodeIfPresent(String.self, forKey: .timelog_last_filled)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
        generic_login = try values.decodeIfPresent(String.self, forKey: .generic_login)
        generic_pin = try values.decodeIfPresent(String.self, forKey: .generic_pin)
//        is_now_locked = try values.decodeIfPresent(String.self, forKey: .is_now_locked)
        social_number = try values.decodeIfPresent(String.self, forKey: .social_number)
        social_hash = try values.decodeIfPresent(String.self, forKey: .social_hash)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        disable_autolog = try values.decodeIfPresent(Bool.self, forKey: .disable_autolog)
        vacation_days = try values.decodeIfPresent(Int.self, forKey: .vacation_days)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        hourly_rate = try values.decodeIfPresent(Int.self, forKey: .hourly_rate)
        allow_tip = try values.decodeIfPresent(Bool.self, forKey: .allow_tip)
        employee_type = try values.decodeIfPresent(String.self, forKey: .employee_type)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
        home_payment_enabled = try values.decodeIfPresent(Bool.self, forKey: .home_payment_enabled)
        reset_pwd_otp = try values.decodeIfPresent(String.self, forKey: .reset_pwd_otp)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        register_type = try values.decodeIfPresent(String.self, forKey: .register_type)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
    }

}

struct Transitions : Codable {
    let name : String?
    let title : String?
    let from : String?
    let to : String?
    let acl : [String]?
    let cbMessage : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case title = "title"
        case from = "from"
        case to = "to"
        case acl = "acl"
        case cbMessage = "cbMessage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        to = try values.decodeIfPresent(String.self, forKey: .to)
        acl = try values.decodeIfPresent([String].self, forKey: .acl)
        cbMessage = try values.decodeIfPresent(String.self, forKey: .cbMessage)
    }

}
