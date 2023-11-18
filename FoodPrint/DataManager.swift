//
//  DataManager.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 13/11/2023.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseDatabase

class FirebaseDataManager {
    static func retrieveRecords(completion: @escaping ([Record]) -> Void) {
        let databaseRef = Database.database().reference()
        
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            var records: [Record] = []
            
            for childSnapshot in snapshot.children {
                if let dataSnapshot = childSnapshot as? DataSnapshot,
                   let recordData = dataSnapshot.value as? [String: Any],
                   let userId = recordData["UserId"] as? Int,
                   let recordId = recordData["RecordID"] as? Int,
                   let timestamp = recordData["Timestamp"] as? String,
                   let weight = recordData["Weight"] as? Double,
                   let height = recordData["Height"] as? Double,
                   let foodCategory = recordData["Food_category"] as? String,
                   let calories = recordData["Calories"] as? Int {
                    let record = Record(userId: userId, recordId: recordId, timestamp: timestamp, weight: weight, height: height, foodCategory: foodCategory, calories: calories)
                    records.append(record)
                }
            }
            
            completion(records)
        }
    }
    static func writeRecord(record: Record) {
        let databaseRef = Database.database().reference()
        
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            let databaseLength = snapshot.childrenCount
            let newRecordRef = databaseRef.child("\(databaseLength)")
            
            let recordData: [String: Any] = [
                "UserId": record.userId,
                "RecordID": record.recordId,
                "Timestamp": record.timestamp,
                "Weight": record.weight,
                "Height": record.height,
                "Food_category": record.foodCategory,
                "Calories": record.calories
            ]
            
            newRecordRef.setValue(recordData) { error, _ in
                if let error = error {
                    print("Error writing record to Firebase: \(error.localizedDescription)")
                } else {
                    print("Record written successfully.")
                }
            }
        }
    }
}

class Record {
    var userId: Int
    var recordId: Int
    var timestamp: String
    var weight: Double
    var height: Double
    var foodCategory: String
    var calories: Int
    
    init(userId: Int, recordId: Int, timestamp: String, weight: Double, height: Double, foodCategory: String, calories: Int) {
        self.userId = userId
        self.recordId = recordId
        self.timestamp = timestamp
        self.weight = weight
        self.height = height
        self.foodCategory = foodCategory
        self.calories = calories
    }
}

class YourViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the function to retrieve records
        FirebaseDataManager.retrieveRecords { records in
            // Use the records as needed
            print(records)
        }
    }
}
