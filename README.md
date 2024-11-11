# Library Management System

## Objective
The objective of this project is to develop a web application that manages a library's book inventory and user borrowings. The system provides two main roles: Librarian and Member, each having specific access levels and features.

## Features

### Authentication and Authorization
- **User Registration, Login, and Logout**: Users can create an account, log in, and log out.
- **Roles**: There are two types of users: Librarians and Members.
- **Role Restrictions**: Only Librarian users have the ability to add, edit, or delete books.

### Book Management
- **Add New Book**: Librarians can add a new book, including details such as title, author, genre, ISBN, and the total number of copies available.
- **Edit and Delete Book**: Librarians can edit or delete book details.
- **Search Books**: Users can search for books by title, author, or genre.

### Borrowing and Returning Books
- **Borrow Books**: Member users can borrow books if available. A Member cannot borrow the same book multiple times.
- **Return Books**: Librarians can mark books as returned.
- **Tracking**: The system tracks the date a book was borrowed and its due date (2 weeks from borrowing).

### Dashboard
- **Librarian Dashboard**: Displays the total number of books, total borrowed books, books due today, and a list of members with overdue books.
- **Member Dashboard**: Displays the books they have borrowed, their due dates, and any overdue books.

### API Endpoints
- A RESTful API is implemented to allow CRUD operations for books and borrowings.
- Proper status codes and responses are included for each endpoint.
- Testing is implemented with RSpec.

### Frontend (Optional)
- The backend can optionally be integrated with a frontend framework such as React or Vue for a more user-friendly interface.
- The frontend should be responsive and intuitive.


### Root Path
- **GET `/`**: Render the homepage (`books#index`).


### User Authentication
- User management handled with `Devise`.


## Demo Links

- [Postman API Documentation](https://www.postman.com/restless-zodiac-292911/ballastlane/collection/27o224c/librarymanagement?action=share&creator=5260726)

## Setup Instructions

### Prerequisites
- **Ruby**: Version 3.3.5
- **Rails**: Version 7.2.1
- **Node.js**: Version 18.12.0
- **PostgreSQL**: Ensure the database server is running.

### Installation Steps
1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd library-management-system
   ```
2. Install dependencies:
   ```bash
   bundle install
   npm install
   ```
3. Set up the database:
   ```bash
   rails db:create db:migrate db:seed
   ```
4. Run the server:
   ```bash
   rails server
   ```

## Running with Docker(Best option)

1. Build the Docker image:
   ```
   docker-compose build
   ```

2. Start the Docker container:
   ```
   docker-compose up
   ```

### Demo Credentials
- **Librarian**: `librarian@example.com` / `password`
- **Member**: `member@example.com` / `password`

### Testing
- Run tests using RSpec:
  ```bash
  bundle exec rspec
  ```

## Additional Notes
- The application is configured to work with seeded data for easy demonstration.
- For the API, ensure proper authentication tokens are used when making requests.

## Submission Guidelines
- The completed application should include full test coverage using RSpec.
- The README should provide all necessary information to set up and run the application.
- A bonus feature is integrating the backend with a responsive frontend framework for a better user experience. In this case, the frontend was built using Rails and Bootstrap.

