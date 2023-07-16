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
    func testLoginWithWrongPassword() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        // Tap on "Login" button on the navigation bar
        app.navigationBars["Choose your Appetizer"].buttons["Login"].tap()
        
        // Enter the username
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        XCTAssertTrue(usernameTextField.isEnabled)
        usernameTextField.tap()
        usernameTextField.typeText("shadyadel")
        
        // Enter the password
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(passwordTextField.isEnabled)
        passwordTextField.tap()
        passwordTextField.typeText("1111")
        
        // Tap on "Log in" button
        let loginButton = app.buttons["Log in"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
        // Verify the alert for wrong password
        let passwordInvalidAlert = app.alerts["Oops"]
        XCTAssertTrue(passwordInvalidAlert.exists)
        XCTAssertEqual(passwordInvalidAlert.staticTexts["Oops"].label, "Oops")
        
        // Tap on "OK" button to dismiss the alert
        passwordInvalidAlert.buttons["OK"].tap()
        app.terminate()
    }
    
    func testLoginWithInvalidUsername() throws {
        let app = XCUIApplication()
        app.launch()
        // Tap on "Login" button on the navigation bar
        app.navigationBars["Choose your Appetizer"].buttons["Login"].tap()
        
        // Find the username text field and tap on it
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        
        // Find the "Log in" static text and tap on it
        let logInStaticText = app.staticTexts["Log in"]
        logInStaticText.tap()
        
        // Test empty text field alert
        let elementsQuery = app.alerts["Oops"].scrollViews.otherElements
        let blankAlert = elementsQuery.staticTexts["We can't proceed because one of the fields is blank. Please note that all fields are required."]
        XCTAssertTrue(blankAlert.exists)
        blankAlert.tap()
        
        // Find the "OK" button on the alert and tap on it
        let okButton = elementsQuery.buttons["OK"]
        XCTAssertTrue(okButton.exists)
        XCTAssertTrue(okButton.isEnabled)
        okButton.tap()
        
        // Clear the username text field, enter "qwer", and tap on "Log in" static text
        usernameTextField.tap()
        usernameTextField.typeText("qwer")
        logInStaticText.tap()
        
        // Test wrong username alert
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("1111")
        app.buttons["Log in"].tap()
        
        let usernameInvalidAlert = elementsQuery.staticTexts["Username is incorrect"]
        XCTAssertTrue(usernameInvalidAlert.exists)
        okButton.tap()
        
        app.terminate()
        
    }
    
    func testLoginWithValidCredentials() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Choose cell
        let cell = app.tables.cells.containing(.staticText, identifier: "Crispy Fish Goujons ").children(matching: .other).element(boundBy: 2)
        XCTAssertTrue(cell.waitForExistence(timeout: 2), "Cell exists")
        cell.tap()
        
        // Test segue alert
        let alert = app.alerts.element
        let alertText = alert.staticTexts["We can't proceed to details as you didn't log in"]
        XCTAssertTrue(alertText.exists, "Alert text exists")
        alertText.tap()
        
        let okButton = alert.buttons["OK"]
        XCTAssertTrue(okButton.exists, "OK button exists")
        okButton.tap()
        
        // Test login button
        let navigationButton = app.navigationBars["Choose your Appetizer"].buttons["Login"]
        XCTAssertTrue(navigationButton.exists, "Login button exists")
        XCTAssertTrue(navigationButton.isEnabled, "Login button is enabled")
        navigationButton.tap()
        
        // Test username textfield
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists, "Username textfield exists")
        XCTAssertTrue(usernameTextField.isEnabled, "Username textfield is enabled")
        usernameTextField.tap()
        usernameTextField.typeText("shadyadel")
        
        // Test password textfield
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists, "Password textfield exists")
        XCTAssertTrue(passwordSecureTextField.isEnabled, "Password textfield is enabled")
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("1234")
        
        // Test login button validator
        let loginButton = app.buttons["Log in"]
        XCTAssertTrue(loginButton.isEnabled, "Login button is enabled")
        XCTAssertTrue(loginButton.exists, "Login button exists")
        loginButton.tap()
        
        // Test segue after unlock
        let tablesQuery = app.tables
        let recipeCell = tablesQuery.staticTexts["516 kcal"]
        XCTAssertTrue(recipeCell.exists, "Recipe cell exists")
        recipeCell.tap()
        
        // Test favorite button in detail view
        let heartButton = app.buttons["love"]
        XCTAssertTrue(heartButton.exists, "Favorite button exists")
        XCTAssertTrue(heartButton.isEnabled, "Favorite button is enabled")
        heartButton.tap()
        
        // Test back button
        let backButton = app.navigationBars["Appetizer.RecipeDetailView"].buttons["Choose your Appetizer"]
        XCTAssertTrue(backButton.exists, "Back button exists")
        XCTAssertTrue(backButton.isEnabled, "Back button is enabled")
        backButton.tap()
        
        // Test favorite mark on recipe list
        let tableCell = app.tables.staticTexts["Crispy Fish Goujons "]
        XCTAssertTrue(tableCell.exists, "Recipe cell exists")
        tableCell.tap()
        heartButton.tap()
        backButton.tap()
        
        
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
