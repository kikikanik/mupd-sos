
import Foundation

struct Profile: Codable {
    var userID: String    //using this id to connect to id under User object
    var allergies: String
    var dob: String
    var emerContName: String
    var emerContPhone: String
    var emerContRelat: String
    var eyeColor: String
    var firstName: String
    var hairColor: String
    var height: String
    var homeAddress: String
    var lastName: String
    var medicalConditions: String
    var phone: String
    var schoolAddress: String
    var weight: String
    
    init(userID: String, allergies: String, dob: String, emerContName: String, emerContPhone: String, emerContRelat: String, eyeColor: String, firstName: String, hairColor: String, height: String, homeAddress: String, lastName: String, medicalConditions: String, phone: String, schoolAddress: String, weight: String) {
        //constructs the Profile Object
        self.userID = userID
        self.allergies = allergies
        self.dob = dob
        self.emerContName = emerContName
        self.emerContPhone = emerContPhone
        self.emerContRelat = emerContRelat
        self.eyeColor = eyeColor
        self.firstName = firstName
        self.hairColor = hairColor
        self.height = height
        self.homeAddress = homeAddress
        self.lastName = lastName
        self.medicalConditions = medicalConditions
        self.phone = phone
        self.schoolAddress = schoolAddress
        self.weight = weight
    }
    
    init?(data: [String: Any], documentID: String) {
        guard let userID = data["userID"] as? String,
              let allergies = data["allergies"] as? String,
              let dob = data["dob"] as? String,
              let emerContName = data["emerContName"] as? String,
              let emerContPhone = data["emerContPhone"] as? String,
              let emerContRelat = data["emerContRelat"] as? String,
              let eyeColor = data["eyeColor"] as? String,
              let firstName = data["firstName"] as? String,
              let hairColor = data["hairColor"] as? String,
              let height = data["height"] as? String,
              let homeAddress = data["homeAddress"] as? String,
              let lastName = data["lastName"] as? String,
              let medicalConditions = data["medicalConditions"] as? String,
              let phone = data["phone"] as? String,
              let schoolAddress = data["schoolAddress"] as? String,
              let weight = data["weight"] as? String else {
            return nil
        }
        self.userID = userID
        self.allergies = allergies
        self.dob = dob
        self.emerContName = emerContName
        self.emerContPhone = emerContPhone
        self.emerContRelat = emerContRelat
        self.eyeColor = eyeColor
        self.firstName = firstName
        self.hairColor = hairColor
        self.height = height
        self.homeAddress = homeAddress
        self.lastName = lastName
        self.medicalConditions = medicalConditions
        self.phone = phone
        self.schoolAddress = schoolAddress
        self.weight = weight
    }
    
    func createProfileDict() -> [String: Any] {
        return ["userID": self.userID,
                "allergies": self.allergies,
                "dob": self.dob,
                "emerContName": self.emerContName,
                "emerContPhone": self.emerContPhone,
                "emerContRelat": self.emerContRelat,
                "eyeColor": self.eyeColor,
                "firstName": self.firstName,
                "hairColor": self.hairColor,
                "height": self.height,
                "homeAddress": self.homeAddress,
                "lastName": self.lastName,
                "medicalConditions": self.medicalConditions,
                "phone": self.phone,
                "schoolAddress": self.schoolAddress,
                "weight": self.weight
        ]
    }
}
