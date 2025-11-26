# Checkpoint API Integration - Debugging Guide

## Issue: Internal Server Error when Creating Checkpoints

### Root Causes Fixed ✅

#### 1. **Dialog UX Improvements** ✅
- **Problem**: Manual video ID input allowed invalid IDs to be sent to the API
- **Solution**: 
  - Removed editable `videoIdController` 
  - Auto-uses selected video's ID (passed as parameter)
  - Shows Video ID as read-only info for clarity
  - Prevents user from accidentally entering wrong video ID

#### 2. **Client-Side Validation** ✅
- **Problem**: Invalid data reaching the server caused 500 errors
- **Solution**: Added comprehensive validation in `VideoViewModel.createCheckpoint()`:
  ```
  ✓ Video ID validation: Checks if video exists in loaded list
  ✓ Timestamp validation: Must be >= 0
  ✓ Question validation: Cannot be empty
  ✓ Choices validation: Cannot be empty, must be split properly
  ✓ Correct Answer validation: Must exactly match one choice (case-sensitive)
  ```

#### 3. **Choices Format Normalization** ✅
- **Problem**: Choices were being normalized to comma+space format `', '` but API expects semicolon-separated
- **Solution**: 
  - Accept both semicolon and comma as separators
  - Split by regex `[,;]` to handle both formats
  - Trim whitespace from each choice
  - Store as semicolon-separated string: `"Facebook;Microsoft;Google;Oracle"`
  - This matches the exact API format from curl example

#### 4. **Error Message Clarity** ✅
- **Problem**: Generic error messages didn't help diagnose validation issues
- **Solution**: Specific error messages for each validation failure:
  - "Selected video not found"
  - "Timestamp must be 0 or greater"
  - "Question cannot be empty"
  - "Choices cannot be empty"
  - "Correct answer must match one of the choices exactly. Available: {list}"

#### 5. **Dialog Error Handling** ✅
- **Problem**: Dialog closed on validation error, forcing user to reopen and re-enter data
- **Solution**:
  - Keep dialog open on validation errors
  - User can fix and retry without losing input
  - Only close dialog on success or session expiration
  - Session expired errors close dialog and prompt login

---

## API Endpoint Verification

### Create Checkpoint
```
POST /checkpoints/
Authorization: Bearer {token}
Content-Type: application/json

Request Body:
{
  "video_id": 2,
  "timestamp": 150,
  "question": "Dart is developed by which company?",
  "choices": "Facebook;Microsoft;Google;Oracle",
  "correct_answer": "Google",
  "required": true
}

Response (200 OK):
{
  "id": 1,
  "video_id": 2,
  "timestamp": 150,
  "question": "Dart is developed by which company?",
  "choices": "Facebook;Microsoft;Google;Oracle",
  "correct_answer": "Google",
  "required": true
}
```

### Expected Field Format
| Field | Type | Format | Example |
|-------|------|--------|---------|
| `video_id` | Integer | Must exist in videos table | `2` |
| `timestamp` | Integer | Seconds, >= 0 | `150` |
| `question` | String | Non-empty text | `"Dart is developed by which company?"` |
| `choices` | String | Semicolon-separated | `"Facebook;Microsoft;Google;Oracle"` |
| `correct_answer` | String | Must match one choice exactly | `"Google"` |
| `required` | Boolean | true or false | `true` |

---

## Implementation Checklist

### Video Management Screen (`video_management_screen.dart`)
- ✅ Improved checkpoint dialog with better UX
- ✅ Removed editable video ID field
- ✅ Auto-populate video ID from selected video
- ✅ Better styling with Material Design 3
- ✅ Improved error handling with floating snackbars
- ✅ Session expiration detection and login prompt

### VideoViewModel (`video_viewmodel.dart`)
- ✅ Added client-side validation for all checkpoint fields
- ✅ Regex-based choice splitting (handles both ; and ,)
- ✅ Semicolon-normalized choice storage
- ✅ Case-sensitive correct answer matching
- ✅ Detailed error messages for debugging
- ✅ Console logging of payload and response (debug prints)
- ✅ Auto-refresh checkpoints after successful creation

### Checkpoint Remote Data Source (`checkpoint_remote_data_source.dart`)
- ✅ Correct endpoint URL: `/checkpoints/`
- ✅ Auth header included: `requiresAuth: true`
- ✅ Correct HTTP method: POST
- ✅ Proper response parsing from API

### API Constants (`api_constants.dart`)
- ✅ Endpoint defined: `static const String checkpoints = '/checkpoints/';`

---

## Testing Checkpoint Creation

### Step-by-Step Test Guide

1. **Navigate to Video Management Screen**
   - Admin dashboard → Video Management
   - Videos should be loaded from API

2. **Add a Checkpoint**
   - Click popup menu (⋮) on any video
   - Select "Add Checkpoint"
   - Dialog opens showing:
     - Video title
     - Video ID (read-only)
     - Timestamp field
     - Question field
     - Choices field
     - Correct Answer field
     - Required checkbox

3. **Fill Form with Test Data**
   ```
   Timestamp:     150
   Question:      Dart is developed by which company?
   Choices:       Facebook; Microsoft; Google; Oracle
   Correct Ans:   Google
   Required:      ✓ (checked)
   ```

4. **Expected Success Response**
   - Dialog closes
   - Green snackbar: "Checkpoint added successfully"
   - Checkpoint appears in video's checkpoint list
   - API logs show: `"id": 1` (or next ID)

5. **Test Validation Errors**
   
   **Error: Empty Question**
   - Leave question blank
   - Click "Add Checkpoint"
   - Red snackbar: "Question cannot be empty"
   - Dialog stays open

   **Error: Wrong Correct Answer**
   - Question: "Test?"
   - Choices: "A; B; C"
   - Correct Answer: "D"
   - Click "Add Checkpoint"
   - Red snackbar: "Correct answer must match one of the choices exactly. Available: A, B, C"
   - Dialog stays open

   **Error: Invalid Timestamp**
   - Timestamp: -5
   - Click "Add Checkpoint"
   - Red snackbar: "Timestamp must be 0 or greater"
   - Dialog stays open

---

## Console Debugging

When you click "Add Checkpoint", check the console (flutter run terminal) for:

```
🧾 CreateCheckpoint payload: {
  "video_id": 2,
  "timestamp": 150,
  "question": "Dart is developed by which company?",
  "choices": "Facebook;Microsoft;Google;Oracle",
  "correct_answer": "Google",
  "required": true
}

🧾 CreateCheckpoint response: success=true, status=200, message=null
```

If you see `success=false`, check the `message` field for the server error:
- `message: "Video not found"` → Use a valid video ID
- `message: "Invalid timestamp"` → Timestamp issue
- `message: "Duplicate checkpoint at timestamp"` → Checkpoint already exists at that time

---

## If Still Getting Internal Server Error

1. **Check Server Logs**
   - Backend should log the request and error reason
   - Common issues:
     - Database constraint violation (duplicate checkpoint)
     - Invalid video_id (doesn't exist)
     - Malformed request body

2. **Verify Payload Format**
   - Click "Add Checkpoint"
   - Check console for `🧾 CreateCheckpoint payload:`
   - Compare with curl example format
   - Ensure `choices` is semicolon-separated: `"A;B;C"` (not `"A, B, C"`)

3. **Check Token Validity**
   - If you see 401 error, token expired
   - Dialog will show: "Your session has expired. Please login again."
   - Login again and retry

4. **Verify Video Exists**
   - Ensure video ID in dialog matches a loaded video
   - Video should appear in the video list on screen
   - If video doesn't appear, try refreshing the page

---

## Files Modified

1. `lib/presentation/views/admin/video_management_screen.dart`
   - Updated `_showAddCheckpointDialog()` method

2. `lib/presentation/viewmodels/video_viewmodel.dart`
   - Enhanced `createCheckpoint()` with validation
   - Added choice normalization logic
   - Improved error messages

---

## Next Steps

1. ✅ Test checkpoint creation with the test data above
2. ✅ Verify checkpoints appear in the list after creation
3. ✅ Test error scenarios (empty fields, wrong answer, etc.)
4. ✅ Check console logs for payload/response details
5. ✅ If errors persist, share console logs in the error message format
