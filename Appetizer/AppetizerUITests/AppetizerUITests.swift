//
//  AppetizerUITests.swift
//  AppetizerUITests
//
//  Created by Shady Adel on 15/07/2023.
//

import XCTest

final class AppetizerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testwithInvalidPassword() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Choose your Appetizer"].buttons["Login"].tap()
        app.textFields["Username"].typeText("shadyadel")
        
        //test password textfield
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(passwordTextField.isEnabled)

        app.buttons["Log in"].tap()
        
        // test wrong password alert
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(passwordTextField.isEnabled)
        passwordSecureTextField.tap()
        passwordTextField.typeText("1111")
        app/*@START_MENU_TOKEN@*/.staticTexts["Log in"]/*[[".buttons[\"Log in\"].staticTexts[\"Log in\"]",".staticTexts[\"Log in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let passwordInvalidAlert = app.alerts["Oops"].scrollViews.otherElements
        XCTAssertTrue(passwordInvalidAlert.element.exists)
        passwordInvalidAlert.staticTexts["Oops"].tap()
        passwordInvalidAlert.buttons["OK"].tap()
    
        app.terminate()
    }
    
    func testwithInvalidUsername() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Choose your Appetizer"].buttons["Login"].tap()
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        
        let logInStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Log in"]/*[[".buttons[\"Log in\"].staticTexts[\"Log in\"]",".staticTexts[\"Log in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        logInStaticText.tap()
        
        // test empty textfield alert
        let elementsQuery = app.alerts["Oops"].scrollViews.otherElements
        let blankAlert = elementsQuery.staticTexts["We can't proceed because one of the fields is blank. Please note that all fields are required."]
        XCTAssertTrue(blankAlert.exists)
        blankAlert.tap()
        
        let okButton = elementsQuery.buttons["OK"]
        XCTAssertTrue(okButton.exists)
        XCTAssertTrue(okButton.isEnabled)
        okButton.tap()
        
        usernameTextField.tap()
        usernameTextField.typeText("qwer")
        logInStaticText.tap()
        okButton.tap()
        
        // test wrong username alert
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("1111")
        app.buttons["Log in"].tap()
        
        let usernameInvalidalert = elementsQuery.staticTexts["Username is incorrect"]
        XCTAssertTrue(usernameInvalidalert.exists)
        okButton.tap()
        
        app.terminate()
        
    }
    
    func testWithRightCredential() throws{
        let app = XCUIApplication()
        app.launch()
        
        //choose cell
        let cell = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Crispy Fish Goujons ")/*[[".cells.containing(.staticText, identifier:\"Crispy Fish Goujons \")",".cells.containing(.staticText, identifier:\"516 kcal\")"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 2)
        cell.waitForExistence(timeout: 2)
        XCTAssertTrue(cell.exists)
        cell.tap()
        
        //test seque alert
        let elementsQuery = app.alerts["Oops"].scrollViews.otherElements
        let firstalert = elementsQuery.staticTexts["We can't proceed to details as you didn't log in"]
        firstalert.waitForExistence(timeout: 2)
        firstalert.tap()
        XCTAssertTrue(firstalert.exists)
        let alertButton =  elementsQuery.buttons["OK"]
        XCTAssertTrue(alertButton.exists)
        alertButton.tap()
        
        // test login button
        let navigationButton = app.navigationBars["Choose your Appetizer"].buttons["Login"]
        XCTAssertTrue(navigationButton.exists)
        XCTAssertTrue(navigationButton.isEnabled)
        app.navigationBars["Choose your Appetizer"].buttons["Login"].tap()
        
        // test username textfield
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        app.textFields["Username"].tap()
        XCTAssertTrue(usernameTextField.isEnabled)
        app.textFields["Username"].typeText("shadyadel")
        
        //test password textfield
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        XCTAssertTrue(passwordSecureTextField.isEnabled)
        passwordSecureTextField.typeText("1234")
        
        // test login button validator
       let loginButton =  app/*@START_MENU_TOKEN@*/.buttons["Log in"].staticTexts["Log in"]/*[[".buttons[\"Log in\"].staticTexts[\"Log in\"]",".staticTexts[\"Log in\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        XCTAssertTrue(loginButton.isEnabled)
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
        //test segue after unlock
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"516 kcal")/*[[".cells.containing(.staticText, identifier:\"Crispy Fish Goujons \")",".cells.containing(.staticText, identifier:\"516 kcal\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 2).tap()
        
        //test exist of first cell
        let firstcell = tablesQuery.staticTexts["516 kcal"]
        XCTAssertTrue(firstcell.exists)
        firstcell.swipeUp(velocity: 50)
        firstcell.swipeDown(velocity: 50)
        
        //test favourite button in detail view
        let heartButton = tablesQuery.buttons["love"]
        XCTAssertTrue(heartButton.exists)
        XCTAssertTrue(heartButton.isEnabled)
        heartButton.tap()
        
        // test back button
        let backButton = app.navigationBars["Appetizer.RecipeDetailView"].buttons["Choose your Appetizer"]
        XCTAssertTrue(backButton.exists)
        XCTAssertTrue(backButton.isEnabled)
        backButton.tap()
        
        //test favorite mark on recipe list
        app.waitForExistence(timeout: 1)
        let element = tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"516 kcal")/*[[".cells.containing(.staticText, identifier:\"Crispy Fish Goujons \")",".cells.containing(.staticText, identifier:\"516 kcal\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 2)
        element.tap()
        tablesQuery.buttons["love"].tap()
        app.navigationBars["Appetizer.RecipeDetailView"].buttons["Choose your Appetizer"].tap()
        app.waitForExistence(timeout: 2)
        app.terminate()
                                
    }
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
