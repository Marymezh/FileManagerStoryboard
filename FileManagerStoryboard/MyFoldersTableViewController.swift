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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func createNewFolder(_ sender: Any) {
        let alertController = UIAlertController(title: "Create New Folder", message: nil, preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "Enter new foler name"
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            if let folderName = alertController.textFields?[0].text,
               folderName != "" {
                let newURL = self.url.appendingPathComponent(folderName)
                do {
                    try self.fileManager.createDirectory(
                        at: newURL,
                        withIntermediateDirectories: false)
                } catch {
                    self.showErrorAlert(text: "Unable to create new folder")
                }
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func createNewFile(_ sender: Any) {
        let alertController = UIAlertController(title: "Create new text file", message: nil, preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "Enter new file name"
        }
        alertController.addTextField { textfield in
            textfield.placeholder = "Enter the text to save in the new file"
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            if let fileName = alertController.textFields?[0].text,
               fileName != "",
               let contentsOfFile = alertController.textFields?[1].text,
               let data = contentsOfFile.data(using: .utf8){
                
                let newURL = self.url.appendingPathComponent(fileName)
                self.fileManager.createFile(
                    atPath: newURL.path,
                    contents: data,
                    attributes: [:])
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func createNewImage(_ sender: Any) {
        showImagePickerController()
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
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        cell.textLabel?.text = item.lastPathComponent
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listOfContents[indexPath.row]
        
        var isFolder: ObjCBool = false
        fileManager.fileExists(atPath: item.path, isDirectory: &isFolder)
        if isFolder.boolValue {
            let tvc = storyboard?.instantiateViewController(withIdentifier: "TableVC") as! MyFoldersTableViewController
            tvc.url = item
            navigationController?.pushViewController(tvc, animated: true)
            
        } else if let _ = UIImage(contentsOfFile: item.path)  {
            let imageVC = storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
            imageVC.fileURL = item
            navigationController?.present(imageVC, animated: true)
            
        } else {
            let textVC = storyboard?.instantiateViewController(withIdentifier: "TextVC") as! TextViewController
            textVC.fileURL = item
            navigationController?.present(textVC, animated: true)
        }
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

// MARK: - Image Picker Controller

extension MyFoldersTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let alertController = UIAlertController(title: "New Image", message: nil, preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "Enter image name"
        }
        
        let enterNameAction = UIAlertAction(title: "Save", style: .default) { action in
            if let newImageName = alertController.textFields?[0].text,
               newImageName != "",
               let data = image.pngData() {
                let imagePath = self.url.appendingPathComponent(newImageName)
                self.fileManager.createFile(
                    atPath: imagePath.path,
                    contents: data,
                    attributes: nil)
                self.tableView.reloadData()
            }
        }
        alertController.addAction(enterNameAction)
        present(alertController, animated: true)
    }
}

