//
//  ScheduleListModel.swift
//  TimeControllApp
//
//  Created by yash on 12/12/22.
//

import Foundation

struct ScheduleListModel : Codable {
    let shifts : [Shifts]?
//    let vacations : [String]?
//    let absences : [String]?
//    let combined : [Combined]?

    enum CodingKeys: String, CodingKey {

        case shifts = "shifts"
//        case vacations = "vacations"
//        case absences = "absences"
//        case combined = "combined"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shifts = try values.decodeIfPresent([Shifts].self, forKey: .shifts)
//        vacations = try values.decodeIfPresent([String].self, forKey: .vacations)
//        absences = try values.decodeIfPresent([String].self, forKey: .absences)
//        combined = try values.decodeIfPresent([Combined].self, forKey: .combined)
    }

}

struct Shifts : Codable {
    let id : Int?
    let assignee_id : Int?
    let project_id : Int?
    let task_id : Int?
    let for_date : String?
    let start_time : Int?
    let end_time : Int?
    let status : String?
    let data : DataModal?
    let work_log_status : String?
    let project_name : String?
    let task_name : String?
    let assignee_name : String?
    let source : String?
    let user_image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case assignee_id = "assignee_id"
        case project_id = "project_id"
        case task_id = "task_id"
        case for_date = "for_date"
        case start_time = "start_time"
        case end_time = "end_time"
        case status = "status"
        case data = "data"
        case work_log_status = "work_log_status"
        case project_name = "project_name"
        case task_name = "task_name"
        case assignee_name = "assignee_name"
        case source = "source"
        case user_image = "user_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        data = try values.decodeIfPresent(DataModal.self, forKey: .data)
        work_log_status = try values.decodeIfPresent(String.self, forKey: .work_log_status)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
        assignee_name = try values.decodeIfPresent(String.self, forKey: .assignee_name)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
    }

}
struct Combined : Codable {
    let id : Int?
    let assignee_id : Int?
    let project_id : Int?
    let task_id : Int?
    let for_date : String?
    let start_time : Int?
    let end_time : Int?
    let status : String?
    let data : DataModal?
    let work_log_status : String?
    let project_name : String?
    let task_name : String?
    let assignee_name : String?
    let source : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case assignee_id = "assignee_id"
        case project_id = "project_id"
        case task_id = "task_id"
        case for_date = "for_date"
        case start_time = "start_time"
        case end_time = "end_time"
        case status = "status"
        case data = "data"
        case work_log_status = "work_log_status"
        case project_name = "project_name"
        case task_name = "task_name"
        case assignee_name = "assignee_name"
        case source = "source"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        data = try values.decodeIfPresent(DataModal.self, forKey: .data)
        work_log_status = try values.decodeIfPresent(String.self, forKey: .work_log_status)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
        assignee_name = try values.decodeIfPresent(String.self, forKey: .assignee_name)
        source = try values.decodeIfPresent(String.self, forKey: .source)
    }

}
struct DataModal : Codable {
    let addBonus : Bool?
    let history : [History]?

    enum CodingKeys: String, CodingKey {

        case addBonus = "addBonus"
        case history = "history"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addBonus = try values.decodeIfPresent(Bool.self, forKey: .addBonus)
        history = try values.decodeIfPresent([History].self, forKey: .history)
    }

}
struct History : Codable {
    let comment : String?
    let action : String?
    let status : String?
//    let assigned : String?
    let date : String?
    let user_id : Int?
    let user_name : String?

    enum CodingKeys: String, CodingKey {

        case comment = "comment"
        case action = "action"
        case status = "status"
//        case assigned = "assigned"
        case date = "date"
        case user_id = "user_id"
        case user_name = "user_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        action = try values.decodeIfPresent(String.self, forKey: .action)
        status = try values.decodeIfPresent(String.self, forKey: .status)
//        assigned = try values.decodeIfPresent(String.self, forKey: .assigned)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
    }

}


struct FormattedScheduleListModel : Codable {
    let formattedShifts : [FormattedShifts]?

    enum CodingKeys: String, CodingKey {

        case formattedShifts = "formattedShifts"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        formattedShifts = try values.decodeIfPresent([FormattedShifts].self, forKey: .formattedShifts)
    }

}
struct FormattedShifts : Codable {
    let for_date : String?
    let data : [FormattedData]?

    enum CodingKeys: String, CodingKey {

        case for_date = "for_date"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        data = try values.decodeIfPresent([FormattedData].self, forKey: .data)
    }

}

struct FormattedData : Codable {
    let id : Int?
    let assignee_id : Int?
    let project_id : Int?
    let task_id : Int?
    let for_date : String?
    let start_time : Int?
    let end_time : Int?
    let status : String?
    let work_log_status : String?
    let project_name : String?
    let task_name : String?
    let assignee_name : String?
    let from_user_role: String?
    let to_user_role: String?
    let accepted_user_role: String?


    enum CodingKeys: String, CodingKey {

        case id = "id"
        case assignee_id = "assignee_id"
        case project_id = "project_id"
        case task_id = "task_id"
        case for_date = "for_date"
        case start_time = "start_time"
        case end_time = "end_time"
        case status = "status"
        case work_log_status = "work_log_status"
        case project_name = "project_name"
        case task_name = "task_name"
        case assignee_name = "assignee_name"
        case from_user_role = "from_user_role"
        case to_user_role = "to_user_role"
        case accepted_user_role = "accepted_user_role"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        work_log_status = try values.decodeIfPresent(String.self, forKey: .work_log_status)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
        assignee_name = try values.decodeIfPresent(String.self, forKey: .assignee_name)
        from_user_role = try values.decodeIfPresent(String.self, forKey: .from_user_role)
        to_user_role = try values.decodeIfPresent(String.self, forKey: .to_user_role)
        accepted_user_role = try values.decodeIfPresent(String.self, forKey: .accepted_user_role)
    }

}

struct ShiftByUser : Codable {
    let userId : String?
    let userName : String?
    let userImage : String?
    let role : String?
    let shifts : [ShiftsOfUser]?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case userName = "userName"
        case userImage = "userImage"
        case role = "role"
        case shifts = "shifts"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        userImage = try values.decodeIfPresent(String.self, forKey: .userImage)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        shifts = try values.decodeIfPresent([ShiftsOfUser].self, forKey: .shifts)
    }

}

struct ShiftsOfUser : Codable {
    let shift_id : Int?
    let id : Int?
    let full_name : String?
    let image : String?
    let role : String?
    let task_id : Int?
    let project_id : Int?
    let start_time : Int?
    let end_time : Int?
    let for_date : String?
    let status : String?
    let project_name : String?
    let task_name : String?
    let task_location : String?

    enum CodingKeys: String, CodingKey {

        case shift_id = "shift_id"
        case id = "id"
        case full_name = "full_name"
        case image = "image"
        case role = "role"
        case task_id = "task_id"
        case project_id = "project_id"
        case start_time = "start_time"
        case end_time = "end_time"
        case for_date = "for_date"
        case status = "status"
        case project_name = "project_name"
        case task_name = "task_name"
        case task_location = "task_location"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shift_id = try values.decodeIfPresent(Int.self, forKey: .shift_id)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        project_id = try values.decodeIfPresent(Int.self, forKey: .project_id)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
        task_location = try values.decodeIfPresent(String.self, forKey: .task_location)
    }

}

struct TradeRequest : Codable {
    let createdAt : String?
    let updatedAt : String?
    let id : Int?
    let shift_id : Int?
    let status : String?
    let from_user : Int?
    let users : [Int]?
    let swap_type : String?
    let to_user : String?
    let assignees : String?
    let comments : String?
    let task_id : String?
    let approved_by : String?
    let rejected_by_users : String?
    let approved_by_users : String?
    let swapped_shift_id : String?

    enum CodingKeys: String, CodingKey {

        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case id = "id"
        case shift_id = "shift_id"
        case status = "status"
        case from_user = "from_user"
        case users = "users"
        case swap_type = "swap_type"
        case to_user = "to_user"
        case assignees = "assignees"
        case comments = "comments"
        case task_id = "task_id"
        case approved_by = "approved_by"
        case rejected_by_users = "rejected_by_users"
        case approved_by_users = "approved_by_users"
        case swapped_shift_id = "swapped_shift_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        shift_id = try values.decodeIfPresent(Int.self, forKey: .shift_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        from_user = try values.decodeIfPresent(Int.self, forKey: .from_user)
        users = try values.decodeIfPresent([Int].self, forKey: .users)
        swap_type = try values.decodeIfPresent(String.self, forKey: .swap_type)
        to_user = try values.decodeIfPresent(String.self, forKey: .to_user)
        assignees = try values.decodeIfPresent(String.self, forKey: .assignees)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        task_id = try values.decodeIfPresent(String.self, forKey: .task_id)
        approved_by = try values.decodeIfPresent(String.self, forKey: .approved_by)
        rejected_by_users = try values.decodeIfPresent(String.self, forKey: .rejected_by_users)
        approved_by_users = try values.decodeIfPresent(String.self, forKey: .approved_by_users)
        swapped_shift_id = try values.decodeIfPresent(String.self, forKey: .swapped_shift_id)
    }

}

struct SwapRequestShiftModal : Codable {
    let formattedShifts : [FormattedRequestShifts]?

    enum CodingKeys: String, CodingKey {

        case formattedShifts = "formattedShifts"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        formattedShifts = try values.decodeIfPresent([FormattedRequestShifts].self, forKey: .formattedShifts)
    }

}

struct FormattedRequestShifts : Codable {
    let for_date : String?
    let data : [RequestShift]?

    enum CodingKeys: String, CodingKey {

        case for_date = "for_date"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        data = try values.decodeIfPresent([RequestShift].self, forKey: .data)
    }

}

struct RequestShift : Codable {
    let swap_id : Int?
    let users : [Int]?
    let shift_id : Int?
//    let approved_by_users : String?
    let task_id : Int?
    let start_time : Int?
    let end_time : Int?
    let task_name : String?
    let task_number : Int?
    let comments : String?
//    let rejected_by_users : String?
    let swap_status : String?
    let swap_type : String?
    let shift_date : String?
    let from_user : String?
    let to_user : String?
    let accepted_username : String?
    let from_user_image : String?
    let to_user_image : String?
    let accepted_user_image : String?
    let is_accepted : Bool?
    let is_declined : Bool?
    let is_approved : Bool?
    let is_rejected : Bool?
    let swap_history_id : Int?
    let accepted_id : Int?
    let project_name : String?
    let task_post_number : String?
    let task_post_place : String?
    let task_address : String?
    let from_user_id : Int?
    let from_user_role: String?
    let to_user_role: String?
    let accepted_user_role: String?
    let accepted_user_start_time : Int?
    let accepted_user_end_time : Int?
    let isAnomaly : Int?
    let isOvertime : Bool?
    let userWithOvertime : String?
    let shiftTransactionOvertimeDetails : ShiftTransactionOvertimeDetails?
    
    enum CodingKeys: String, CodingKey {

        case swap_id = "swap_id"
        case users = "users"
        case shift_id = "shift_id"
//        case approved_by_users = "approved_by_users"
        case task_id = "task_id"
        case start_time = "start_time"
        case end_time = "end_time"
        case task_name = "task_name"
        case task_number = "task_number"
        case comments = "comments"
//        case rejected_by_users = "rejected_by_users"
        case swap_status = "swap_status"
        case swap_type = "swap_type"
        case shift_date = "shift_date"
        case from_user = "from_user"
        case to_user = "to_user"
        case accepted_username = "accepted_username"
        case from_user_image = "from_user_image"
        case to_user_image = "to_user_image"
        case accepted_user_image = "accepted_user_image"
        case is_accepted = "is_accepted"
        case is_declined = "is_declined"
        case is_approved = "is_approved"
        case is_rejected = "is_rejected"
        case swap_history_id = "swap_history_id"
        case accepted_id = "accepted_id"
        case project_name = "project_name"
        case task_post_number = "task_post_number"
        case task_post_place = "task_post_place"
        case task_address = "task_address"
        case from_user_id = "from_user_id"
        case from_user_role = "from_user_role"
        case to_user_role = "to_user_role"
        case accepted_user_role = "accepted_user_role"
        case accepted_user_start_time = "accepted_user_start_time"
        case accepted_user_end_time = "accepted_user_end_time"
        case isAnomaly = "isAnomaly"
        case isOvertime = "isOvertime"
        case userWithOvertime = "userWithOvertime"
        case shiftTransactionOvertimeDetails = "shiftTransactionOvertimeDetails"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        swap_id = try values.decodeIfPresent(Int.self, forKey: .swap_id)
        users = try values.decodeIfPresent([Int].self, forKey: .users)
        shift_id = try values.decodeIfPresent(Int.self, forKey: .shift_id)
//        approved_by_users = try values.decodeIfPresent(String.self, forKey: .approved_by_users)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        start_time = try values.decodeIfPresent(Int.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(Int.self, forKey: .end_time)
        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
        task_number = try values.decodeIfPresent(Int.self, forKey: .task_number)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
//        rejected_by_users = try values.decodeIfPresent(String.self, forKey: .rejected_by_users)
        swap_status = try values.decodeIfPresent(String.self, forKey: .swap_status)
        swap_type = try values.decodeIfPresent(String.self, forKey: .swap_type)
        shift_date = try values.decodeIfPresent(String.self, forKey: .shift_date)
        from_user = try values.decodeIfPresent(String.self, forKey: .from_user)
        to_user = try values.decodeIfPresent(String.self, forKey: .to_user)
        accepted_username = try values.decodeIfPresent(String.self, forKey: .accepted_username)
        from_user_image = try values.decodeIfPresent(String.self, forKey: .from_user_image)
        to_user_image = try values.decodeIfPresent(String.self, forKey: .to_user_image)
        accepted_user_image = try values.decodeIfPresent(String.self, forKey: .accepted_user_image)
        is_accepted = try values.decodeIfPresent(Bool.self, forKey: .is_accepted)
        is_declined = try values.decodeIfPresent(Bool.self, forKey: .is_declined)
        is_approved = try values.decodeIfPresent(Bool.self, forKey: .is_approved)
        is_rejected = try values.decodeIfPresent(Bool.self, forKey: .is_rejected)
        swap_history_id = try values.decodeIfPresent(Int.self, forKey: .swap_history_id)
        accepted_id = try values.decodeIfPresent(Int.self, forKey: .accepted_id)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        task_address = try values.decodeIfPresent(String.self, forKey: .task_address)
        task_post_number = try values.decodeIfPresent(String.self, forKey: .task_post_number)
        task_post_place = try values.decodeIfPresent(String.self, forKey: .task_post_place)
        from_user_id = try values.decodeIfPresent(Int.self, forKey: .from_user_id)
        from_user_role = try values.decodeIfPresent(String.self, forKey: .from_user_role)
        to_user_role = try values.decodeIfPresent(String.self, forKey: .to_user_role)
        accepted_user_role = try values.decodeIfPresent(String.self, forKey: .accepted_user_role)
        accepted_user_start_time = try values.decodeIfPresent(Int.self, forKey: .accepted_user_start_time)
        accepted_user_end_time = try values.decodeIfPresent(Int.self, forKey: .accepted_user_end_time)
        isAnomaly = try values.decodeIfPresent(Int.self, forKey: .isAnomaly)
        isOvertime = try values.decodeIfPresent(Bool.self, forKey: .isOvertime)
        userWithOvertime = try values.decodeIfPresent(String.self, forKey: .userWithOvertime)
        shiftTransactionOvertimeDetails = try values.decodeIfPresent(ShiftTransactionOvertimeDetails.self, forKey: .shiftTransactionOvertimeDetails)
    }

}

struct ShiftTransactionOvertimeDetails : Codable {
    let swapperOvertimeMin : Int?
    let swapperShiftTotalMins : Int?
    let swapperShiftTotalMinsAfterSwap : Int?
    let swapperName : String?
    let acceptorOvertimeMin : Int?
    let acceptorShiftTotalMins : Int?
    let acceptorShiftTotalMinsAfterSwap : Int?
    let acceptorName : String?

    enum CodingKeys: String, CodingKey {

        case swapperOvertimeMin = "swapperOvertimeMin"
        case swapperShiftTotalMins = "swapperShiftTotalMins"
        case swapperShiftTotalMinsAfterSwap = "swapperShiftTotalMinsAfterSwap"
        case swapperName = "swapperName"
        case acceptorOvertimeMin = "acceptorOvertimeMin"
        case acceptorShiftTotalMins = "acceptorShiftTotalMins"
        case acceptorShiftTotalMinsAfterSwap = "acceptorShiftTotalMinsAfterSwap"
        case acceptorName = "acceptorName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        swapperOvertimeMin = try values.decodeIfPresent(Int.self, forKey: .swapperOvertimeMin)
        swapperShiftTotalMins = try values.decodeIfPresent(Int.self, forKey: .swapperShiftTotalMins)
        swapperShiftTotalMinsAfterSwap = try values.decodeIfPresent(Int.self, forKey: .swapperShiftTotalMinsAfterSwap)
        swapperName = try values.decodeIfPresent(String.self, forKey: .swapperName)
        acceptorOvertimeMin = try values.decodeIfPresent(Int.self, forKey: .acceptorOvertimeMin)
        acceptorShiftTotalMins = try values.decodeIfPresent(Int.self, forKey: .acceptorShiftTotalMins)
        acceptorShiftTotalMinsAfterSwap = try values.decodeIfPresent(Int.self, forKey: .acceptorShiftTotalMinsAfterSwap)
        acceptorName = try values.decodeIfPresent(String.self, forKey: .acceptorName)
    }

}


struct SwapAcceptReject : Codable {
    let id : Int?
    let shift_id : Int?
    let status : String?
    let assignees : String?
    let comments : String?
    //    let users : [String]?
    let from_user : Int?
    let to_user : Int?
    let approved_by : Int?
    let rejected_by_users : [Int]?
    let approved_by_users : [Int]?
    let swap_type : String?
    let swapped_shift_id : String?
    let createdAt : String?
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case shift_id = "shift_id"
        case status = "status"
        case assignees = "assignees"
        case comments = "comments"
        //        case users = "users"
        case from_user = "from_user"
        case to_user = "to_user"
        case approved_by = "approved_by"
        case rejected_by_users = "rejected_by_users"
        case approved_by_users = "approved_by_users"
        case swap_type = "swap_type"
        case swapped_shift_id = "swapped_shift_id"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        shift_id = try values.decodeIfPresent(Int.self, forKey: .shift_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        assignees = try values.decodeIfPresent(String.self, forKey: .assignees)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        //        users = try values.decodeIfPresent([String].self, forKey: .users)
        from_user = try values.decodeIfPresent(Int.self, forKey: .from_user)
        to_user = try values.decodeIfPresent(Int.self, forKey: .to_user)
        approved_by = try values.decodeIfPresent(Int.self, forKey: .approved_by)
        rejected_by_users = try values.decodeIfPresent([Int].self, forKey: .rejected_by_users)
        approved_by_users = try values.decodeIfPresent([Int].self, forKey: .approved_by_users)
        swap_type = try values.decodeIfPresent(String.self, forKey: .swap_type)
        swapped_shift_id = try values.decodeIfPresent(String.self, forKey: .swapped_shift_id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}

struct RequestShiftsForPm : Codable {
    let rows : [RequestShift]?
    let pages : Int?

    enum CodingKeys: String, CodingKey {

        case rows = "rows"
        case pages = "pages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rows = try values.decodeIfPresent([RequestShift].self, forKey: .rows)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
    }

}

struct SwapAcceptRejectPM : Codable {
    let id : Int?
    let shift_id : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case shift_id = "shift_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        shift_id = try values.decodeIfPresent(Int.self, forKey: .shift_id)
    }

}

struct ShiftCountModal : Codable {
    let shiftCount : Int?
    let availabilityCount : Int?
    let grabCount : Int?
    let swapTradeCount : Int?

    enum CodingKeys: String, CodingKey {

        case shiftCount = "shiftCount"
        case availabilityCount = "availabilityCount"
        case grabCount = "grabCount"
        case swapTradeCount = "swapTradeCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shiftCount = try values.decodeIfPresent(Int.self, forKey: .shiftCount)
        availabilityCount = try values.decodeIfPresent(Int.self, forKey: .availabilityCount)
        grabCount = try values.decodeIfPresent(Int.self, forKey: .grabCount)
        swapTradeCount = try values.decodeIfPresent(Int.self, forKey: .swapTradeCount)
    }

}
