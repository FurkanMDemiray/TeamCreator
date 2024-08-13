<p align="center">
  <img src="TeamCreator/TeamCreator/Resources/Assets.xcassets/AppIcon.appiconset/1024.jpg" alt="Team Creator App Icon" width="150" height="150">
</p>
<div  align="center">
<h1> Team Creator  </h1>
<h2> Furkan Melik Demiray & Agah Berkin Güler </h2>
</div>
 
Welcome to Team Creator. This app allows user to create sport matches with their selection of the players for selected sport.

## Table of Contents
- [Features](#features)
  - [Screenshots](#screenshots)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Instalation](#instalation)
- [Usage](#usage)
  - [Listing Players](#listing-players)
  - [Adding a New Player](#adding-a-new-player)
  - [Player Detail](#player-detail)
  - [Player Detail - Edit or Delete](#player-detail---edit-or-delete)
  - [Create Match](#create-match)
  - [Match Detail](#match-detail)
- [Known Issue](#known-issue)
- [Improvements](#improvements)


## Features
 **Players Section:**
 - Users can add new players to selected sport, and edit or delete the existing player.
 
**Create Match Screen:**
- Users can choose various players for different positions to create matches.
- After match creation users can check their teams and team players in their position. 
- Users also can look for the weather for their location.

## Screenshots

| Image 1                | Image 2                | Image 3                |
|------------------------|------------------------|------------------------|
| ![Onboarding](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/onboarding.png) | ![SportCategory](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/sports.png) | ![Menu](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/menu.png) |
| Onboarding | Sport Category Menu | Menu Screen |

| Image 4                | Image 5                | Image 6                |
|------------------------|------------------------|------------------------|
| ![Players](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/players.png) | ![AddPlayer](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/addplayer.png) | ![PlayerDetail](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/editplayer.png) |
| Players List | Add Player | Player Detail |

| Image 7                | Image 8                | Image 9                | Image 10               |
|------------------------|------------------------|------------------------|------------------------|
| ![CreateMatch](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/creatematch.png) | ![MatchDetail](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/matchdetail.png) | ![Teams](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/teams.png) |  ![Lineups](https://github.com/FurkanMDemiray/TeamCreator/blob/ReadmeUpdate/Screenshots/lineups.png) |
| Create Match | Match Detail | Teams | Lineups |

## Tech Stack
- **Xcode:** Version 15.4
- **Language:** Swift 5.10
 
 
## Architecture

In developing Team Creator app, MVVM (Model - View - ViewModel) is being use for these key reasons:

- **Separation of Concerns:**  MVVM separates the user interface from the business logic, making the code more maintainable and testable.
- **Reusability:** By isolating business logic in the ViewModel, you can reuse the same logic across different views.
- **Simplified Maintenance:** MVVM helps in managing complex UIs and business logic, leading to easier updates and improvements.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following:

- Xcode installed

Also, make sure that these dependencies are added in your project's target:

- [Alamofire](https://github.com/Alamofire/Alamofire.git): A powerful and easy-to-use HTTP networking library for Swift, used to handle network requests, such as fetching data from APIs.
- [SDWebImage](https://github.com/SDWebImage/SDWebImage.git): A popular library for downloading and caching images, used to efficiently load and display player images in the app.
- [Firebase](https://github.com/firebase/firebase-ios-sdk): A comprehensive platform from Google that provides a suite of tools for app development, including a real-time database, authentication, and analytics. It’s used to store and manage player data and match information in the cloud.

### Instalation

1. Clone the repository:

    ```bash
    git clone https://github.com/FurkanMDemiray/TeamCreator.git
    ```
    
2. Open the project in Xcode:

    ```bash
    cd TeamCreator
    open TeamCreator.xcodeproj
    ```
    
3. Add required dependencies using Swift Package Manager:

   ```bash
   - Alamofire
   - SDWebImage
   - Firebase
    ```
    
4. Build and run the project.

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

### Player Detail - Edit or Delete
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

## Known Issue
- While creating a match with selected players, if the player count is not enough or when the selected players do not have the different positions, there is some issues on the lineup screen.
- After adding a new player, if user edit the player that added new, sometimes player can be deleted from database.

## Improvements
- Localiziation for other languages can be added to be able to reach more user.
- Adaption to dark mode can be supported for better user friendly UI.
- As an new feature users can add a new sport category to create matches. 
- When adding a new player to the database user can be able to use their device camera.
- Users be able to change their team logos as a new logo or a photo.
- After match is created user can be able to see old match screens and teams are setted for that match.
