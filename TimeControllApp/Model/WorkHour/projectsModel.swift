//
//  projectsModel.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 06/11/22.
//

import Foundation

struct projectsModel : Codable {
    let id : Int?
    let fullname : String?
    let number : Int?
    let assigned_users : [Int]?
    let assignee_id : Int?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fullname = "fullname"
        case number = "number"
        case assigned_users = "assigned_users"
        case assignee_id = "assignee_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
        number = try values.decodeIfPresent(Int.self, forKey: .number)
        assigned_users = try values.decodeIfPresent([Int].self, forKey: .assigned_users)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
    }

}
