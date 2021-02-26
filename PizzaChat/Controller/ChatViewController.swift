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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self //identify scrolling
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //  Listener for when the keyboard appears
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        //  Listener for when the keyboard disappears
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
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
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top , animated: true)
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
    // Add bottom constraint keyboard height when keyboard pops up
    @objc func keyboardWillShow(notification: NSNotification) {
        // Keyboard height - how far should it slide up
        if let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomConstraint.constant = endValue.height
                self.view.layoutIfNeeded()
            })
        }
    }

    // Add bottom constraint height
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}
 


// MARK: - UITableView cell drawing

    extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count  // how many cells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //cellForRowAt gets called as many times as there are cells
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell //force down casting tableview cell object as MessageCell subclass
        cell.label.text = message.body
        
        
        //This is a message from the current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            // redefine text color 
            //cell.label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
        //this is a messsage from another sender
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.3243189752, green: 0.8732073307, blue: 0.8275758624, alpha: 1)
         }
        
        return cell
    }
}
// MARK: - Identify scrolling and hide keyboard

extension ChatViewController: UITableViewDelegate {
    // Identify when scrolling starts
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // resignFirstResponder() hides keyboard
        messageTextfield.resignFirstResponder()
    }
}
