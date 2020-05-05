//
//  PersonDataTests.swift
//  PersonDataTests
//
//  Created by Alok Upadhyay on 3/28/18.
//  Copyright © 2018 Alok. All rights reserved.
//

import XCTest
import CoreData
@testable import PersonData

class PersonDataTests: XCTestCase {
  
  /*creating a CoreDataManager object, we will use this object to test operations like insert, update & delete*/
  var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
      coreDataManager = CoreDataManager.sharedManager

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
    
  // MARK: Our test cases
  
  /*This test case test for the proper initialization of CoreDataManager class :)*/
    func test_init_coreDataManager(){
      
      let instance = CoreDataManager.sharedManager
      /*Asserts that an expression is not nil.
       Generates a failure when expression == nil.*/
      XCTAssertNotNil( instance )
    }
  
  /*This test case test if NSPersistentContainer(the actual core data stack) initializes successfully or not. In case it fails in getting a proper instance It will generate a failure.
   */
  func test_coreDataStackInitialization() {
    let coreDataStack = CoreDataManager.sharedManager.persistentContainer
    
    /*Asserts that an expression is not nil.
     Generates a failure when expression == nil.*/
    XCTAssertNotNil( coreDataStack )
  }
    
    /*This test case inserts a person record*/
    func test_create_person() {
      
      //Given the name & ssn
      let name1 = "Alok"
      let ssn1 = 123
      
      let name2 = "Naitvik"
      let ssn2 = 456
      
      let name3 = "Deepti"
      let ssn3 = 789
      
      let person1 = coreDataManager.insertPerson(name: name1, ssn: Int16(ssn1))
      
      /*Asserts that an expression is not nil.
       Generates a failure when expression == nil.*/
      XCTAssertNotNil( person1 )
      
      let person2 = coreDataManager.insertPerson(name: name2, ssn: Int16(ssn2))
      
      /*Asserts that an expression is not nil.
       Generates a failure when expression == nil.*/
      XCTAssertNotNil( person2 )
      
      let person3 = coreDataManager.insertPerson(name: name3, ssn: Int16(ssn3))
      
      /*Asserts that an expression is not nil.
       Generates a failure when expression == nil.*/
      XCTAssertNotNil( person3 )
      
    }
  
  /*This test case fetches all person records*/
    func test_fetch_all_person() {
      
      //get personRecord already saved
      
      let results = coreDataManager.fetchAllPersons()
      
      //Assert return numbers of todo items
      //Asserts that two optional values are equal.
      XCTAssertEqual(results?.count, 3)
    }
  
  func test_remove_person() {
    
    /*fetch all items*/
    let items = coreDataManager.fetchAllPersons()
    /*get first item*/
    let person = items![0]
    
    /*total numbers of items*/
    let numberOfItems = items?.count
    
    //remove a item
    coreDataManager.delete(person: person)
    
    //Assert number of item - 1. That is after deleting a item, sut.fetchAllPersons()?.count should be equal to numberOfItems!-1.
    XCTAssertEqual(coreDataManager.fetchAllPersons()?.count, numberOfItems!-1)
  }
  
  func test_remove_person_ssn() {
    
    /*fetch all items*/
    let items = coreDataManager.fetchAllPersons()
    
    /*total numbers of items*/
    let numberOfItems = items?.count
    
    //remove a item
    coreDataManager.delete(ssn: "789")
    
    //Assert number of item - 1. That is after deleting a item, sut.fetchAllPersons()?.count should be equal to numberOfItems!-1.
    XCTAssertEqual(coreDataManager.fetchAllPersons()?.count, numberOfItems!-1)
  }
  
  func test_update_person(){
  
    /*fetch all items*/
    let items = coreDataManager.fetchAllPersons()
    /*get first item*/
    let person = items![0]
    let name = "John"
    let ssn = 999
    
    CoreDataManager.sharedManager.update(name: name, ssn: Int16(ssn), person: person)
    
    /*fetch all items*/
    let itemsFetched = coreDataManager.fetchAllPersons()
    /*get first item*/
    let personFetched = items![0]
    XCTAssertEqual(name, personFetched.name)
    XCTAssertEqual(ssn, Int(personFetched.ssn))

    
  }
  
  /*test if all data is deleted from store*/
  func test_flushData() {
    coreDataManager.flushData()
   
   /*this test case passes if fetchAllPerson returns 0 objects*/ XCTAssertEqual(coreDataManager.fetchAllPersons()?.count, 0)
  }
  
}
    

