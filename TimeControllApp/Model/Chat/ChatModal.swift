//
//  ChatModal.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 12/04/23.
//

import Foundation

struct ProjectRooms : Codable {
    let rooms : [Rooms]?

    enum CodingKeys: String, CodingKey {

        case rooms = "rooms"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rooms = try values.decodeIfPresent([Rooms].self, forKey: .rooms)
    }

}

struct Rooms : Codable {
    let id : Int?
    let name : String?
    let lastMessage : LastMessage?
    let room_initiator : Int?
    let fullname : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case lastMessage = "lastMessage"
        case room_initiator = "room_initiator"
        case fullname = "fullname"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        lastMessage = try values.decodeIfPresent(LastMessage.self, forKey: .lastMessage)
        room_initiator = try values.decodeIfPresent(Int.self, forKey: .id)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
    }

}


struct LastMessage : Codable {
    let message : String?
    let created_at : String?
//    let image : [Int]?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case created_at = "created_at"
//        case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        image = try values.decodeIfPresent([Int].self, forKey: .image)
    }

}


struct swapSwiftEmployeesModel : Codable {
    let availableusers : [Availableusers]?

    enum CodingKeys: String, CodingKey {

        case availableusers = "availableusers"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        availableusers = try values.decodeIfPresent([Availableusers].self, forKey: .availableusers)
    }
}


struct Availableusers : Codable {
    let id : Int?
    let username : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case username = "username"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
    }
}
