//
//  UserListModel.swift
//  TimeControllApp
//
//  Created by prashant on 13/02/23.
//

import Foundation

struct UserListModel : Codable {
    let rows : [UserList]?
//    let total : String?
    let pages : Int?
//    let activeuser : String?
//    let inactiveuser : String?
//    let inviteLink : String?
}

struct UserListByProjectModel : Codable {
    let id : Int?
    let fullname : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fullname = "fullname"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
    }

}

struct UserList : Codable {
    let id : Int?
    let image : String?
    let status : String?
//    let added : String?
//    let client_id : Int?
    let username : String?
//    let hash : String?
//    let salt : String?
    let user_type : String?
    let first_name : String?
    let last_name : String?
    let email : String?
//    let employee_percent : String?
//    let address : String?
//    let post_number : String?
//    let post_place : String?
//    let title : String?
    let full_name : String?
    let phone : String?
//    let g_nr : String?
//    let b_nr : String?
//    let description : String?
//    let timelog_start_from : String?
//    let timelog_last_filled : String?
//    let birthday : String?
//    let data : UserData?
//    let created_at : String?
//    let updated_at : String?
//    let generic_login : String?
//    let generic_pin : String?
//    let is_now_locked : Int?
//    let social_number : String?
//    let attachments : String?
//    let disable_autolog : Bool?
//    let hourly_rate : String?
//    let monthly_rate : String?
//    let internal_number : String?
//    let gps_data : String?
//    let home_payment_enabled : Bool?
//    let social_hash : String?
//    let disregard_billable_hours : String?
//    let payment_mode : String?
//    let additional_pay : String?
//    let vacation_days : Int?
//    let allow_tip : Bool?
//    let employee_type : String?
//    let reset_pwd_otp : String?
//    let register_type : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case image = "image"
        case status = "status"
//        case added = "added"
//        case client_id = "client_id"
        case username = "username"
//        case hash = "hash"
//        case salt = "salt"
        case user_type = "user_type"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
//        case employee_percent = "employee_percent"
//        case address = "address"
//        case post_number = "post_number"
//        case post_place = "post_place"
//        case title = "title"
        case full_name = "full_name"
        case phone = "phone"
//        case g_nr = "g_nr"
//        case b_nr = "b_nr"
//        case description = "description"
//        case timelog_start_from = "timelog_start_from"
//        case timelog_last_filled = "timelog_last_filled"
//        case birthday = "birthday"
//        case data = "data"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//        case generic_login = "generic_login"
//        case generic_pin = "generic_pin"
//        case is_now_locked = "is_now_locked"
//        case social_number = "social_number"
//        case attachments = "attachments"
//        case disable_autolog = "disable_autolog"
//        case hourly_rate = "hourly_rate"
//        case monthly_rate = "monthly_rate"
//        case internal_number = "internal_number"
//        case gps_data = "gps_data"
//        case home_payment_enabled = "home_payment_enabled"
//        case social_hash = "social_hash"
//        case disregard_billable_hours = "disregard_billable_hours"
//        case payment_mode = "payment_mode"
//        case additional_pay = "additional_pay"
//        case vacation_days = "vacation_days"
//        case allow_tip = "allow_tip"
//        case employee_type = "employee_type"
//        case reset_pwd_otp = "reset_pwd_otp"
//        case register_type = "register_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        status = try values.decodeIfPresent(String.self, forKey: .status)
//        added = try values.decodeIfPresent(String.self, forKey: .added)
//        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
//        hash = try values.decodeIfPresent(String.self, forKey: .hash)
//        salt = try values.decodeIfPresent(String.self, forKey: .salt)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
//        employee_percent = try values.decodeIfPresent(String.self, forKey: .employee_percent)
//        address = try values.decodeIfPresent(String.self, forKey: .address)
//        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
//        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
//        title = try values.decodeIfPresent(String.self, forKey: .title)
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
//        g_nr = try values.decodeIfPresent(String.self, forKey: .g_nr)
//        b_nr = try values.decodeIfPresent(String.self, forKey: .b_nr)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        timelog_start_from = try values.decodeIfPresent(String.self, forKey: .timelog_start_from)
//        timelog_last_filled = try values.decodeIfPresent(String.self, forKey: .timelog_last_filled)
//        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
//        data = try values.decodeIfPresent(UserData.self, forKey: .data)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//        generic_login = try values.decodeIfPresent(String.self, forKey: .generic_login)
//        generic_pin = try values.decodeIfPresent(String.self, forKey: .generic_pin)
//        is_now_locked = try values.decodeIfPresent(Int.self, forKey: .is_now_locked)
//        social_number = try values.decodeIfPresent(String.self, forKey: .social_number)
//        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
//        disable_autolog = try values.decodeIfPresent(Bool.self, forKey: .disable_autolog)
//        hourly_rate = try values.decodeIfPresent(String.self, forKey: .hourly_rate)
//        monthly_rate = try values.decodeIfPresent(String.self, forKey: .monthly_rate)
//        internal_number = try values.decodeIfPresent(String.self, forKey: .internal_number)
//        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
//        home_payment_enabled = try values.decodeIfPresent(Bool.self, forKey: .home_payment_enabled)
//        social_hash = try values.decodeIfPresent(String.self, forKey: .social_hash)
//        disregard_billable_hours = try values.decodeIfPresent(String.self, forKey: .disregard_billable_hours)
//        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
//        additional_pay = try values.decodeIfPresent(String.self, forKey: .additional_pay)
//        vacation_days = try values.decodeIfPresent(Int.self, forKey: .vacation_days)
//        allow_tip = try values.decodeIfPresent(Bool.self, forKey: .allow_tip)
//        employee_type = try values.decodeIfPresent(String.self, forKey: .employee_type)
//        reset_pwd_otp = try values.decodeIfPresent(String.self, forKey: .reset_pwd_otp)
//        register_type = try values.decodeIfPresent(String.self, forKey: .register_type)
    }
}


struct UserData : Codable {
    let kids : [String]?
    let is_single_parent : Bool?
    let nomines : [String]?
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
        kids = try values.decodeIfPresent([String].self, forKey: .kids)
        is_single_parent = try values.decodeIfPresent(Bool.self, forKey: .is_single_parent)
        nomines = try values.decodeIfPresent([String].self, forKey: .nomines)
        enable_pause_button = try values.decodeIfPresent(Bool.self, forKey: .enable_pause_button)
        disable_manual_log = try values.decodeIfPresent(Bool.self, forKey: .disable_manual_log)
        lang = try values.decodeIfPresent(String.self, forKey: .lang)
        lastNotificationTime = try values.decodeIfPresent(String.self, forKey: .lastNotificationTime)
    }
}
