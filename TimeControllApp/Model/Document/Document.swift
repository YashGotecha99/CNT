//
//  Document.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 31/05/23.
//

import Foundation

struct DocumentModal : Codable {
    let rows : [DocumentRows]?

    enum CodingKeys: String, CodingKey {

        case rows = "rows"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rows = try values.decodeIfPresent([DocumentRows].self, forKey: .rows)
    }

}

struct DocumentRows : Codable {
    let id : Int?
    let template_name : String?
    let template_documents : String?
    let created_by_id : Int?
    let client_id : Int?
    let created_at : String?
    let updated_at : String?
    let is_signature_required : Bool?
    let isobligatory : Bool?
    let created_by : String?
    let user_id : Int?
    let status : String?
    let signature : String?
    let read_at : String?
    let mailReport : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case template_name = "template_name"
        case template_documents = "template_documents"
        case created_by_id = "created_by_id"
        case client_id = "client_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case is_signature_required = "is_signature_required"
        case isobligatory = "isobligatory"
        case created_by = "created_by"
        case user_id = "user_id"
        case status = "status"
        case signature = "signature"
        case read_at = "read_at"
        case mailReport = "mailReport"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        template_name = try values.decodeIfPresent(String.self, forKey: .template_name)
        template_documents = try values.decodeIfPresent(String.self, forKey: .template_documents)
        created_by_id = try values.decodeIfPresent(Int.self, forKey: .created_by_id)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        is_signature_required = try values.decodeIfPresent(Bool.self, forKey: .is_signature_required)
        isobligatory = try values.decodeIfPresent(Bool.self, forKey: .isobligatory)
        created_by = try values.decodeIfPresent(String.self, forKey: .created_by)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        read_at = try values.decodeIfPresent(String.self, forKey: .read_at)
        mailReport = try values.decodeIfPresent(Bool.self, forKey: .mailReport)
    }

}

struct DocumentPreviewModal : Codable {
    let path : String?

    enum CodingKeys: String, CodingKey {

        case path = "path"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }

}
