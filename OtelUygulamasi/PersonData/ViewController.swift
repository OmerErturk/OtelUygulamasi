//
//  ViewController.swift
//  PersonData
//
//  Created by Alok Upadhyay on 3/28/18.
//  Copyright © 2018 Alok. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var people: [NSManagedObject] = []

  
  @IBAction func addName(_ sender: Any) {
    
    let alert = UIAlertController(title: "Yeni Müşteri Girişi",
                                  message: "Müşteri Bilgilerini Giriniz",
                                  preferredStyle: .alert)
    // Bildirim ekranı
    
    
    alert.addTextField(configurationHandler: { (textFieldName) in
      textFieldName.placeholder = "İsim Soyisim"
    })
    // 1.panel
    alert.addTextField(configurationHandler: { (textFieldSSN) in
      
      textFieldSSN.placeholder = "Oda Numarası"
    })
    //2.panel
    let saveAction = UIAlertAction(title: "Kaydet", style: .default) { [unowned self] action in
      
      guard let textField = alert.textFields?.first,
        let nameToSave = textField.text else {
          return
      }
      
      guard let textFieldSSN = alert.textFields?[1],
        let SSNToSave = textFieldSSN.text else {
          return
      }
      
        self.save(name: nameToSave, ssn: Int16(Int(SSNToSave)!))
        
      self.tableView.reloadData()
    }
    
    let cancelAction = UIAlertAction(title: "Kapat",
                                     style: .default)
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  //insert
  func save(name: String, ssn : Int16) {
    
    let person = CoreDataManager.sharedManager.insertPerson(name: name, ssn: ssn)
    
    if person != nil {
      people.append(person!)
      tableView.reloadData()
    }
  }
  
  @IBAction func deleteAction(_ sender: Any) {
    
    /* başlık ve mesaj içeren init uyarı kontrolörü */
    let alert = UIAlertController(title: "Müşteri Sil", message: "Oda numarasını giriniz", preferredStyle: .alert)
    
    /*silme işlemini yapılandır*/
    let deleteAction = UIAlertAction(title: "Sil", style: .default) { [unowned self] action in
      guard let textField = alert.textFields?.first , let itemToDelete = textField.text else {
        return
      }
      /*silmek için oda numarasını ilet (:) yöntemi*/
      self.delete(ssn: itemToDelete)
      /*tablo görünümünü yeniden yükle*/
      self.tableView.reloadData()
      
    }
    
     /* iptal eylemini yapılandır */
    let cancelAciton = UIAlertAction(title: "Kapat", style: .default)
    
    /* metin alanı ekleme */
    alert.addTextField()
    /* eylem ekleme*/
    
    alert.addAction(deleteAction)
    alert.addAction(cancelAciton)
    
    present(alert, animated: true, completion: nil)
  }
  
  func delete(ssn: String) {
    
    let arrRemovedObjects = CoreDataManager.sharedManager.delete(ssn: ssn)
    people = people.filter({ (param) -> Bool in
      
      if (arrRemovedObjects?.contains(param as! Person))!{
        return false
      }else{
        return true
      }
    })
    
  }
  
  func fetchAllPersons(){

    if CoreDataManager.sharedManager.fetchAllPersons() != nil{
      
      people = CoreDataManager.sharedManager.fetchAllPersons()!

    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchAllPersons()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "Cell")
  }
  
  func delete(person : Person){
    CoreDataManager.sharedManager.delete(person: person)
  }
  
  func update(name:String, ssn : Int16, person : Person) {
    CoreDataManager.sharedManager.update(name: name, ssn: ssn, person: person)
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let person = people[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    return cell
}
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    /* yönetilen nesne alma */
    let person = people[indexPath.row]
    
    /* uyarı denetleme */
    let alert = UIAlertController(title: "Güncelle",
                                  message: "İsmi Güncelle",
                                  preferredStyle: .alert)
    
    /* ad metin alanı ekleme */
    alert.addTextField(configurationHandler: { (textFieldName) in
      
      /*metin alanında isim yeri tutucu */
      textFieldName.placeholder = "isim"
      
      /*"isim" anahtarının değerini almak ve UITextField öğesinin metni olarak ayarlama */
      textFieldName.text = person.value(forKey: "isim") as? String
      
    })
    
    /*add ssn textfield*/
    alert.addTextField(configurationHandler: { (textFieldSSN) in
      
      /*set ssn as plaveholder in textfield*/
      textFieldSSN.placeholder = "ssn"
      
      /*use key value coding to get value for key "ssn" and set it as text of UITextField.*/
      
      textFieldSSN.text = "\(person.value(forKey: "ssn") as? Int16 ?? 0)"
    })
    
    /*güncelleme olayını yapılandır*/
    let updateAction = UIAlertAction(title: "Güncelle", style: .default) { [unowned self] action in
      
      guard let textField = alert.textFields?[0],
        let nameToSave = textField.text else {
          return
      }
      
      guard let textFieldSSN = alert.textFields?[1],
        let SSNToSave = textFieldSSN.text else {
          return
      }
      
      self.update(name : nameToSave, ssn: Int16(SSNToSave)!, person : person as! Person)
      
      /*son olarak tablo görünümünü yeniden yükle*/
      self.tableView.reloadData()
      
    }
    
    /*silme olayını yapılandır*/
    let deleteAction = UIAlertAction(title: "Sil", style: .default) { [unowned self] action in
      
      /*silme yöntemini */
      
      self.delete(person : person as! Person)
      
      /* Veri nesnesinin doğru verilere sahip olması için kişi nesne dizisi*/
      self.people.remove(at: (self.people.index(of: person))!)
      
      /*Son olarak tablo görünümünü yeniden gör*/
      self.tableView.reloadData()
      
    }
    
    /*iptal işlemini yapılandır*/
    let cancelAction = UIAlertAction(title: "İptal Et",
                                     style: .default)
    
    /*tüm eylemleri ekle*/
    alert.addAction(updateAction)
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    
    /*Son*/
    present(alert, animated: true)
    
  }
}
