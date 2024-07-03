//
//  UserDocumentsModel.swift
//  TimeControllApp
//
//  Created by prashant on 16/02/23.
//

import Foundation

struct UserDocumentsModel : Codable {
    let document_templates : [Document_templates]?
    let assigned_documents : [Assigned_documents]?
}

struct Document_templates : Codable {
    let id : Int?
    let template_name : String?
    let template_documents : String?
    let created_by_id : Int?
    let client_id : Int?
    let is_signature_required : Bool?
    let isobligatory : Bool?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case template_name = "template_name"
        case template_documents = "template_documents"
        case created_by_id = "created_by_id"
        case client_id = "client_id"
        case is_signature_required = "is_signature_required"
        case isobligatory = "isobligatory"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        template_name = try values.decodeIfPresent(String.self, forKey: .template_name)
        template_documents = try values.decodeIfPresent(String.self, forKey: .template_documents)
        created_by_id = try values.decodeIfPresent(Int.self, forKey: .created_by_id)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        is_signature_required = try values.decodeIfPresent(Bool.self, forKey: .is_signature_required)
        isobligatory = try values.decodeIfPresent(Bool.self, forKey: .isobligatory)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct Assigned_documents : Codable {
    let id : Int?
    let client_id : Int?
    let document_id : Int?
    let created_by_id : Int?
    let user_id : Int?
    let status : String?
    let read_at : String?
    let signature : String?
    let isobligatory : Bool?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case client_id = "client_id"
        case document_id = "document_id"
        case created_by_id = "created_by_id"
        case user_id = "user_id"
        case status = "status"
        case read_at = "read_at"
        case signature = "signature"
        case isobligatory = "isobligatory"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        document_id = try values.decodeIfPresent(Int.self, forKey: .document_id)
        created_by_id = try values.decodeIfPresent(Int.self, forKey: .created_by_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        read_at = try values.decodeIfPresent(String.self, forKey: .read_at)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        isobligatory = try values.decodeIfPresent(Bool.self, forKey: .isobligatory)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}
