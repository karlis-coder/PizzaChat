//
//  Constants.swift
//  PizzaChat
//
//  Created by Karlis Butins on 23/02/2021.
//  Copyright © 2021 Karlis Butins. All rights reserved.
//


// MARK: - a struct to redefine string identifiers

struct K {
    static let appName = "🍕PizzaChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"

    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
