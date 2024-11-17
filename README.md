# Planorama

## Table of Contents
1. [Overview](#overview)
2. [Product Spec](#product-spec)
3. [Wireframes](#wireframes)
4. [Schema](#schema)

---

## Overview

### Description
Planorama is an event planning app that makes organizing social gatherings seamless and fun! Users can create events, manage guest lists, and list dietary restrictions. With an integrated weather feature, users can also view the forecast for the event date, helping them prepare for any conditions. From setting the vibe with a DJ music queue to ensuring the right weather outlook, Planorama is the ultimate party planner.

### App Evaluation

- **Category:** Social/Utility
- **Mobile:** Mobile-only application
- **Story:** Planorama tells the story of a smoothly orchestrated event, helping users plan, organize, and stay prepared for memorable gatherings.
- **Market:** Social organizers, event hosts, and users of all ages looking to host gatherings with ease and style.
- **Habit:** Used for planning events, potentially on a weekly or monthly basis.
- **Scope:** The app provides essential features for event management along with added weather insights, making it versatile and unique.

---

## Product Spec

### 1. User Stories (Required and Optional)

#### Required Must-have Stories
- User can create and manage events with details like location, time, and dietary restrictions.
- User can view a weather forecast for the day of the event.
- User can add songs to a music queue for party ambiance.
- User can invite guests and manage RSVPs.

#### Optional Nice-to-have Stories
- User can set reminders for event preparations.
- User can personalize event invitations with customizable templates.
- User can receive notifications about significant weather changes on the event day.

### 2. Screen Archetypes

- **Event Creation Screen**
  - Required: User can create an event, set date/time, location, and dietary restrictions.
- **Weather Screen**
  - Required: User can view weather forecast for the event day.
- **Guest Management Screen**
  - Required: User can invite guests, track RSVPs, and manage dietary needs.
- **Music Queue Screen**
  - Required: User can add and manage songs for event ambiance.
- **Notification Screen**
  - Optional: User can set reminders and notifications for event preparations.

### 3. Navigation

#### Tab Navigation (Tab to Screen)
- **Home Feed** - Event dashboard and overview
- **Event Planning** - Create and edit event details
- **Weather** - Check weather for the event day
- **Music Queue** - Add songs for the party playlist

#### Flow Navigation (Screen to Screen)
- **Home Feed** leads to **Event Creation Screen**
- **Event Creation Screen** leads to **Guest Management Screen**
- **Weather Screen** - Accessible from Event Creation and Home Feed

---

## Wireframes


![PHOTO-2024-11-12-19-41-19 (1)](https://hackmd.io/_uploads/HJYSwpGG1g.jpg)
![PHOTO-2024-11-12-19-41-19 (2)](https://hackmd.io/_uploads/HJFSv6MMJx.jpg)
![PHOTO-2024-11-12-19-41-18 (3)](https://hackmd.io/_uploads/HyKBw6ffke.jpg)
![PHOTO-2024-11-12-19-41-19](https://hackmd.io/_uploads/By9HwTfM1g.jpg)
![PHOTO-2024-11-12-19-41-18 (1)](https://hackmd.io/_uploads/Hy9rwaGz1g.jpg)
![PHOTO-2024-11-12-19-41-18 (2)](https://hackmd.io/_uploads/r1cSPTfGke.jpg)
![PHOTO-2024-11-12-19-41-18](https://hackmd.io/_uploads/Hy9HvpzfJe.jpg)


---

## Schema

### Models

#### Model: Event

| Property          | Type     | Description                                |
|-------------------|----------|--------------------------------------------|
| eventId           | String   | unique id for each event                   |
| name              | String   | name of the event                          |
| date              | Date     | date and time of the event                 |
| location          | String   | location of the event                      |
| dietaryRestrictions | String   | dietary needs of guests                   |
| forecast          | String   | weather forecast for the event day         |
| guestList         | Array    | list of invited guests                     |
| musicQueue        | Array    | list of songs in the party playlist        |

---

### Networking

- **[GET]** /events - Retrieve all events
- **[POST]** /events - Create a new event
- **[PUT]** /events/:id - Update event details (e.g., guest list, dietary restrictions)
- **[GET]** /weather - Retrieve weather forecast based on event location and date
- **[POST]** /musicQueue - Add a song to the event’s music queue
