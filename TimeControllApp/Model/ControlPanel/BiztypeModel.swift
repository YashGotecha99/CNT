//
//  BiztypeModel.swift
//  TimeControllApp
//
//  Created by prashant on 24/04/23.
//

import Foundation

struct BiztypeModel : Codable {
    let id : Int?
    let name : String?
    let code : String?
    let data : BiztypeDataModel?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case code = "code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        data = try values.decodeIfPresent(BiztypeDataModel.self, forKey: .data)
    }

}

struct BiztypeDataModel : Codable {
    let allow_vacations : Bool?
//    let name_substitutions : [String]?
    let allow_absents : Bool?
    let allow_accepting : Bool?
    let pm_hide_tasks : Bool?
    let member_allow_see_projects : Bool?
    let show_times_on_project : Bool?
    let hide_send_report : Bool?
    let presence_view : Bool?
    let allow_vacation_not_me : Bool?
    let reports_not_for_me : Bool?
    let reports_weekly : Bool?
    let pm_allow_editing_all : Bool?
    let login_as_allowed : Bool?
    let gps_enabled : Bool?
    let enable_deviations : Bool?
    let checklists : Bool?
    let enable_checklist : Bool?
    let locked_mode : Bool?
    let allow_system_document : Bool?

    enum CodingKeys: String, CodingKey {

        case allow_vacations = "allow_vacations"
//        case name_substitutions = "name_substitutions"
        case allow_absents = "allow_absents"
        case allow_accepting = "allow_accepting"
        case pm_hide_tasks = "pm_hide_tasks"
        case member_allow_see_projects = "member_allow_see_projects"
        case show_times_on_project = "show_times_on_project"
        case hide_send_report = "hide_send_report"
        case presence_view = "presence_view"
        case allow_vacation_not_me = "allow_vacation_not_me"
        case reports_not_for_me = "reports_not_for_me"
        case reports_weekly = "reports_weekly"
        case pm_allow_editing_all = "pm_allow_editing_all"
        case login_as_allowed = "login_as_allowed"
        case gps_enabled = "gps_enabled"
        case enable_deviations = "enable_deviations"
        case checklists = "checklists"
        case enable_checklist = "enable_checklist"
        case locked_mode = "locked_mode"
        case allow_system_document = "allow_system_document"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        allow_vacations = try values.decodeIfPresent(Bool.self, forKey: .allow_vacations)
//        name_substitutions = try values.decodeIfPresent([String].self, forKey: .name_substitutions)
        allow_absents = try values.decodeIfPresent(Bool.self, forKey: .allow_absents)
        allow_accepting = try values.decodeIfPresent(Bool.self, forKey: .allow_accepting)
        pm_hide_tasks = try values.decodeIfPresent(Bool.self, forKey: .pm_hide_tasks)
        member_allow_see_projects = try values.decodeIfPresent(Bool.self, forKey: .member_allow_see_projects)
        show_times_on_project = try values.decodeIfPresent(Bool.self, forKey: .show_times_on_project)
        hide_send_report = try values.decodeIfPresent(Bool.self, forKey: .hide_send_report)
        presence_view = try values.decodeIfPresent(Bool.self, forKey: .presence_view)
        allow_vacation_not_me = try values.decodeIfPresent(Bool.self, forKey: .allow_vacation_not_me)
        reports_not_for_me = try values.decodeIfPresent(Bool.self, forKey: .reports_not_for_me)
        reports_weekly = try values.decodeIfPresent(Bool.self, forKey: .reports_weekly)
        pm_allow_editing_all = try values.decodeIfPresent(Bool.self, forKey: .pm_allow_editing_all)
        login_as_allowed = try values.decodeIfPresent(Bool.self, forKey: .login_as_allowed)
        gps_enabled = try values.decodeIfPresent(Bool.self, forKey: .gps_enabled)
        enable_deviations = try values.decodeIfPresent(Bool.self, forKey: .enable_deviations)
        checklists = try values.decodeIfPresent(Bool.self, forKey: .checklists)
        enable_checklist = try values.decodeIfPresent(Bool.self, forKey: .enable_checklist)
        locked_mode = try values.decodeIfPresent(Bool.self, forKey: .locked_mode)
        allow_system_document = try values.decodeIfPresent(Bool.self, forKey: .allow_system_document)
    }

}
