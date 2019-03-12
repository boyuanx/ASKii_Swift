//
//  FirebaseUtility.swift
//  askUSC
//
//  Created by Boyuan Xu on 1/9/19.
//  Copyright © 2019 Boyuan Xu. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseCustomError: Error {
    case encodingError(String)
}

extension Encodable {
    func toJSON(excluding keys: [String] = [String]()) throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let JSONObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var JSON = JSONObject as? [String: Any] else {
            throw FirebaseCustomError.encodingError("Error when encoding JSON object.")
        }
        for key in keys {
            JSON[key] = nil
        }
        return JSON
    }
}

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingID: Bool = true) throws -> T {
        let documentJSON = data()
        let documentData = try JSONSerialization.data(withJSONObject: documentJSON!, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObject
    }
}

class FirebaseUtility {
    
    static var shared = FirebaseUtility()
    private init() {}
    
    let userRef = Firestore.firestore().collection("users")
    let OH_Ref = Firestore.firestore().collection("OH")
    let class_ref = Firestore.firestore().collection("classes")
}

extension FirebaseUtility {
    
    // MARK: - Saving user to db
    func saveUserToDatabaseIfNotExists(user: User, completion: @escaping (String?) -> Void) {
        let thisUserRef = userRef.document(user.userID)
        thisUserRef.getDocument { (snapshot, error) in
            if let error = error {
                 completion(error.localizedDescription)
            }
            if let snapshot = snapshot, snapshot.exists {
                // User record exists
                // Update existing user record (ONLY email, firstName, lastName)
                try? thisUserRef.setData(user.toJSON(), mergeFields: ["email", "firstName", "lastName"], completion: { (error) in
                    if let error = error {
                        completion(error.localizedDescription)
                    }
                    completion(nil)
                })
            } else {
                // User record doesn't exist yet
                try? thisUserRef.setData(user.toJSON(), completion: { (error) in
                    if let error = error {
                        completion(error.localizedDescription)
                    }
                    completion(nil)
                })
            }
        }
    }
    
    // MARK: - Registering for a class
    func registerClass(user: User, classID: String, completion: @escaping (String?) -> Void) {
        class_ref.whereField("classID", isEqualTo: classID).getDocuments { (snapshot, error) in
            if (snapshot?.isEmpty ?? false || error != nil) {
                completion(error?.localizedDescription ?? "Class does not exist.")
            }
            if (snapshot?.count != 1) {
                completion("There is an inconsistency in the database (duplicated classes), please report this issue! Thank you!")
            }
            let classResult = snapshot?.documents[0]
            do {
                var classResultObject = try classResult?.decode(as: Class.self)
                if (classResultObject?.studentsUID.contains(user.userID) ?? true) {
                    completion("You are already enrolled in this class.")
                } else {
                    classResultObject?.studentsUID.append(user.userID)
                    classResult?.reference.updateData(["studentsUID": (classResultObject?.studentsUID)!], completion: { (error) in
                        if let error = error {
                            completion(error.localizedDescription)
                        }
                        completion(nil)
                    })
                }
            } catch let error {
                completion("This client is outdated. \(error.localizedDescription)")
            }
        }
        
    }
    
}
