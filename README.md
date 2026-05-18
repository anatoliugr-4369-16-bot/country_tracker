# Country Tracker

A simple Flutter app to browse countries, save favorites, and add notes. Built for a uni assignment.

## What it does

- Shows a list of countries with flags, names, capitals, population
- Search by country name
- Filter by region (Africa, Europe, Asia, Americas, Oceania)
- Tap a country to see details: capital, area, languages, timezone, currency, etc.
- Save countries to favorites
- Add/edit/delete personal notes for each favorite (that's the CRUD part)
- Compare two countries side by side
- Open country location on Google Maps
- Share country info
- Read more on Wikipedia

## Tech stuff

- Flutter (latest stable)
- Provider for state management
- HTTP package to fetch data from REST Countries API
- SharedPreferences to store favorites and notes locally

## How to run

1. Clone this repo
2. Run `flutter pub get`
3. Run `flutter run`

No API keys needed.

## Screenshots

(Add your own screenshots here – I'll add them later)

# Country Tracker

Country Tracker is a Flutter application that allows users to explore countries around the world using the REST Countries API. The app focuses on country discovery, cultural exploration, and personal country management through favorites and notes.

The application provides a clean and modern experience for browsing country information while maintaining a responsive and visually appealing interface.

---

## Features

- Explore countries worldwide
- Search countries by name
- Filter countries by region
- Save favorite countries
- Add personal notes to countries
- Responsive modern UI
- Loading and error handling
- Real-time API data fetching

---

## Country Details Include

- Country flag
- Capital city
- Population
- Region
- Area
- Languages
- Currency
- Timezones
- Borders and neighboring countries

---

## Technologies Used

- Flutter
- Provider State Management
- HTTP Package
- REST Countries API

---

## Project Structure

```txt id="5rm3pq"
lib/
 ├── models/
 ├── providers/
 ├── services/
 ├── screens/
 ├── widgets/
 └── main.dart
```

---

## UI Design

The app uses a warm explorer-inspired color palette with brown, cream, and earthy tones to create a modern travel journal aesthetic.

---

## 📸 Screenshots

### Home Screen

![Home](screenshots/home.png)

### Country Details Screen

![Details](screenshots/details.png)

### Favorites Screen

![Favorites](screenshots/favorites.png)

---

## Getting Started

Clone the repository:

```bash id="ws2ogq"
git clone < https://github.com/anatoliugr-4369-16-bot/country_tracker.git >
```

Install dependencies:

```bash id="6bl1w0"
flutter pub get
```

Run the application:

```bash id="7l0m2l"
flutter run
```

---

## API Used

REST Countries API
https://restcountries.com

---

## Author

Anatoli chala
