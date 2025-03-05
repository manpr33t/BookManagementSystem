Book Management System API

This is a Ruby on Rails API for managing a library system where users can borrow and return books. The system tracks user balances, book availability, and generates reports.

Features

User Management:

Each user has an initial account number and balance.
Users can borrow and return books (deducting or adding fees to their balance).
Users cannot borrow books if their balance is insufficient.

Book Management:

Tracks the total and available copies of each book.
Calculates income generated by a book within a specified time range.

Reporting:

Query a user’s account status (balance and borrowed books).
Generate monthly and annual reports for a user (number of books borrowed and total spending).

API Endpoints

Creating a User
URL: POST /users

Request Body:

Json
{
  "user": {
    "email": "user@new.com",
    "password": "password",
    "account_number": "11223456",
    "balance": 100.0
    }
}

Response:

Json
{
  "data": {
      "id": "4",
      "type": "user",
      "attributes": {
          "id": 4,
          "email": "user@new.com",
          "account_number": "11223456",
          "balance": "100.0"
      }
  }
}

Signing in as a User
URL: POST /users/sign_in

Request Body:

Json
{
  "user": {
    "email": "user@new.com",
    "password": "password"
    }
}

Response:

Json
{
    "data": {
        "id": "4",
        "type": "user",
        "attributes": {
            "id": 4,
            "email": "user@new.com",
            "account_number": "11223456",
            "balance": "100.0"
        }
    },
    "token": "4377ebe944e9ed46b2404aad39f658898d9d93e4"
}

Borrow a Book
URL: POST /transactions/borrow

Request Body:

json
-h Authorization: 4377ebe944e9ed46b2404aad39f658898d9d93e4
{
  "user_id": 4,
  "book_id": 2
}
Response:

json
{
  "data": {
      "id": "40",
      "type": "transaction",
      "attributes": {
          "transaction_type": "borrow",
          "amount": "-2.0",
          "created_at": "2025-03-05T17:16:49.136Z"
      },
      "relationships": {
          "user": {
              "data": {
                  "id": "4",
                  "type": "user"
              }
          },
          "book": {
              "data": {
                  "id": "2",
                  "type": "book"
              }
          }
      }
  }
}

3. Return a Book
URL: POST /transactions/return

Request Body:
-h Authorization: 4377ebe944e9ed46b2404aad39f658898d9d93e4
json
{
  "user_id": 4,
  "book_id": 2
}
Response:

json
{
    "message": "Book was returned successfully.",
    "data": {
        "id": "50",
        "type": "transaction",
        "attributes": {
            "transaction_type": "borrow",
            "amount": "-2.0",
            "created_at": "2025-03-05T22:20:56.195Z"
        },
        "relationships": {
            "user": {
                "data": {
                    "id": "4",
                    "type": "user"
                }
            },
            "book": {
                "data": {
                    "id": "2",
                    "type": "book"
                }
            }
        }
    }
}

4. Query User Account Status
URL: GET /users/:id/account_status

Response:

json
{
    "data": {
        "balance": "96.0",
        "borrowed_books": {
            "data": [
                {
                    "id": "51",
                    "type": "transaction",
                    "attributes": {
                        "transaction_type": "borrow",
                        "amount": "-2.0",
                        "created_at": "2025-03-05T22:22:03.307Z"
                    },
                    "relationships": {
                        "user": {
                            "data": {
                                "id": "4",
                                "type": "user"
                            }
                        },
                        "book": {
                            "data": {
                                "id": "2",
                                "type": "book"
                            }
                        }
                    }
                }
            ]
        }
    }
}

5. Query Book Income
URL: GET /books/:id/income

Request:
-h Authorization: {token}
{
    "user_id": 4,
    "start_time": "2023-01-01",
    "end_time": "2025-12-3"
}

Response:

json
{
  "book_id": 2,
  "total_income": "6.0"
}

6. Query monthly report
URL: GET /users/:id/monthly_report

Request:
-h Authorization: {token}

Response:
{
    "data": {
        "amount_spent": 6.0,
        "books_borrowed": 3,
        "unique_books_borrowed": 1
    }
}

7. Query annual report
URL: GET /users/:id/annual_report

Request:
-h Authorization: {token}

Response:
{
    "data": {
        "amount_spent": 6.0,
        "books_borrowed": 3,
        "unique_books_borrowed": 1
    }
}



Setup Instructions

1. Prerequisites
Ruby 3.x

Rails 8.x

PostgreSQL

2. Clone the Repository
bash
git clone https://github.com/manpr33t/book-management-system.git
cd book-management-system
3. Install Dependencies
bash
bundle install
4. Set Up the Database
bash
rails db:create
rails db:migrate
5. Seed Sample Data
bash
rails db:seed
6. Start the Server
bash
rails server
Visit http://localhost:3000 to access the API.

Design Ideas
Models

User:
Tracks user details (email, account number, balance).

Has many Books through transactions.
Has many transactions.

Book:
Tracks book details (title, total copies, available copies).

Has many transactions.
Has many Users through transactions.

Transaction:

Records borrow/return actions.

Belongs to a user and a book.

Serialization
Uses jsonapi-serializer for fast, standardized JSON responses.

Testing
Uses RSpec and factory_bot for unit and request tests.

Test coverage includes:

User creation and account status.

Book borrowing and returning.

Income calculation for books.

Contact
For questions or feedback, please contact:

Manpreet Gandhi

Email: manpreet0791@gmail.com

GitHub: manpr33t

Enjoy using the Book Management System API! 📚🚀

Let me know if you need further adjustments! 😊
