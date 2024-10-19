// ChatViewController.swift
import UIKit
import CoreData

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageInputField: UITextField!

    var messages = [Message]()  // Core Data Messages

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadMessages()  // Fetch saved messages
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageInputField.text, !text.isEmpty else { return }
        saveMessage(text, isUserMessage: true)
        callDialogflowAPI(with: text)
        messageInputField.text = ""
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.textLabel?.textAlignment = message.isUserMessage ? .right : .left
        return cell
    }

    // Load messages from Core Data
    func loadMessages() {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        do {
            messages = try PersistenceService.context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error loading messages: \(error)")
        }
    }

    // Save message to Core Data
    func saveMessage(_ text: String, isUserMessage: Bool) {
        let newMessage = Message(context: PersistenceService.context)
        newMessage.text = text
        newMessage.isUserMessage = isUserMessage
        newMessage.timestamp = Date()
        messages.append(newMessage)
        PersistenceService.saveContext()
        tableView.reloadData()
    }
}