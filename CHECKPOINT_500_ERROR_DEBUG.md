# 🔴 Checkpoint 500 Error - Debugging Guide

## Current Status
**Error**: Internal Server Error (500)
**Endpoint**: POST /checkpoints/
**Payload**: `{video_id: 2, timestamp: 150, question: "Dart is developed by?", choices: "Facebook;Instagram;Google;Oracle", correct_answer: "Google", required: true}`
**Response**: Plain text "Internal Server Error"

---

## Root Cause Analysis

### What the 500 Error Means
The **backend server is throwing an unhandled exception**. This is NOT a client validation error (400) or authentication error (401). The server received valid JSON but something internally failed.

### Possible Causes (In Order of Likelihood)

#### 1. ❌ **Invalid or Missing Video ID** (Most Common)
- Video ID `2` might not exist in the database
- The backend might not have foreign key validation on the client side
- Solution: Verify video with ID 2 exists

#### 2. ❌ **Null Value in Choices or Question**
- Despite client validation, something might be None/null
- Unlikely but possible if backend expects non-null strings
- Solution: Ensure no empty values

#### 3. ❌ **Reserved Keyword Issue**
- Field name `required` might conflict with Python keywords
- FastAPI might have issues deserializing this field name
- Solution: Test with a different field name (e.g., `is_required`)

#### 4. ❌ **Timestamp Edge Case**
- Timestamp value `150` might have specific backend validation
- Or the timestamp format isn't what backend expects
- Solution: Try different timestamp value

#### 5. ❌ **Choices Format Validation**
- Backend might expect exact format (e.g., no spaces, specific delimiters)
- Your choices: `"Facebook;Instagram;Google;Oracle"` look correct
- Solution: Ensure correct answer matches exactly

#### 6. ❌ **Correct Answer Validation**
- Backend might be case-sensitive: `"Google"` vs `"google"`
- Or it might not be finding exact match in choices
- Solution: Verify case-sensitive matching

#### 7. ❌ **Database Constraint**
- Foreign key constraint on video_id
- Unique constraint on some field combination
- Solution: Check backend logs

---

## Quick Diagnostic Steps

### Step 1: Verify Video Exists
```
GET /videos/2

Expected Response:
{
  "id": 2,
  "title": "...",
  "youtube_url": "...",
  "course_id": 1
}

If 404: Video ID 2 doesn't exist!
```

**Action**: Call GET /videos/2 from Postman/Insomnia
- ✅ If response 200 OK → Video exists, problem elsewhere
- ❌ If response 404 Not Found → Video ID is invalid

---

### Step 2: Test with Minimal Data
Try creating a checkpoint with the absolute minimum required fields:

```json
{
  "video_id": 2,
  "timestamp": 150,
  "question": "Test?",
  "choices": "A;B;C",
  "correct_answer": "A",
  "required": true
}
```

- ✅ If this works → Problem is with specific values
- ❌ If this also fails → Problem is with field names or types

---

### Step 3: Test Field Name Variations
If Step 2 fails, try these variations:

**Option A**: Rename `required` field
```json
{
  "video_id": 2,
  "timestamp": 150,
  "question": "Test?",
  "choices": "A;B;C",
  "correct_answer": "A",
  "is_required": true
}
```

**Option B**: Send as string instead of boolean
```json
{
  ...
  "required": "true"
}
```

**Option C**: Omit the field entirely
```json
{
  "video_id": 2,
  "timestamp": 150,
  "question": "Test?",
  "choices": "A;B;C",
  "correct_answer": "A"
}
```

---

### Step 4: Check Backend Logs
If you have access to the backend server (at 16.170.31.99:8000):

```bash
# View logs (depends on how it's deployed)
docker logs <container_name>
# OR
tail -f /var/log/app.log
# OR
Check the terminal where the FastAPI app is running
```

**Look for**: Exception traceback, validation error, field name errors, database errors

---

## Systematic Testing Plan

### Test 1: Video ID Validation
```
Purpose: Confirm video ID 2 exists
Request: GET /videos/2
Expected: 200 OK with video details
```

### Test 2: Minimal Checkpoint
```
Purpose: Test with simplest possible data
Request: POST /checkpoints/ with minimal fields
Expected: 201 Created (or 200 OK)
```

### Test 3: Full Checkpoint
```
Purpose: Test with all fields
Request: POST /checkpoints/ with complete data
Expected: 201 Created
```

### Test 4: Different Video ID
```
Purpose: Rule out video ID validation issue
Request: POST /checkpoints/ with video_id 1
Expected: Success or specific error
```

### Test 5: Different Timestamp
```
Purpose: Rule out timestamp validation
Request: POST /checkpoints/ with timestamp 0, 30, 60, 300
Expected: Success or specific error
```

---

## Common Backend Validation Issues

### ✅ Check These in Backend Code:

1. **Video ID Validation**
   ```python
   # Backend should check:
   video = db.query(Video).filter(Video.id == checkpoint.video_id).first()
   if not video:
       raise HTTPException(status_code=404, detail="Video not found")
   ```

2. **Field Name Validation**
   ```python
   # Field name must match exactly:
   # "required" not "requireds"
   # "video_id" not "videoId"
   # "correct_answer" not "correctAnswer"
   ```

3. **Type Validation**
   ```python
   # Ensure types match:
   # video_id: int ✅
   # timestamp: int ✅
   # question: str ✅
   # choices: str ✅
   # correct_answer: str ✅
   # required: bool ✅
   ```

4. **Choices Format Validation**
   ```python
   # If backend expects semicolon-separated:
   choices = checkpoint.choices.split(';')
   if len(choices) < 2:
       raise HTTPException(status_code=400, detail="At least 2 choices required")
   ```

5. **Correct Answer Validation**
   ```python
   # Must match one of the choices exactly:
   choices = checkpoint.choices.split(';')
   if checkpoint.correct_answer not in choices:
       raise HTTPException(status_code=400, detail="Correct answer not in choices")
   ```

---

## Solution Strategy

### If the Problem is Video ID:
1. Use a video ID that you KNOW exists (try video_id 1)
2. Or create a new video first and use its ID
3. Verify in GET /videos/ response

### If the Problem is Field Names:
1. Check backend model definition
2. Ensure field names match exactly (snake_case vs camelCase)
3. Try with `is_required` instead of `required`

### If the Problem is Data Format:
1. Ensure no leading/trailing spaces in choices
2. Ensure correct_answer matches exactly (case-sensitive)
3. Try with simpler values (no special characters)

### If Still Getting 500 Error:
1. Check backend logs directly
2. Add debug print statements in backend createCheckpoint handler
3. Verify database is running and accessible
4. Check if there's a unique constraint being violated

---

## Test Checkpoint Payload Templates

### Template 1: Minimal (Test field names)
```json
{
  "video_id": 1,
  "timestamp": 0,
  "question": "Q",
  "choices": "A;B",
  "correct_answer": "A",
  "required": true
}
```

### Template 2: Safe (Likely to work)
```json
{
  "video_id": 1,
  "timestamp": 30,
  "question": "Which is correct?",
  "choices": "Option A;Option B;Option C",
  "correct_answer": "Option A",
  "required": true
}
```

### Template 3: Your Test (Modified)
```json
{
  "video_id": 1,
  "timestamp": 150,
  "question": "Dart is developed by which company?",
  "choices": "Facebook;Microsoft;Google;Oracle",
  "correct_answer": "Google",
  "required": true
}
```
**Note**: Changed video_id from 2 → 1 (in case 2 doesn't exist)

---

## Command Line Testing (Using cURL)

### Get All Videos (Verify video_id exists)
```bash
curl -X GET "http://16.170.31.99:8000/videos/" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Create Checkpoint (Minimal Test)
```bash
curl -X POST "http://16.170.31.99:8000/checkpoints/" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "video_id": 1,
    "timestamp": 30,
    "question": "Test Question?",
    "choices": "A;B;C",
    "correct_answer": "A",
    "required": true
  }'
```

### Create Checkpoint (Your Test Data)
```bash
curl -X POST "http://16.170.31.99:8000/checkpoints/" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "video_id": 1,
    "timestamp": 150,
    "question": "Dart is developed by which company?",
    "choices": "Facebook;Microsoft;Google;Oracle",
    "correct_answer": "Google",
    "required": true
  }'
```

---

## Next Steps

### Immediate Action:
1. **Verify video_id 2 exists**: Call `GET /videos/2` 
2. **Get all video IDs**: Call `GET /videos/` to see available IDs
3. **Try with video_id 1**: If 2 doesn't exist, use 1 instead

### If That Doesn't Work:
1. Check backend error logs
2. Try with minimal test payload
3. Test with different video ID
4. Review backend validation code

### Most Likely Fix:
**Video ID 2 doesn't exist!** Try creating a checkpoint with `"video_id": 1` instead.

---

## Status

- 🔴 **Current Status**: 500 Internal Server Error
- 📋 **Probable Cause**: Invalid video ID or missing database record
- 🔍 **Next Step**: Verify video_id 2 exists using GET /videos/
- ✅ **Expected Outcome**: After fix, should get 201 Created response

---

## Quick Checklist

- [ ] Verify video ID 2 exists (GET /videos/2)
- [ ] Get all video IDs (GET /videos/)
- [ ] Try with video_id 1 instead
- [ ] Check backend logs for exceptions
- [ ] Test with minimal checkpoint data
- [ ] Verify all field names match (video_id, not videoId)
- [ ] Verify all data types (int, int, string, string, string, bool)
- [ ] Ensure correct_answer matches one of the choices exactly
- [ ] Try renaming `required` to `is_required` if still failing

**Success Indicator**: Response status 201 Created or 200 OK with checkpoint data
