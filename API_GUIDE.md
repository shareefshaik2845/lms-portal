# API Integration Guide

## Base URL
```
http://16.170.31.99:8000
```

## Authentication

All authenticated endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer <access_token>
```

### Register New User
**POST** `/auth/register`

Request:
```json
{
  "name": "string",
  "email": "user@example.com",
  "role_id": 0,
  "password": "string"
}
```

Response:
```json
{
  "name": "string",
  "email": "user@example.com",
  "role_id": 0
}
```

### Login
**POST** `/auth/login`

Content-Type: `application/x-www-form-urlencoded`

Request:
```
grant_type=password
username=admin@gmail.com
password=admin1234
scope=
client_id=string
client_secret=string
```

Response:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

## User Management

### Get All Users
**GET** `/users/`
- Requires Auth: ✅

Response:
```json
[
  {
    "name": "admin",
    "email": "admin@gmail.com",
    "role_id": 1,
    "branch_id": null,
    "organization_id": null,
    "address": null,
    "designation": null,
    "date_of_birth": null,
    "joining_date": null,
    "relieving_date": null,
    "id": 1,
    "inactive": false,
    "created_at": "2025-10-27T09:47:53",
    "updated_at": null,
    "role_name": "admin",
    "branch_name": null,
    "organization_name": null
  }
]
```

### Get User by ID
**GET** `/users/{id}`
- Requires Auth: ✅

### Create User
**POST** `/users/`
- Requires Auth: ✅

Request:
```json
{
  "name": "string",
  "email": "user@example.com",
  "role_id": 0,
  "branch_id": 0,
  "organization_id": 0,
  "address": "string",
  "designation": "string",
  "date_of_birth": "2025-10-30",
  "joining_date": "2025-10-30T04:43:29.920Z",
  "relieving_date": "2025-10-30T04:43:29.920Z",
  "password": "string"
}
```

### Update User
**PUT** `/users/{id}`
- Requires Auth: ✅

### Delete User
**DELETE** `/users/{id}`
- Requires Auth: ✅

## Category Management

### Get All Categories
**GET** `/categories/`
- Requires Auth: ✅

Response:
```json
[
  {
    "name": "string",
    "description": "string",
    "id": 0,
    "created_at": "2025-10-30T05:01:57.989Z",
    "updated_at": "2025-10-30T05:01:57.989Z",
    "courses": []
  }
]
```

### Get Category by ID
**GET** `/categories/{id}`
- Requires Auth: ❌

### Create Category
**POST** `/categories/`
- Requires Auth: ✅

Request:
```json
{
  "name": "string",
  "description": "string"
}
```

### Update Category
**PUT** `/categories/{id}`
- Requires Auth: ✅

### Delete Category
**DELETE** `/categories/{id}`
- Requires Auth: ✅

## Course Management

### Get All Courses
**GET** `/courses/`
- Requires Auth: ❌

Response:
```json
[
  {
    "title": "string",
    "instructor": "string",
    "level": "beginner",
    "price": 0,
    "id": 0,
    "videos": [],
    "duration": 0
  }
]
```

### Get Course by ID
**GET** `/courses/{id}`
- Requires Auth: ❌

### Create Course
**POST** `/courses/`
- Requires Auth: ❌

Request:
```json
{
  "title": "string",
  "instructor": "string",
  "level": "beginner",
  "price": 0
}
```

### Update Course
**PUT** `/courses/{id}`
- Requires Auth: ❌

### Delete Course
**DELETE** `/courses/{id}`
- Requires Auth: ❌

## Video Management

### Get All Videos
**GET** `/videos/`
- Requires Auth: ❌

Response:
```json
[
  {
    "title": "string",
    "youtube_url": "string",
    "duration": 0,
    "id": 0,
    "course_id": 0
  }
]
```

### Get Video by ID
**GET** `/videos/{id}`
- Requires Auth: ❌

### Create Video
**POST** `/videos/`
- Requires Auth: ✅

Request:
```json
{
  "title": "string",
  "youtube_url": "string",
  "duration": 0,
  "course_id": 0
}
```

### Update Video
**PUT** `/videos/{id}`
- Requires Auth: ✅

### Delete Video
**DELETE** `/videos/{id}`
- Requires Auth: ✅

## Checkpoint Management

### Get All Checkpoints
**GET** `/checkpoints/`
- Requires Auth: ✅

Response:
```json
[
  {
    "id": 0,
    "video_id": 0,
    "timestamp": 0,
    "question": "string",
    "choices": "string",
    "correct_answer": "string",
    "required": true
  }
]
```

### Get Checkpoint by ID
**GET** `/checkpoints/{id}`
- Requires Auth: ✅

### Create Checkpoint
**POST** `/checkpoints/`
- Requires Auth: ✅

Request:
```json
{
  "video_id": 0,
  "timestamp": 0,
  "question": "string",
  "choices": "string",
  "correct_answer": "string",
  "required": true
}
```

### Update Checkpoint
**PUT** `/checkpoints/{id}`
- Requires Auth: ✅

Request:
```json
{
  "timestamp": 0,
  "question": "string",
  "choices": "string",
  "correct_answer": "string",
  "required": true
}
```

### Delete Checkpoint
**DELETE** `/checkpoints/{id}`
- Requires Auth: ✅

## Organization Management

### Get All Organizations
**GET** `/organizations/`
- Requires Auth: ✅

### Get Organization by ID
**GET** `/organizations/{id}`
- Requires Auth: ❌

Response:
```json
{
  "name": "SNA",
  "description": "Solutions",
  "id": 1,
  "branches": [
    {
      "name": "Branch A",
      "address": "JNTU",
      "organization_id": 1,
      "id": 1
    }
  ],
  "created_at": "2025-10-28T09:59:28",
  "updated_at": "2025-10-28T09:59:28",
  "courses": [],
  "users": []
}
```

### Create Organization
**POST** `/organizations/`
- Requires Auth: ✅

Request:
```json
{
  "name": "string",
  "description": "string",
  "branch_ids": []
}
```

### Update Organization
**PUT** `/organizations/{id}`
- Requires Auth: ✅

### Delete Organization
**DELETE** `/organizations/{id}`
- Requires Auth: ✅

## Branch Management

### Get All Branches
**GET** `/branches/`
- Requires Auth: ✅

Response:
```json
[
  {
    "name": "string",
    "address": "string",
    "organization_id": 0,
    "id": 0
  }
]
```

### Get Branch by ID
**GET** `/branches/{id}`
- Requires Auth: ❌

### Create Branch
**POST** `/branches/`
- Requires Auth: ✅

### Update Branch
**PUT** `/branches/{id}`
- Requires Auth: ✅

### Delete Branch
**DELETE** `/branches/{id}`
- Requires Auth: ✅

## Enrollment Management

### Get All Enrollments
**GET** `/enrollments/`
- Requires Auth: ✅

### Create Enrollment
**POST** `/enrollments/`
- Requires Auth: ✅

Request:
```json
{
  "user_id": 0,
  "course_id": 0
}
```

Response:
```json
{
  "id": 0,
  "user_id": 0,
  "course_id": 0,
  "enrolled_at": "2025-10-30T04:59:46.081Z"
}
```

### Get Enrollments by User
**GET** `/enrollments/user/{user_id}`
- Requires Auth: ❌

### Get Enrollments by Course
**GET** `/enrollments/course/{course_id}`
- Requires Auth: ❌

### Delete Enrollment
**DELETE** `/enrollments/{id}`
- Requires Auth: ✅

## Role IDs

- `1` - Admin
- `2` - User

## Test Accounts

### Admin
- Email: `admin@gmail.com`
- Password: `admin1234`
- Role ID: 1

### Regular User
- Email: `sirisha@gmail.com`
- Role ID: 2

## Error Responses

### 401 Unauthorized
```json
{
  "detail": "Unauthorized"
}
```

### 404 Not Found
```json
{
  "detail": "Not found"
}
```

### 422 Validation Error
```json
{
  "detail": [
    {
      "loc": ["body", "field"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```
