//
//  MyFoldersTableViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 06.09.2022.
//

import UIKit

class MyFoldersTableViewController: UITableViewController {
    
    private var fileManager = FileManager.default
    private lazy var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var listOfContents: [URL] {
        return (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)) ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createNewFolder(_ sender: Any) {
    }
    
    @IBAction func createNewFile(_ sender: Any) {
    }
    
    @IBAction func createNewImage(_ sender: Any) {
    }
    
    private func showErrorAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfContents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = listOfContents[indexPath.row]
        
        var isFolder: ObjCBool = false
        fileManager.fileExists(atPath: item.path, isDirectory: &isFolder)
        if isFolder.boolValue {
            cell.detailTextLabel?.text = "Folder"
            //         cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        } else {
            cell.detailTextLabel?.text = ""
        }
        cell.textLabel?.text = item.lastPathComponent
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = listOfContents[indexPath.row]
            do {
                try fileManager.removeItem(at: item)
            } catch {
                showErrorAlert(text: "Unable to delete this item")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
