Group Project - README Template
===

# TBD

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
<app_name> is every household's go-to for a single collaborative platform for shared necessities. It provides ease of communication surrounding all needs and notifications between housemates.   

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Lifestyle, Productivity

- **Mobile:** Users will be notified in real-time of udpates to the shopping list or message board. With mobile implementation, users will also be able coordinate with the household with ease no matter where they are.

- **Story:** This application provides users with a single space for communicating within a household. Rather than using several apps such as messaging services, notes, and some sort of payment service, our app condenses these into one convenient location.

- **Market:** This application can be used by anyone who lives with other individuals in the same household. This includes college roomates, a significant other and even parents and siblings.

- **Habit:** Users would typically use this application a few times a month. The most commom use case would be to post shared products that are running low (toilet paper, dish soap, etc...). The message board can be used to remind roomates about trash day, plan a cleaning day, or ask for favors such as feed ones pet in case their day becomes unexpectedly longer. This application will be very habit forming for households that constantly need to restock shared supplies or communicate with each other.

- **Scope:** The main functionality of this application uses topics that were covered during the first 7 weeks of the course. Thus it is just a matter of staying organized and working smart in order to prevent unnecessary or complicated bugs. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create an account.
* User can create a house for others to join.
* User can log in to their account
* User can log out of their account
* User can request to join a house.
* User can add a product to the shopping checklist
* User can check off a product they purchsed
* User can see what products from the checklist have been marked as purchased
* User can send a message to other house mates
* User can recieve a message from other house mates


**Optional Nice-to-have Stories**

* User can create a recurring event (for example a trash day reminder).
* Users can pay each other using Apple Pay within the application

### 2. Screen Archetypes

* Login Screen
   * User can log in to their account 
   * User can create an account
* House creation/search screen
   * User can create a house for others to join
   * User can search for and request to join a house
* Shopping checklist screen
    * User can add a product to the shopping checklist
    * User can check off a prodcut they purchased
* Message board screen
    * User can send a message to other house mates
    * User can recieve a message from other house mates

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Shopping checklist
* Message board

**Flow Navigation** (Screen to Screen)

* Login screen
    * Shopping checklist
    * Account creation screen
* Account creation screen
    * Login screen
* Shopping checklist screen
    * Settings
    * Add product screen


## Wireframes
<img src="https://imgur.com/bI0xHvJ.jpg" width=600>

## Schema 

### Models
<img src="https://imgur.com/qbGPCTq.jpg" width=800>

### Networking
* Sign up Screen
    * (Create/POST) Create a new user
* Shopping List Screen
    * (Read/Get) Query all the shopping list items
    * (Update/PUT) Update the state of an item if its been purchased
* Add Product Screen 
    * (Create/POST) Create a new product 
* Messageboard Screen
    * (Read/GET) Quesry all the new messages
    * (Create/POST) Create a new message
* Settings Screen
    * (Create/POST) Create a new house
