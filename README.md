<div  align="center">
<h1> Team Creator 
by Furkan Melik Demiray & Agah Berkin Güler </h1>
</div>
 
Welcome to Team Creator. This app allows user to create sport matches with their selection of the players for selected sport.

##Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Usage](#usage)


## Features
 **Players Section:**
 - Users can add new players to selected sport, and edit or delete the existing player.
 
**Create Match Screen:**
- Users can choose various players for different positions to create matches.
- After match creation users can check their teams and team players in their position. 
- Users also can look for the weather for their location.

## Tech Stack
- **Xcode:** Version 15.4
- **Language:** Swift 5.10
 
 
## Architecture

In developing Team Creator app, MVVM (Model - View - ViewModel) is being use for these key reasons:

- **Separation of Concerns:**  MVVM separates the user interface from the business logic, making the code more maintainable and testable.
- **Reusability:** By isolating business logic in the ViewModel, you can reuse the same logic across different views.
- **Simplified Maintenance:** MVVM helps in managing complex UIs and business logic, leading to easier updates and improvements.


## Usage

### Listing Players
1. Open the app on your smilator or device.
2. Choose your sport category, continue with players section.
3. Existing player will be displayed on your screen. 

### Adding a New Player
1. In player screen tap the + button in the navigation bar.
2. Filled the empty space's with your player information.
3. Tapped the Add Player button to add player into the database.

### Player Detail
1. In player screen tap the exiting player to see their detailed information.
2. Players can be able edited with the Edit button in the navigation bar.

### PLayer Detail - Edit or Delete
1. In player detail screen tap the Edit button for the change the information of the selected player.
2. After changes made, player changes saved by tapping the save button or be removed by tapping the discard button.
3. Players can be deleted by tapping the Delete button.

### Create Match
1. After choosing category for the sports, continue with create match section.
2. Exiting players will be seen at the list with their position and skill overall informations.
3. After selection of the players, continue with Continue button.

### Match Detail
1. By clicking the teams button team players can be seen as an opposite.
2. Players line ups as been seen after clicking the team logos.
