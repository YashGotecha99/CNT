//
//  PendingRequestDetailsModel.swift
//  TimeControllApp
//
//  Created by prashant on 22/09/23.
//

import Foundation

struct PendingRequestDetailsModel : Codable {
    let absence : AbsenceData?
    let vacation : AbsenceData?

    enum CodingKeys: String, CodingKey {

        case absence = "absence"
        case vacation = "vacation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        absence = try values.decodeIfPresent(AbsenceData.self, forKey: .absence)
        vacation = try values.decodeIfPresent(AbsenceData.self, forKey: .vacation)
    }
}

struct AbsenceData : Codable {
    let id : Int?
    let status : String?
    let user_id : Int?
    let from : String?
    let to : String?
    let absence_type : String?
    let vacation_type : String?
    let total_days : Int?
    let attachments : String?
    let comments : String?
    let group : Int?
    let absence_payment_per_day : Int?
    let status_note : String?
    let status_changed_by : String?
    let status_changed_on : String?
    let leave_type : String?
    let employement_grade : Int?
    let hours : Float?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
//    let attachmentsPendingData : [String]?
    let childData : ChildData?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case user_id = "user_id"
        case from = "from"
        case to = "to"
        case absence_type = "absence_type"
        case vacation_type = "vacation_type"
        case total_days = "total_days"
        case attachments = "attachments"
        case comments = "comments"
        case group = "group"
        case absence_payment_per_day = "absence_payment_per_day"
        case status_note = "status_note"
        case status_changed_by = "status_changed_by"
        case status_changed_on = "status_changed_on"
        case leave_type = "leave_type"
        case employement_grade = "employement_grade"
        case hours = "hours"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
//        case attachmentsPendingData = "Attachments"
        case childData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        to = try values.decodeIfPresent(String.self, forKey: .to)
        absence_type = try values.decodeIfPresent(String.self, forKey: .absence_type)
        vacation_type = try values.decodeIfPresent(String.self, forKey: .vacation_type)
        total_days = try values.decodeIfPresent(Int.self, forKey: .total_days)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        group = try values.decodeIfPresent(Int.self, forKey: .group)
        absence_payment_per_day = try values.decodeIfPresent(Int.self, forKey: .absence_payment_per_day)
        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
        status_changed_by = try values.decodeIfPresent(String.self, forKey: .status_changed_by)
        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
        leave_type = try values.decodeIfPresent(String.self, forKey: .leave_type)
        employement_grade = try values.decodeIfPresent(Int.self, forKey: .employement_grade)
        hours = try values.decodeIfPresent(Float.self, forKey: .hours)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
//        attachmentsPendingData = try values.decodeIfPresent([String].self, forKey: .attachmentsPendingData)
        childData = try values.decodeIfPresent(ChildData.self, forKey: .childData)
    }

}

struct ChildData : Codable {
    let child : Child?
    let child_index : String?

    enum CodingKeys: String, CodingKey {

        case child = "child"
        case child_index = "child_index"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        child = try values.decodeIfPresent(Child.self, forKey: .child)
        child_index = try values.decodeIfPresent(String.self, forKey: .child_index)
    }

}

struct Child : Codable {
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

}

