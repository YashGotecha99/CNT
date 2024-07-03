//
//  DashboardModel.swift
//  TimeControllApp
//
//  Created by prashant on 25/04/23.
//

import Foundation

struct DashboardModel : Codable {
    let last_filled : String?
    let grandtotals : Grandtotals?
//    let projects : [String]?
    let schedule : [DashboardSchedule]?
//    let todayAtWork : [TodayAtWork]?
    let last3Timelogs : [Last3Timelogs]?
//    let timeList : TimeList?
//    let deviations : Deviations?

    enum CodingKeys: String, CodingKey {

        case last_filled = "last_filled"
        case grandtotals = "grandtotals"
//        case projects = "projects"
        case schedule = "schedule"
//        case todayAtWork = "todayAtWork"
        case last3Timelogs = "last3Timelogs"
//        case timeList = "timeList"
//        case deviations = "deviations"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        last_filled = try values.decodeIfPresent(String.self, forKey: .last_filled)
        grandtotals = try values.decodeIfPresent(Grandtotals.self, forKey: .grandtotals)
//        projects = try values.decodeIfPresent([String].self, forKey: .projects)
        schedule = try values.decodeIfPresent([DashboardSchedule].self, forKey: .schedule)
//        todayAtWork = try values.decodeIfPresent([TodayAtWork].self, forKey: .todayAtWork)
        last3Timelogs = try values.decodeIfPresent([Last3Timelogs].self, forKey: .last3Timelogs)
//        timeList = try values.decodeIfPresent(TimeList.self, forKey: .timeList)
//        deviations = try values.decodeIfPresent(Deviations.self, forKey: .deviations)
    }

}

struct Grandtotals : Codable {
    let total_normal : String?
    let total_overtime : String?

    enum CodingKeys: String, CodingKey {

        case total_normal = "total_normal"
        case total_overtime = "total_overtime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_normal = try values.decodeIfPresent(String.self, forKey: .total_normal)
        total_overtime = try values.decodeIfPresent(String.self, forKey: .total_overtime)
    }

}

struct DashboardSchedule : Codable {
    let start_time : Int?
    let end_time : Int?
    let paid_hours : String?
    let task_name : String?
    let for_date : String?
    let task_id : Int?
    let project_id : Int?
    let gps_data : String?

    enum CodingKeys: String, CodingKey {

        case start_time = "start_time"
        case end_time = "end_time"
        case paid_hours = "paid_hours"
        case task_name = "task_name"
        case for_date = "for_date"
        case task_id = "task_id"
        case project_id = "project_id"
        case gps_data = "gps_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        paid_hours = try values.decodeIfPresent(String.self, forKey: .paid_hours)
        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
    }

}

struct Last3Timelogs : Codable {
    let for_date : String?
    let from : String?
    let to : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case for_date = "for_date"
        case from = "from"
        case to = "to"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        to = try values.decodeIfPresent(String.self, forKey: .to)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}
