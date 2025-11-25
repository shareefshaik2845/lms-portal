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

## Quiz History

### Get All Quiz History
**GET** `/quiz-history/`
- Requires Auth: ✅

Response:
```json
[
  {
    "user_id": 0,
    "checkpoint_id": 0,
    "course_id": 0,
    "answer": "string",
    "result": "string",
    "question": "string",
    "id": 0,
    "completed_at": "2025-11-24T06:11:13.139Z"
  }
]
```

### Create Quiz History Record
**POST** `/quiz-history/`
- Requires Auth: ✅

Request:
```json
{
  "user_id": 0,
  "checkpoint_id": 0,
  "course_id": 0,
  "answer": "string",
  "result": "string",
  "question": "string"
}
```

Response:
```json
{
  "message": "string",
  "id": 0,
  "user_id": 0,
  "checkpoint_id": 0,
  "course_id": 0,
  "answer": "string",
  "result": "string",
  "question": "string",
  "completed_at": "2025-11-24T06:11:49.393Z"
}
```

### Get Quiz History By User
**GET** `/quiz-history/user/{user_id}`
- Requires Auth: ✅

Response: same array structure as GET `/quiz-history/` but filtered by user.

### Get / Update / Delete Single Quiz History
**GET** `/quiz-history/{id}` — Requires Auth: ✅

**PUT** `/quiz-history/{id}` — Requires Auth: ✅

**DELETE** `/quiz-history/{id}` — Requires Auth: ✅


## Shifts

### Get All Shifts
**GET** `/shifts/`
- Requires Auth: ✅

Response:
```json
[
  {
    "name": "string",
    "start_time": "06:22:43.712Z",
    "end_time": "06:22:43.712Z",
    "description": "string",
    "shift_code": "string",
    "shift_name": "string",
    "working_minutes": 0,
    "status": "active",
    "id": 0,
    "created_at": "2025-11-24T06:22:43.712Z",
    "updated_at": "2025-11-24T06:22:43.712Z"
  }
]
```

### Create Shift
**POST** `/shifts/`
- Requires Auth: ✅

Request:
```json
{
  "name": "string",
  "start_time": "06:23:03.955Z",
  "end_time": "06:23:03.955Z",
  "description": "string",
  "shift_code": "string",
  "shift_name": "string",
  "working_minutes": 0,
  "status": "active"
}
```

Response:
```json
{
  "name": "string",
  "start_time": "06:23:04",
  "end_time": "06:23:04",
  "description": "string",
  "shift_code": "string",
  "shift_name": "string",
  "working_minutes": 0,
  "status": "active",
  "id": 1,
  "created_at": "2025-11-24T06:23:07",
  "updated_at": null
}
```

### Get Shift by ID
**GET** `/shifts/{id}`
- Requires Auth: ✅

Response:
```json
{
  "name": "string",
  "start_time": "06:23:04",
  "end_time": "06:23:04",
  "description": "string",
  "shift_code": "string",
  "shift_name": "string",
  "working_minutes": 0,
  "status": "active",
  "id": 1,
  "created_at": "2025-11-24T06:23:07",
  "updated_at": null
}
```

### Update Shift
**PUT** `/shifts/{id}`
- Requires Auth: ✅

Request:
```json
{
  "name": "string",
  "start_time": "06:23:57.226Z",
  "end_time": "06:23:57.226Z",
  "description": "string",
  "shift_code": "string",
  "shift_name": "string",
  "working_minutes": 0,
  "status": "string"
}
```

Response:
```json
{
  "name": "string",
  "start_time": "06:23:57",
  "end_time": "06:23:57",
  "description": "string",
  "shift_code": "string",
  "shift_name": "string",
  "working_minutes": 0,
  "status": "string",
  "id": 1,
  "created_at": "2025-11-24T06:23:07",
  "updated_at": "2025-11-24T06:24:02"
}
```

### Delete Shift
**DELETE** `/shifts/{id}`
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

## Departments

### Get All Departments
**GET** `/departments/`
- Requires Auth: ✅

Response:
```json
[
  {
    "name": "string",
    "code": "string",
    "description": "string",
    "status": true,
    "id": 0,
    "created_at": "2025-11-24T06:25:11.810Z",
    "updated_at": "2025-11-24T06:25:11.810Z"
  }
]
```

### Create Department
**POST** `/departments/`
- Requires Auth: ✅

Request:
```json
{
  "name": "string",
  "code": "string",
  "description": "string",
  "status": true
}
```

Response:
```json
{
  "name": "string",
  "code": "string",
  "description": "string",
  "status": true,
  "id": 1,
  "created_at": "2025-11-24T06:25:45",
  "updated_at": null
}
```

### Get Department by ID
**GET** `/departments/{id}`
- Requires Auth: ✅

Response:
```json
{
  "name": "string",
  "code": "string",
  "description": "string",
  "status": true,
  "id": 1,
  "created_at": "2025-11-24T06:25:45",
  "updated_at": null
}
```

### Update Department
**PUT** `/departments/{id}`
- Requires Auth: ✅

Request:
```json
{
  "name": "string",
  "code": "string",
  "description": "string",
  "status": true
}
```

Response:
```json
{
  "name": "string",
  "code": "string",
  "description": "string",
  "status": true,
  "id": 1,
  "created_at": "2025-11-24T06:25:45",
  "updated_at": null
}
```

### Delete Department
**DELETE** `/departments/{id}`
- Requires Auth: ✅

## Leaves

### Get All Leaves
**GET** `/leaves/`
- Requires Auth: ✅

Response:
```json
[
  {
    "name": "string",
    "description": "string",
    "status": true,
    "leave_date": "2025-11-24",
    "user_id": 0,
    "year": 0,
    "allocated": 0,
    "used": 0,
    "balance": 0,
    "carry_forward": false,
    "holiday": false,
    "id": 0,
    "created_at": "2025-11-24T06:28:59.468Z",
    "updated_at": "2025-11-24T06:28:59.468Z"
  }
]
```

### Create Leave
**POST** `/leaves/`
- Requires Auth: ✅

Request:
```json
{
  "name": "string",
  "description": "string",
  "status": true,
  "leave_date": "2025-11-24",
  "user_id": 0,
  "year": 0,
  "allocated": 0,
  "used": 0,
  "balance": 0,
  "carry_forward": false,
  "holiday": false
}
```

Response:
```json
{
  "name": "string",
  "description": "string",
  "status": true,
  "leave_date": "2025-11-24",
  "user_id": 0,
  "year": 0,
  "allocated": 0,
  "used": 0,
  "balance": 0,
  "carry_forward": false,
  "holiday": false,
  "id": 0,
  "created_at": "2025-11-24T06:29:22.187Z",
  "updated_at": "2025-11-24T06:29:22.187Z"
}
```

### Get Leave by ID
**GET** `/leaves/{id}`
- Requires Auth: ✅

Response:
```json
{
  "name": "string",
  "description": "string",
  "status": true,
  "leave_date": "2025-11-24",
  "user_id": 0,
  "year": 0,
  "allocated": 0,
  "used": 0,
  "balance": 0,
  "carry_forward": false,
  "holiday": false,
  "id": 0,
  "created_at": "2025-11-24T06:29:48.090Z",
  "updated_at": "2025-11-24T06:29:48.090Z"
}
```

### Update Leave
**PUT** `/leaves/{id}`
- Requires Auth: ✅

Request: same format as create

Response: same format as GET by ID

### Delete Leave
**DELETE** `/leaves/{id}`
- Requires Auth: ✅


## Salary Structures

### Get All Salary Structures
**GET** `/salary-structures/`
- Requires Auth: ✅

Response:
```json
[
  {
    "user_id": 0,
    "basic_salary_annual": 0,
    "allowances_annual": 0,
    "deductions_annual": 0,
    "bonus_annual": 0,
    "effective_from": "2025-11-24",
    "effective_to": "2025-11-24",
    "is_active": true,
    "id": 0,
    "total_annual": 0,
    "created_at": "2025-11-24T06:31:09.832Z",
    "updated_at": "2025-11-24T06:31:09.832Z"
  }
]
```

### Create Salary Structure
**POST** `/salary-structures/`
- Requires Auth: ✅

Request:
```json
{
  "user_id": 0,
  "basic_salary_annual": 0,
  "allowances_annual": 0,
  "deductions_annual": 0,
  "bonus_annual": 0,
  "effective_from": "2025-11-24",
  "effective_to": "2025-11-24",
  "is_active": true
}
```

Response: same object with generated `id`, `total_annual`, timestamps.

### Get Salary Structure by ID
**GET** `/salary-structures/{id}`
- Requires Auth: ✅

Response: same as single object above.

### Update Salary Structure
**PUT** `/salary-structures/{id}`
- Requires Auth: ✅

Request: (fields to update)
```json
{
  "basic_salary_annual": 0,
  "allowances_annual": 0,
  "deductions_annual": 0,
  "bonus_annual": 0,
  "effective_from": "2025-11-24",
  "effective_to": "2025-11-24",
  "is_active": true
}
```

### Delete Salary Structure
**DELETE** `/salary-structures/{id}`
- Requires Auth: ✅


## Formulas

### Get All Formulas
**GET** `/formulas/`
- Requires Auth: ✅

Response:
```json
[
  {
    "component_code": "string",
    "component_name": "string",
    "formula_expression": "string",
    "formula_type": "earning",
    "is_active": true,
    "description": "string",
    "salary_structure_id": 0,
    "id": 0,
    "created_at": "2025-11-24T06:33:54.289Z",
    "updated_at": "2025-11-24T06:33:54.289Z"
  }
]
```

### Create Formula
**POST** `/formulas/`
- Requires Auth: ✅

Request:
```json
{
  "component_code": "string",
  "component_name": "string",
  "formula_expression": "string",
  "formula_type": "earning",
  "is_active": true,
  "description": "string",
  "salary_structure_id": 0
}
```

Response: created object with `id` and timestamps.

### Get Formula by ID
**GET** `/formulas/{id}`
- Requires Auth: ✅

### Update Formula
**PUT** `/formulas/{id}`
- Requires Auth: ✅

Request: (fields to update)
```json
{
  "component_name": "string",
  "formula_expression": "string",
  "formula_type": "string",
  "is_active": true,
  "description": "string",
  "salary_structure_id": 0
}
```

### Delete Formula
**DELETE** `/formulas/{id}`
- Requires Auth: ✅


## Payrolls

### Get All Payrolls
**GET** `/payrolls/`
- Requires Auth: ✅

Response:
```json
[
  {
    "id": 0,
    "user_id": 0,
    "salary_structure_id": 0,
    "month": "string",
    "basic_salary": 0,
    "allowances": 0,
    "deductions": 0,
    "bonus": 0,
    "gross_salary": 0,
    "net_salary": 0,
    "status": "string",
    "created_at": "2025-11-24T06:36:06.105Z",
    "updated_at": "2025-11-24T06:36:06.105Z",
    "user_name": "string",
    "salary_structure_name": "string"
  }
]
```

### Create Payroll
**POST** `/payrolls/`
- Requires Auth: ✅

Request:
```json
{
  "user_id": 0,
  "salary_structure_id": 0,
  "month": "2025-10"
}
```

Response: created payroll object with calculated fields and timestamps.

### Get Payroll by ID
**GET** `/payrolls/{id}`
- Requires Auth: ✅

### Update Payroll
**PUT** `/payrolls/{id}`
- Requires Auth: ✅

Request:
```json
{
  "status": "string",
  "recalculate": false
}
```

### Delete Payroll
**DELETE** `/payrolls/{id}`
- Requires Auth: ✅



## Progress

### Update watched minutes (watch action)
**POST** `/progress/{id}/watch?watched_minutes={minutes}&user_id={user_id}`
- Description: Increment or update watched minutes for a specific progress record (often invoked from video player). Some backends accept an empty body and take parameters from the query string.
- Requires Auth: ✅

Response:
```json
{
  "id": 0,
  "user_id": 0,
  "course_id": 0,
  "watched_minutes": 0,
  "progress_percentage": 0,
  "created_at": "2025-11-24T06:17:15.331Z",
  "updated_at": "2025-11-24T06:17:15.331Z"
}
```

### Get progress list (filterable)
**GET** `/progress/?user_id={user_id}&course_id={course_id}`
- Requires Auth: ✅

Response:
```json
[
  {
    "id": 0,
    "user_id": 0,
    "course_id": 0,
    "watched_minutes": 0,
    "progress_percentage": 0,
    "created_at": "2025-11-24T06:17:50.245Z",
    "updated_at": "2025-11-24T06:17:50.245Z"
  }
]
```

### Delete progress for a specific user
**DELETE** `/progress/{id}/user/{user_id}`
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
