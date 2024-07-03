//
//  ClientDataModel.swift
//  TimeControllApp
//
//  Created by prashant on 24/04/23.
//

import Foundation

struct ClientDataModel : Codable {
    let basicRules : BasicRulesModel?
    let extendedRules : ExtendedRulesModel?
    let business_types : [String]?
    let user_types : [User_types]?
    let project_statuses : [Project_statuses]?
    let task_statuses : [Task_statuses]?
    var dateTimeRules : DateTimeRules?
    let isFirstTimeLogin : Bool?
    let deviations : DeviationsControlModel?
    let loginRules : LoginRules?
    let tipRules : TipRulesModel?
    let roles : [Roles]?

    enum CodingKeys: String, CodingKey {

        case basicRules = "basicRules"
        case extendedRules = "extendedRules"
        case business_types = "business_types"
        case user_types = "user_types"
        case project_statuses = "project_statuses"
        case task_statuses = "task_statuses"
        case dateTimeRules = "dateTimeRules"
        case isFirstTimeLogin = "isFirstTimeLogin"
        case deviations = "deviations"
        case loginRules = "loginRules"
        case tipRules = "tipRules"
        case roles = "roles"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        basicRules = try values.decodeIfPresent(BasicRulesModel.self, forKey: .basicRules)
        extendedRules = try values.decodeIfPresent(ExtendedRulesModel.self, forKey: .extendedRules)
        business_types = try values.decodeIfPresent([String].self, forKey: .business_types)
        user_types = try values.decodeIfPresent([User_types].self, forKey: .user_types)
        project_statuses = try values.decodeIfPresent([Project_statuses].self, forKey: .project_statuses)
        task_statuses = try values.decodeIfPresent([Task_statuses].self, forKey: .task_statuses)
        dateTimeRules = try values.decodeIfPresent(DateTimeRules.self, forKey: .dateTimeRules)
        isFirstTimeLogin = try values.decodeIfPresent(Bool.self, forKey: .isFirstTimeLogin)
        deviations = try values.decodeIfPresent(DeviationsControlModel.self, forKey: .deviations)
        loginRules = try values.decodeIfPresent(LoginRules.self, forKey: .loginRules)
        tipRules = try values.decodeIfPresent(TipRulesModel.self, forKey: .tipRules)
        roles = try values.decodeIfPresent([Roles].self, forKey: .roles)
    }

}

struct LoginRules : Codable {
    let autoLogout : String?
    let autoTimelogs : String?
    let startBufferTimeForClockIn : Int?
    let endBufferTimeForClockOut : Int?
    let pmManagesOvertime : Bool?
    let gpsAllowedDistance : Int?
    let trackAnomalies : Bool?
    let anomalyTrackerReasons : AnomalyTrackerReasons?

    enum CodingKeys: String, CodingKey {

        case autoLogout = "autoLogout"
        case autoTimelogs = "autoTimelogs"
        case startBufferTimeForClockIn = "startBufferTimeForClockIn"
        case endBufferTimeForClockOut = "endBufferTimeForClockOut"
        case pmManagesOvertime = "pmManagesOvertime"
        case gpsAllowedDistance = "gpsAllowedDistance"
        case trackAnomalies = "trackAnomalies"
        case anomalyTrackerReasons = "anomalyTrackerReasons"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        autoLogout = try values.decodeIfPresent(String.self, forKey: .autoLogout)
        autoTimelogs = try values.decodeIfPresent(String.self, forKey: .autoTimelogs)
        startBufferTimeForClockIn = try values.decodeIfPresent(Int.self, forKey: .startBufferTimeForClockIn)
        endBufferTimeForClockOut = try values.decodeIfPresent(Int.self, forKey: .endBufferTimeForClockOut)
        pmManagesOvertime = try values.decodeIfPresent(Bool.self, forKey: .pmManagesOvertime)
        gpsAllowedDistance = try values.decodeIfPresent(Int.self, forKey: .gpsAllowedDistance)
        trackAnomalies = try values.decodeIfPresent(Bool.self, forKey: .trackAnomalies)
        anomalyTrackerReasons = try values.decodeIfPresent(AnomalyTrackerReasons.self, forKey: .anomalyTrackerReasons)
    }
}

struct User_types : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Project_statuses : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Task_statuses : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct DateTimeRules : Codable {
    let country : String?
    let country_code : String?
    var short_date_format : String?
    let long_date_format : String?
    var time_format : String?
    let total_time_format : String?
    let address_format : String?
    let currency : String?
    let distance_unit : String?
//    let currency_decimal_places : Int?
    let country_flag : String?

    enum CodingKeys: String, CodingKey {

        case country = "country"
        case country_code = "country_code"
        case short_date_format = "short_date_format"
        case long_date_format = "long_date_format"
        case time_format = "time_format"
        case total_time_format = "total_time_format"
        case address_format = "address_format"
        case currency = "currency"
        case distance_unit = "distance_unit"
//        case currency_decimal_places = "currency_decimal_places"
        case country_flag = "country_flag"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
        short_date_format = try values.decodeIfPresent(String.self, forKey: .short_date_format)
        long_date_format = try values.decodeIfPresent(String.self, forKey: .long_date_format)
        time_format = try values.decodeIfPresent(String.self, forKey: .time_format)
        total_time_format = try values.decodeIfPresent(String.self, forKey: .total_time_format)
        address_format = try values.decodeIfPresent(String.self, forKey: .address_format)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        distance_unit = try values.decodeIfPresent(String.self, forKey: .distance_unit)
//        currency_decimal_places = try values.decodeIfPresent(Int.self, forKey: .currency_decimal_places)
        country_flag = try values.decodeIfPresent(String.self, forKey: .country_flag)
    }

}

struct Roles : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}


struct AnomalyTrackerReasons : Codable {
    let offSiteClockIn : [ClockInOutReasons]?
    let offSiteClockOut : [ClockInOutReasons]?
    let earlyClockIn : [ClockInOutReasons]?
    let earlyClockOut : [ClockInOutReasons]?
    let lateClockIn : [ClockInOutReasons]?
    let lateClockOut : [ClockInOutReasons]?

    enum CodingKeys: String, CodingKey {

        case offSiteClockIn = "offSiteClockIn"
        case offSiteClockOut = "offSiteClockOut"
        case earlyClockIn = "earlyClockIn"
        case earlyClockOut = "earlyClockOut"
        case lateClockIn = "lateClockIn"
        case lateClockOut = "lateClockOut"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        offSiteClockIn = try values.decodeIfPresent([ClockInOutReasons].self, forKey: .offSiteClockIn)
        offSiteClockOut = try values.decodeIfPresent([ClockInOutReasons].self, forKey: .offSiteClockOut)
        earlyClockIn = try values.decodeIfPresent([ClockInOutReasons].self, forKey: .earlyClockIn)
        earlyClockOut = try values.decodeIfPresent([ClockInOutReasons].self, forKey: .earlyClockOut)
        lateClockIn = try values.decodeIfPresent([ClockInOutReasons].self, forKey: .lateClockIn)
        lateClockOut = try values.decodeIfPresent([ClockInOutReasons].self, forKey: .lateClockOut)
    }

}

struct ClockInOutReasons : Codable {
    let reason : String?
    let value : String?
    let code : String?
    let sendNotification : Bool?
    let autoAdjust : Bool?

    enum CodingKeys: String, CodingKey {

        case reason = "reason"
        case value = "value"
        case code = "code"
        case sendNotification = "sendNotification"
        case autoAdjust = "autoAdjust"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        sendNotification = try values.decodeIfPresent(Bool.self, forKey: .sendNotification)
        autoAdjust = try values.decodeIfPresent(Bool.self, forKey: .autoAdjust)
    }

}
