// Meap__GameUITests.swift
//
// Worked on by: Desmond Trang
// Team Name: Meaps
//
// Changlog: - Created helper functions, Nov 1st 2018
//           - Created verification test cases, Nov 3rd 2018
//           - Created game play test cases, Nov 4th 2018
//           - Updated function names, Nov 5th 2018
//
// Known Bugs: - Could not call functions on GameScene.swift so I created
//               a workaround by tapping on coordinate on the game board
//             - Test cases were failing because of searching for misnamed labels

import XCTest


class MEAPUITest: XCTestCase {
    
    // Variables Initialized
    
    let app = XCUIApplication()
    var number:String!
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Setup to be initialized for every test case
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
        
        // landscape orientation is set arbitrarily to the left
        XCUIDevice.shared.orientation = .landscapeLeft
    }
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Functions to be used in the UI Test Cases
    //
    // Format:  Description of the function
    //          Expected output of the function
    //          Reason for function failure
    
    private func CheckTextExists (labelText: String) {
        
        // Description: Checks the current screen to see if the label
        //              passed in the argument is present.
        //
        // Expected Result: XC Assert returns true and test proceeds.
        //
        // Error: Label is not present in the current screen.
        
        XCTAssertTrue(app.staticTexts[labelText].exists)
    }
    
    private func CheckButtonExists (buttonLabel: String) {
        
        // Description: Checks the current screen to see if the button
        //              label passed in the argument is present.
        //
        // Expected Result: XC Assert returns true and test proceeds.
        //
        // Error: Button label is not present in the current screen.
        
        XCTAssertTrue(app.buttons[buttonLabel].exists)
    }
    
    private func CheckPageIndicatorExists () {
        
        // Description: Checks the current screen to see if the page
        //              indicators are present.
        //
        // Expected Result: XC Assert returns true and test proceeds.
        //
        // Error: Page indicators is not present in the current screen.
        
        XCTAssert(app.pageIndicators["page 1 of 1"].exists)
    }
    
    private func ClickButton (buttonLabel: String) {
        
        // Description: Clicks the button on the screen with the label
        //              passed in the argument.
        //
        // Expected Result: Button is pressed.
        //
        // Error: Button label is not present in the current screen.
        
        app.buttons[buttonLabel].tap()
    }
    
    private func TapCoordinate (xCoordinate: Double, yCoordinate: Double) {
        
        // Description: Simulates a user touch at the coordinate in the argument.
        //              Code taken from "https://stackoverflow.com/questions/36285090/how-to-tap-on-a-specific-point-using-xcode-uitests", user : JJacquet and Jakub
        //
        // Expected Result: The coordinate is pressed.
        //
        // Error: Coordinate is not within the screen.
        
        let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.tap()
    }
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // UI Test Cases - Verify that all screen elements are present
    //
    // Format:  Description of test case
    //          Expected Elements on the screen
    //          Steps for manual reproduction
    
    func TestCheckHomePage() {
        
        // Description: Verify that all elements in the Home Screen are present.
        //
        // Expected: Text: "MEAP"
        //           Buttons: "Menu", "How To", "Start"
        //
        // Steps:    1) Open MEAP app
        //           2) Verify elements
        
        // Verify
        CheckTextExists(labelText: "MEAP")
        CheckButtonExists(buttonLabel: "Menu")
        CheckButtonExists(buttonLabel: "How To")
        CheckButtonExists(buttonLabel: "Start")
    }
    
    func TestCheckMenuPage() {
        
        // Description: Verify that all elements in the Menu Screen are present.
        //
        // Expected: Text: "Menu"
        //           Buttons: "History Button", "Return Button", "How To"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Menu" button
        //           3) Verify elements
        
        // Pre-Condition
        ClickButton(buttonLabel: "Menu")
        
        // Verify
        CheckTextExists(labelText: "MENU")
        CheckButtonExists(buttonLabel: "History Button")
        CheckButtonExists(buttonLabel: "Return Button")
        CheckButtonExists(buttonLabel: "How To")
    }
    
    func TestCheckTutorialPage() {
        
        // Description: Verify that all elements in the Tutorial Screen are present.
        //
        // Expected: Text: "HOW - TO"
        //           Buttons: "Back Arrow", "Pattern Completion Button"
        //
        // Steps:    1) Open Meap app
        //           2) Click "How To" button
        //           3) Verify elements
        
        // Pre-Condition
        ClickButton(buttonLabel: "How To")
        
        // Verify
        CheckTextExists(labelText: "HOW - TO")
        CheckButtonExists(buttonLabel: "Pattern Completion Button")
        CheckButtonExists(buttonLabel: "Back Arrow")
    }
    
    func testStartButton() {
        
        // Verify that clicking the "Start" button will initiate the countdown timer
        // with the correct labels.
        //
        // Expected: Text: "Start", "3", "2", "1"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Verify elements
        
        ClickButton(buttonLabel: "Start")
        CheckTextExists(labelText: "3")
        sleep(1) // countdown delay
        CheckTextExists(labelText: "2")
        sleep(1) // countdown delay
        CheckTextExists(labelText: "1")
        
    }
    
    func TestCheckPatternCompletionPage() {
        
        // Verify that all elements in the Pattern Completion page are present.
        //
        // Expected: Text: "Pattern Completion", "SCORE", "BEST",
        //                  "Please memorize the above pattern."
        //           Buttons: "Pause Button", "Next Button", "How To"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Verify elements
        
        // Pre-Condition
        ClickButton(buttonLabel: "Start")
        sleep(5) // countdown delay
        
        // Verify
        CheckTextExists(labelText: "Pattern Completion")
        CheckTextExists(labelText: "SCORE")
        CheckTextExists(labelText: "BEST")
        CheckTextExists(labelText: "Please memorize the above pattern.")
        CheckButtonExists(buttonLabel: "Pause Button")
        CheckButtonExists(buttonLabel: "How To")
        CheckButtonExists(buttonLabel: "Start Button")
    }
    
    func TestCheckPausePage() {
        
        // Verify that all elements in the Pause page are present.
        //
        // Expected: Text: "PAUSED"
        //           Buttons: "How To", "MuteMusic",
        //                    "Resume Button", "Quit Game Button"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Pause" button
        //           4) Verify elements

        // Pre-Condition
        ClickButton(buttonLabel: "Start")
        sleep(5) // countdown delay
        ClickButton(buttonLabel: "Pause Button")
        sleep(1) // button lag
        
        // Verify
        CheckTextExists(labelText: "PAUSED")
        CheckButtonExists(buttonLabel: "How To")
        CheckButtonExists(buttonLabel: "MuteMusic")
        CheckButtonExists(buttonLabel: "Resume Button")
        CheckButtonExists(buttonLabel: "Quit Game Button")
    }
    
    func TestCheckPatternCompletionGameplayPage() {
        
        // Verify that all elements in the Pattern Completion page are present
        // when the "Start" button is pressed.
        //
        // Expected: Text: "Pattern Completion", "SCORE", "BEST",
        //                  "Number of Blocks Left: 3"
        //           Buttons: "Pause Button", "Next Button", "How To"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Start" button
        //           4) Verify elements
        
        // Pre-Condition
        ClickButton(buttonLabel: "Start")
        sleep(5) // countdown delay
        ClickButton(buttonLabel: "Start Button")
        sleep(1) // button lag
        
        // Verify
        CheckTextExists(labelText: "Pattern Completion")
        CheckTextExists(labelText: "SCORE")
        CheckTextExists(labelText: "BEST")
        CheckTextExists(labelText: "Number of Blocks Left: 3")
        CheckButtonExists(buttonLabel: "Pause Button")
        CheckButtonExists(buttonLabel: "How To")
        CheckButtonExists(buttonLabel: "Next Button")
    }
    
    func TestCheckScorePage() {
        
        // Verify that all elements in the Scores page are present.
        //
        // Expected: Text: "SCORES", "SCORE", "BEST"
        //           Buttons: "Forward", "How To"
        //           Page indicators
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Start" button
        //           4) Click 3 different blue cells in the table
        //           5) Click "Next" button
        //           6) Verify elements
        
        // Pre-Condition
        ClickButton(buttonLabel: "Start")
        sleep(5) // countdown delay
        ClickButton(buttonLabel: "Start Button")
        TapCoordinate(xCoordinate: 400, yCoordinate: 300)
        TapCoordinate(xCoordinate: 430, yCoordinate: 300)
        TapCoordinate(xCoordinate: 460, yCoordinate: 300)
        ClickButton(buttonLabel: "Next Button")
        
        // Verify
        CheckTextExists(labelText: "SCORES")
        CheckTextExists(labelText: "SCORE")
        CheckTextExists(labelText: "BEST")
        CheckButtonExists(buttonLabel: "How To")
        CheckButtonExists(buttonLabel: "Forward Button")
        CheckPageIndicatorExists()
        
    }
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // UI Test Cases - Testing Game Play
    //
    // Format: Description
    //         Expected Elements
    //         Steps for manual reproduction
    
    func TestReturnFromTutorial() {
        
        // Test that the back arrow is able to transition app
        // from Tutorial Screen back to Home Screen.
        //
        // Expected: Text: "MEAP"
        //           Expected: Text: "MEAP"
        //           Buttons: "Menu", "How To", "Start"
        //
        // Steps:    1) Open MEAP app
        //           2) Click "How To" Button
        //           3) Click "Back Arrow" Button
        
        // Pre-Condition
        ClickButton(buttonLabel: "How To")
        ClickButton(buttonLabel: "Back Arrow")
        
        // Verify
        CheckTextExists(labelText: "MEAP")
        CheckButtonExists(buttonLabel: "Menu")
        CheckButtonExists(buttonLabel: "How To")
        CheckButtonExists(buttonLabel: "Start")
    }
    
    func TestResumeGame() {
        
        // Test that the game is able to be paused and resumed.
        // Verify that the correct screen is shown by looking for
        // the expected elements.
        //
        // Expected: Text: "Pattern Completion", "SCORE", "BEST",
        //                  "Please memorize the above pattern."
        //           Buttons: "Pause Button", "Next Button", "How To"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Pause" button
        //           4) Click "Resume" button
        //           5) Verify elements
        
        // Testing Resume
        ClickButton(buttonLabel: "Start")
        sleep(5) // countdown delay
        ClickButton(buttonLabel: "Pause Button")
        sleep(1) // button lag
        ClickButton(buttonLabel: "Resume Button")
        sleep(1) // button lag
        
        // Verify
        CheckTextExists(labelText: "Pattern Completion")
        CheckTextExists(labelText: "SCORE")
        CheckTextExists(labelText: "BEST")
        CheckTextExists(labelText: "Please memorize the above pattern.")
        CheckButtonExists(buttonLabel: "Pause Button")
        CheckButtonExists(buttonLabel: "Start Button")
        CheckButtonExists(buttonLabel: "How To")
    }
    
    func TestPlayGame() {
        
        // Test that the whole gameplay is able to complete from
        // start to finish.
        //
        // Expected: Text: "MEAP"
        //           Buttons: "Menu", "How To", "Start"
        //
        // Steps:    1) Open Meap app
        //           2) Click "Start" button
        //           3) Click "Start" button
        //           4) Click 3 different blue cells in the table
        //           5) Click "Next" button
        //           6) Verify elements
        
        // Gameplay
        ClickButton(buttonLabel: "Start")
        sleep(5) // countdown delay
        ClickButton(buttonLabel: "Start Button")
        TapCoordinate(xCoordinate: 400, yCoordinate: 300)
        TapCoordinate(xCoordinate: 430, yCoordinate: 300)
        TapCoordinate(xCoordinate: 460, yCoordinate: 300)
        ClickButton(buttonLabel: "Next Button")
        ClickButton(buttonLabel: "Forward Button")
        
        // Verify
        CheckTextExists(labelText: "MEAP")
        CheckButtonExists(buttonLabel: "Menu")
        CheckButtonExists(buttonLabel: "How To")
        CheckButtonExists(buttonLabel: "Start")
    }

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Test teardown after every test case
    
    override func tearDown() {
        super.tearDown()
    }
    
}
