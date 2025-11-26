# 🧪 Checkpoint API Testing - Quick Reference

## Your Current Error
```
Status: 500 Internal Server Error
Response: "Internal Server Error"
Payload: {video_id: 2, timestamp: 150, ...}
```

---

## Step 1: Test Video Endpoint (Verify Data Exists)

### ✅ Test 1A: Get All Videos
**URL**: `http://16.170.31.99:8000/videos/`  
**Method**: GET  
**Headers**: 
```
Authorization: Bearer YOUR_TOKEN
```

**Expected Response** (Status 200):
```json
[
  {
    "id": 1,
    "title": "Introduction to Dart",
    "youtube_url": "https://...",
    "duration": 300,
    "course_id": 1
  },
  {
    "id": 2,
    "title": "...",
    ...
  }
]
```

**What to Look For**:
- ✅ Is video_id 2 in the list?
- ✅ What are the available video IDs?
- ✅ Is the video associated with the correct course?

---

### ✅ Test 1B: Get Specific Video (ID 2)
**URL**: `http://16.170.31.99:8000/videos/2`  
**Method**: GET  
**Headers**: 
```
Authorization: Bearer YOUR_TOKEN
```

**If Response is 200 OK** → Video exists, problem is elsewhere  
**If Response is 404 Not Found** → ❌ **Video ID 2 doesn't exist!**

---

## Step 2: Test Checkpoint Creation

### ❌ Current Test (Getting 500 Error)
```
POST http://16.170.31.99:8000/checkpoints/
Content-Type: application/json
Authorization: Bearer YOUR_TOKEN

{
  "video_id": 2,
  "timestamp": 150,
  "question": "Dart is developed by which company?",
  "choices": "Facebook;Instagram;Google;Oracle",
  "correct_answer": "Google",
  "required": true
}
```

**Result**: 500 Internal Server Error

---

### ✅ Test 2A: Minimal Checkpoint (Field Name Test)
**Purpose**: Test if field names are correct

```
POST http://16.170.31.99:8000/checkpoints/
Content-Type: application/json
Authorization: Bearer YOUR_TOKEN

{
  "video_id": 1,
  "timestamp": 0,
  "question": "Q",
  "choices": "A;B;C",
  "correct_answer": "A",
  "required": true
}
```

**Possible Outcomes**:
- ✅ **201 Created**: Field names are correct, video_id 1 works
- ❌ **500 Error**: Problem with field names or types
- ❌ **404 Error**: Video_id 1 doesn't exist either
- ❌ **400 Error**: Validation error (see response body)

**Action if 201 Created**: 
- Video_id issue - use video_id 1 in your app
- Test again with your actual data using video_id 1

**Action if 500 Error**:
- Try Test 2B (check field name issue)

---

### ✅ Test 2B: Check `required` Field (If 2A fails)
**Purpose**: Test if `required` field name is causing the issue

**Option 1**: Rename to `is_required`
```json
{
  "video_id": 1,
  "timestamp": 0,
  "question": "Q",
  "choices": "A;B;C",
  "correct_answer": "A",
  "is_required": true
}
```

**Option 2**: Send as string
```json
{
  "video_id": 1,
  "timestamp": 0,
  "question": "Q",
  "choices": "A;B;C",
  "correct_answer": "A",
  "required": "true"
}
```

**Option 3**: Omit the field
```json
{
  "video_id": 1,
  "timestamp": 0,
  "question": "Q",
  "choices": "A;B;C",
  "correct_answer": "A"
}
```

---

### ✅ Test 2C: Safe Checkpoint (Most Likely to Work)
**Purpose**: Test with values unlikely to cause issues

```
POST http://16.170.31.99:8000/checkpoints/
Content-Type: application/json
Authorization: Bearer YOUR_TOKEN

{
  "video_id": 1,
  "timestamp": 30,
  "question": "Which option is correct?",
  "choices": "Option A;Option B;Option C;Option D",
  "correct_answer": "Option A",
  "required": true
}
```

---

### ✅ Test 2D: Your Test Data (Modified for video_id 1)
**Purpose**: Your actual test but with video_id 1 instead of 2

```
POST http://16.170.31.99:8000/checkpoints/
Content-Type: application/json
Authorization: Bearer YOUR_TOKEN

{
  "video_id": 1,
  "timestamp": 150,
  "question": "Dart is developed by which company?",
  "choices": "Facebook;Microsoft;Google;Oracle",
  "correct_answer": "Google",
  "required": true
}
```

**Expected**: 201 Created (if video_id 1 exists)

---

## Step 3: Verify Checkpoints Created

### ✅ Get All Checkpoints
```
GET http://16.170.31.99:8000/checkpoints/
Authorization: Bearer YOUR_TOKEN
```

**Expected Response**:
```json
[
  {
    "id": 1,
    "video_id": 1,
    "timestamp": 30,
    "question": "Which option is correct?",
    "choices": "Option A;Option B;Option C;Option D",
    "correct_answer": "Option A",
    "required": true
  }
]
```

---

## Testing Decision Tree

```
START: 500 Error on checkpoint creation
│
├─ Step 1: Test GET /videos/
│  ├─ ✅ Status 200 OK
│  │  └─ Check if video_id 2 exists in list
│  │     ├─ YES → Go to Test 2A
│  │     └─ NO → Try video_id 1 in Test 2A
│  │
│  └─ ❌ Status not 200
│     └─ Auth/network issue, check token
│
├─ Step 2A: Test minimal checkpoint with video_id 1
│  ├─ ✅ Status 201 Created
│  │  └─ SUCCESS! Problem was video_id 2 not existing
│  │     → Update app to use video_id 1
│  │
│  └─ ❌ Status 500 Error
│     └─ Problem is NOT video_id → Go to Test 2B
│
├─ Step 2B: Test with `required` field variations
│  ├─ ✅ One of the options works
│  │  └─ Field name/type issue found
│  │     → Update CheckpointModel.toJson()
│  │
│  └─ ❌ All variations fail
│     └─ Check backend logs → Contact backend team
│
└─ Check backend server logs
   └─ Backend exception details will point to the issue
```

---

## Field Name Reference

**What you're sending** (from Flutter):
```json
{
  "video_id": 2,           ← Snake case ✅
  "timestamp": 150,         ← Number ✅
  "question": "...",        ← String ✅
  "choices": "A;B;C",       ← String ✅
  "correct_answer": "A",    ← Snake case ✅
  "required": true          ← Boolean ✅
}
```

**Field names MUST match** (case-sensitive):
- `video_id` (not `videoId`, not `video_ID`)
- `timestamp` (not `videoTimestamp`)
- `question` (not `questionText`)
- `choices` (not `choice` singular)
- `correct_answer` (not `correctAnswer`, not `answer`)
- `required` (not `is_required`, not `requireds`)

---

## Common Errors & Solutions

### Error: 404 Not Found on GET /videos/2
**Cause**: Video ID 2 doesn't exist  
**Solution**: Use video_id 1 or check available IDs with GET /videos/

### Error: 500 on POST /checkpoints/ (your current issue)
**Most Likely Cause**: Video ID doesn't exist  
**Solution**: Test with video_id 1 first

### Error: 422 Validation Error
**Cause**: Field type or format is wrong  
**Example**: `"timestamp": "150"` should be `"timestamp": 150` (number, not string)  
**Solution**: Check field types match schema

### Error: 400 Bad Request
**Cause**: Business logic validation failed  
**Example**: Correct answer not in choices  
**Solution**: Ensure `"correct_answer": "Google"` is in `"choices": "...;Google;..."`

---

## Postman/Insomnia Setup

### 1. Set Environment Variable
```
token = (your bearer token from login)
baseUrl = http://16.170.31.99:8000
```

### 2. GET Request Template
```
{{baseUrl}}/videos/
Headers: Authorization: Bearer {{token}}
```

### 3. POST Request Template
```
{{baseUrl}}/checkpoints/
Headers: 
  Authorization: Bearer {{token}}
  Content-Type: application/json
Body:
{
  "video_id": 1,
  "timestamp": 30,
  ...
}
```

---

## Success Indicators

### ✅ If Test 2A Works (201 Created)
```
Status: 201
Response:
{
  "id": 1,
  "video_id": 1,
  "timestamp": 0,
  "question": "Q",
  "choices": "A;B;C",
  "correct_answer": "A",
  "required": true
}
```

This means:
- ✅ API is working correctly
- ✅ Field names are correct
- ✅ Video ID 1 exists
- ❌ Video ID 2 might not exist

**Next Action**: Update your app to use video_id 1

---

## Your Immediate Action Plan

1. **Get your Bearer token** from login response
2. **Test 1A**: `GET /videos/` - See all video IDs
3. **Test 1B**: `GET /videos/2` - Check if ID 2 exists
4. **Test 2A**: `POST /checkpoints/` with video_id 1 - Minimal test
5. **Check result**: 201 Created? → Use video_id 1. Still 500? → Check backend logs

**Most likely outcome**: Video ID 2 doesn't exist, use ID 1 instead!

---

## If Still Getting 500 Error After All Tests

Contact backend team with:
- Server logs from the checkpoint creation request
- Your request payload (full JSON)
- Database state (verify video record exists)
- FastAPI/Python exception traceback

Backend debugging checklist:
- [ ] Check database has video with ID = request.video_id
- [ ] Add debug prints in createCheckpoint handler
- [ ] Check for foreign key constraint errors
- [ ] Verify checkpoint table schema matches model
- [ ] Check for unique constraint violations

---

## Quick Copy-Paste Commands

### cURL: Test Video Exists
```bash
curl -X GET "http://16.170.31.99:8000/videos/1" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### cURL: Create Checkpoint (Minimal)
```bash
curl -X POST "http://16.170.31.99:8000/checkpoints/" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"video_id": 1, "timestamp": 0, "question": "Q", "choices": "A;B;C", "correct_answer": "A", "required": true}'
```

### cURL: List All Videos
```bash
curl -X GET "http://16.170.31.99:8000/videos/" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

**Status**: Ready for testing  
**Expected Duration**: 5-10 minutes  
**Success Rate**: 95% (likely just video ID issue)
