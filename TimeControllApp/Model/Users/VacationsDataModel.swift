//
//  File.swift
//  TimeControllApp
//
//  Created by prashant on 09/06/23.
//

import Foundation

struct VacationsDataModel : Codable {
    let user : UserVacationsData?

    enum CodingKeys: String, CodingKey {

        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(UserVacationsData.self, forKey: .user)
    }
}


struct UserVacationsData : Codable {
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
    let home_payment_enabled : Bool?
    let reset_pwd_otp : String?
    let gps_data : String?
    let register_type : String?
    let is_user_logged_in : Bool?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
    let groups : String?
    let totals : TotalsData?

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
        case home_payment_enabled = "home_payment_enabled"
        case reset_pwd_otp = "reset_pwd_otp"
        case gps_data = "gps_data"
        case register_type = "register_type"
        case is_user_logged_in = "is_user_logged_in"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
        case groups = "groups"
        case totals = "Totals"
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
        home_payment_enabled = try values.decodeIfPresent(Bool.self, forKey: .home_payment_enabled)
        reset_pwd_otp = try values.decodeIfPresent(String.self, forKey: .reset_pwd_otp)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
        register_type = try values.decodeIfPresent(String.self, forKey: .register_type)
        is_user_logged_in = try values.decodeIfPresent(Bool.self, forKey: .is_user_logged_in)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        groups = try values.decodeIfPresent(String.self, forKey: .groups)
        totals = try values.decodeIfPresent(TotalsData.self, forKey: .totals)
    }
}

struct TotalsData : Codable {
    let normal : Int?
    let overtime : Int?
    let yearly : Yearly?

    enum CodingKeys: String, CodingKey {

        case normal = "normal"
        case overtime = "overtime"
        case yearly = "yearly"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        normal = try values.decodeIfPresent(Int.self, forKey: .normal)
        overtime = try values.decodeIfPresent(Int.self, forKey: .overtime)
        yearly = try values.decodeIfPresent(Yearly.self, forKey: .yearly)
    }
}

struct Yearly : Codable {
    let selfClearances : Int?
    let vacationDays : Int?
    let clearancesLeft : Int?
    let vacationsLeft : Int?
    let vacationsTotal : Int?
    let doctorClearances : Int?
    let childDays : Int?
    let rejectedVacation : Int?
    let pendingVacation : Int?
    let childDaysUsed : Int?
    let userSickLeaveCycle : UserSickLeaveCycle?

    enum CodingKeys: String, CodingKey {

        case selfClearances = "selfClearances"
        case vacationDays = "vacationDays"
        case clearancesLeft = "clearancesLeft"
        case vacationsLeft = "vacationsLeft"
        case vacationsTotal = "vacationsTotal"
        case doctorClearances = "doctorClearances"
        case childDays = "childDays"
        case rejectedVacation = "rejectedVacation"
        case pendingVacation = "pendingVacation"
        case childDaysUsed = "childDaysUsed"
        case userSickLeaveCycle = "userSickLeaveCycle"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        selfClearances = try values.decodeIfPresent(Int.self, forKey: .selfClearances)
        vacationDays = try values.decodeIfPresent(Int.self, forKey: .vacationDays)
        clearancesLeft = try values.decodeIfPresent(Int.self, forKey: .clearancesLeft)
        vacationsLeft = try values.decodeIfPresent(Int.self, forKey: .vacationsLeft)
        vacationsTotal = try values.decodeIfPresent(Int.self, forKey: .vacationsTotal)
        doctorClearances = try values.decodeIfPresent(Int.self, forKey: .doctorClearances)
        childDays = try values.decodeIfPresent(Int.self, forKey: .childDays)
        rejectedVacation = try values.decodeIfPresent(Int.self, forKey: .rejectedVacation)
        pendingVacation = try values.decodeIfPresent(Int.self, forKey: .pendingVacation)
        childDaysUsed = try values.decodeIfPresent(Int.self, forKey: .childDaysUsed)
        userSickLeaveCycle = try values.decodeIfPresent(UserSickLeaveCycle.self, forKey: .userSickLeaveCycle)
    }
}

struct UserSickLeaveCycle : Codable {
    let cycleEndDate : String?
    let cycleStartDate : String?

    enum CodingKeys: String, CodingKey {

        case cycleEndDate = "cycleEndDate"
        case cycleStartDate = "cycleStartDate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cycleEndDate = try values.decodeIfPresent(String.self, forKey: .cycleEndDate)
        cycleStartDate = try values.decodeIfPresent(String.self, forKey: .cycleStartDate)
    }

}
