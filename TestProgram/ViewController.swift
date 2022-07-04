//
//  ViewController.swift
//  TestProgram
//
//  Created by Валик Кабанченко on 23.06.2022.
//

import UIKit
import Contacts


class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  {
  
 
    var logoImages: [UIImage] =  [#imageLiteral(resourceName: "contact_image.jpeg") , #imageLiteral(resourceName: "group_image.jpeg") , #imageLiteral(resourceName: "dublicate_numbers.jpeg") , #imageLiteral(resourceName: "Снимок экрана 2022-06-23 в 16.31.03.png") , #imageLiteral(resourceName: "not_number.jpeg") , #imageLiteral(resourceName: "email_image.jpeg") ]
    
    var labelName : [String] = ["Все контакты","Дублирующиеся имена","Дублирующиеся номера","Нет имени","Нет номера","Нет емейла",]
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "IndexPathone", for: indexPath)
        cell.textLabel?.text = labelName[indexPath.row]
       
        cell.imageView?.image = logoImages[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelName.count
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
   
@IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var results: [CNContact] = []
        
        var dublicateName: [CNContact] = []
       
        let dublicatePhone: [CNContact] = []
              
        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor])

              fetchRequest.sortOrder = CNContactSortOrder.userDefault

              let store = CNContactStore()
        
        let crossReferenceName = Dictionary(grouping: dublicateName , by: { $0.givenName })
        
        
        let crossReferencePhone = Dictionary(grouping: dublicatePhone , by: { $0.phoneNumbers })
        let   duplicatesName = crossReferenceName
               .filter { $1.count > 1 }
               .sorted { $0.1.count > $1.1.count }
          
           
        let     duplicatesPhone = crossReferencePhone
               .filter { $1.count > 1 }
               .sorted { $0.1.count > $1.1.count }
              do {
                  
        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                      print(contact.phoneNumbers.first?.value ?? "no")
                      results.append(contact)
                     
                  
                  })
              }
              catch let error as NSError {
                  print(error.localizedDescription)
              }
        
        labelName =  ["Все контакты                                  \(results.count) >",
                      "Дублирующиеся имена              \(duplicatesName.count) >",
                      "Дублирующиеся номера            \(duplicatesPhone.count) >"
                    , "Без имени",
                      "Нет номера"
                    , "Нет емейла",]
    }

}
