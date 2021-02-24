//
//  ChatViewController.swift
//  PizzaChat
//
//  Created by Karlis Butins on 22/02/2021.
//  Copyright © 2021 Karlis Butins. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        
      
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in // get collection, order collection and snapshot listener retrieves new data with snapshotListener
            
            self.messages = []
            
            if let e = error {
                print("There was an issue retriving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {  // looping through documents in the firestore documents array
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody) //defining new message
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {  // fetch main thread process
                                self.tableView.reloadData() // trigger data source methods
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender, // who sent the message
                K.FStore.bodyField: messageBody, // what the message contains
                K.FStore.dateField: Date().timeIntervalSince1970 // date object for filtering messages
            ]) { (error) in
                if let e = error {
                    print("Can't save data to Firestore, \(e)")
                } else {
                    print("Data saved successfully.")

                    DispatchQueue.main.async {
                         self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}
    
// MARK: - UITableView cell drawing

    extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell //force down casting tableview cell object as MessageCell subclass
        cell.label.text = messages[indexPath.row].body
        return cell
    }

}


