//
//  Validation.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 19.02.2024.
//

import Foundation

class Validation {
    
    //Validate email address logic
    func isValidMailInput(input: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: input)
    }
    
    //Validate email address logic
    func isValidMail(email: String) -> Bool {
        //Declaring the rule of characters to be used. Applying rule to current state. Verifying the result.
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: email)
        
        return result
    }
    
    //validate name logic
    func isValid(name: String) -> Bool {
        //Declaring the rule of characters to be used. Applying rule to current state. Verifying the result.
        let regex = "[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: name)
        
        return result
    }
    
    //    length 6 to 16.
    //    One Alphabet in Password.
    //    One Special Character in Password.
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,16}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: password)
        return result
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    //==========================
    //MARK: - PhoneNumber Validation
    //==========================
    func isValidPhoneNumber(_ PhoneNumber : String) -> Bool{
        let PHONE_REGEX = "^\\+\\d{1,3} \\(\\d{1,3}\\) \\d{3}-\\d{2}-\\d{2}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: PhoneNumber)
        return result
    }

    //==========================
    //MARK: - UserName Validation
    //==========================
    func isValidUsername(Username:String) -> Bool {
        let RegEx = "\\A\\w{4,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Username)
    }

//    let isPhonenumber:Bool = isValidPhoneNumber(PhoneNumber :"12345678923")
//    print(isPhonenumber)
//
//    let isUsername:Bool = isValidUsername(Username: "hemant550")
//    print(isUsername)
}

