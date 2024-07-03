//
//  UserDetailsModel.swift
//  TimeControllApp
//
//  Created by prashant on 14/02/23.
//

import Foundation

struct UserDetailsModel : Codable {
    let user : UserDetails?
}

struct UserDetails : Codable {
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
    let internal_number : Int?
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
    let data : UserDetailsData?
    let home_payment_enabled : Bool?
    let reset_pwd_otp : String?
    let gps_data : String?
    let register_type : String?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
    let memberInProjects : String?
    let attachmentsData : [AttachmentsData]?
    let bank_account_number : String?

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
        case internal_number = "internal_number"
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
        case data = "data"
        case home_payment_enabled = "home_payment_enabled"
        case reset_pwd_otp = "reset_pwd_otp"
        case gps_data = "gps_data"
        case register_type = "register_type"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
        case memberInProjects = "MemberInProjects"
        case attachmentsData = "Attachments"
        case bank_account_number = "bank_account_number"
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
        internal_number = try values.decodeIfPresent(Int.self, forKey: .internal_number)
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
        data = try values.decodeIfPresent(UserDetailsData.self, forKey: .data)
        home_payment_enabled = try values.decodeIfPresent(Bool.self, forKey: .home_payment_enabled)
        reset_pwd_otp = try values.decodeIfPresent(String.self, forKey: .reset_pwd_otp)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        register_type = try values.decodeIfPresent(String.self, forKey: .register_type)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        memberInProjects = try values.decodeIfPresent(String.self, forKey: .memberInProjects)
        attachmentsData = try values.decodeIfPresent([AttachmentsData].self, forKey: .attachmentsData)
        bank_account_number = try values.decodeIfPresent(String.self, forKey: .bank_account_number)
    }
}


struct UserDetailsData : Codable {
    let kids : [Kids]?
    let is_single_parent : Bool?
    let nomines : [Nomines]?
    let enable_pause_button : Bool?
    let disable_manual_log : Bool?
    let lang : String?
    let lastNotificationTime : String?

    enum CodingKeys: String, CodingKey {
        case kids = "kids"
        case is_single_parent = "is_single_parent"
        case nomines = "nomines"
        case enable_pause_button = "enable_pause_button"
        case disable_manual_log = "disable_manual_log"
        case lang = "lang"
        case lastNotificationTime = "lastNotificationTime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kids = try values.decodeIfPresent([Kids].self, forKey: .kids)
        is_single_parent = try values.decodeIfPresent(Bool.self, forKey: .is_single_parent)
        nomines = try values.decodeIfPresent([Nomines].self, forKey: .nomines)
        enable_pause_button = try values.decodeIfPresent(Bool.self, forKey: .enable_pause_button)
        disable_manual_log = try values.decodeIfPresent(Bool.self, forKey: .disable_manual_log)
        lang = try values.decodeIfPresent(String.self, forKey: .lang)
        lastNotificationTime = try values.decodeIfPresent(String.self, forKey: .lastNotificationTime)
    }
}

struct AttachmentsData : Codable {
    let id : Int?
    let filename : String?
    let filetype : String?
    let user_id : Int?
    let location : String?
    let to_model : String?
    let to_id : Int?
//    let data : [String]?
    let created_at : String?
    let updated_at : String?

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
//        data = try values.decodeIfPresent([String].self, forKey: .data)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

struct Kids : Codable {
    let key : String?
    let name : String?
    let date : String?
    let chronic_disease : String?
    let chronic_permission : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case name = "name"
        case date = "date"
        case chronic_disease = "chronic_disease"
        case chronic_permission = "chronic_permission"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        chronic_disease = try values.decodeIfPresent(String.self, forKey: .chronic_disease)
        chronic_permission = try values.decodeIfPresent(String.self, forKey: .chronic_permission)
    }

    init(key:String,name:String,date:String,chronicDisease:String,chronicPermission:String) {
        self.key = key
        self.name = name
        self.date = date
        self.chronic_disease = chronicDisease
        self.chronic_permission = chronicPermission
    }
}

struct Nomines : Codable {
    let key : String?
    let name : String?
    let contactNumber : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case name = "name"
        case contactNumber = "contactNumber"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        contactNumber = try values.decodeIfPresent(String.self, forKey: .contactNumber)
    }
    init(key:String,name:String,contactNumber:String) {
        self.key = key
        self.name = name
        self.contactNumber = contactNumber
    }

}
