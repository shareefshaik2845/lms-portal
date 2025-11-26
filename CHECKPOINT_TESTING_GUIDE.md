# Checkpoint Creation - Step-by-Step Testing Guide

## 🚀 Quick Start Test

### Prerequisites
- ✅ App is running in Flutter emulator/device
- ✅ You are logged in as admin
- ✅ At least one video exists in Video Management screen
- ✅ Terminal is open to see console logs

### Test Steps

#### Step 1: Navigate to Video Management
```
1. Open app
2. Go to Admin Dashboard
3. Tap "Video Management"
4. Wait for videos to load (should see video list)
```

#### Step 2: Open Add Checkpoint Dialog
```
1. Long-press or tap menu (⋮) on any video card
2. Select "Add Checkpoint"
3. Dialog should open with:
   - Video title at the top
   - "Video ID: X" below title (read-only)
   - Timestamp field
   - Question field
   - Choices field
   - Correct Answer field
   - Required checkbox
   - Cancel and Add Checkpoint buttons
```

#### Step 3: Fill Test Data
```
Timestamp:         150
Question:          Dart is developed by which company?
Choices:           Facebook; Microsoft; Google; Oracle
Correct Answer:    Google
Required:          ☑ (checkbox should be checked)
```

#### Step 4: Create Checkpoint
```
1. Click "Add Checkpoint" button
2. Watch for one of these outcomes:

EXPECTED SUCCESS:
├─ Dialog closes
├─ Green snackbar appears: "Checkpoint added successfully"
├─ Console shows: "success=true, status=200"
├─ Checkpoint appears in video's expanded list
└─ Video shows "1 checkpoints" instead of "0 checkpoints"

IF ERROR:
├─ Dialog stays open
├─ Red snackbar shows specific error message
├─ Console shows: "success=false, status=XXX, message=..."
└─ User can fix and retry
```

---

## 🧪 Detailed Testing Scenarios

### Scenario 1: Valid Checkpoint Creation ✅

**Input**:
```
Timestamp:      150
Question:       Dart is developed by which company?
Choices:        Facebook; Microsoft; Google; Oracle
Correct Ans:    Google
Required:       ✓
```

**Expected Result**:
```
✅ Dialog closes
✅ Snackbar: "Checkpoint added successfully"
✅ Console output:
   🧾 CreateCheckpoint payload: {
     video_id: X,
     timestamp: 150,
     question: "Dart is developed by which company?",
     choices: "Facebook;Microsoft;Google;Oracle",
     correct_answer: "Google",
     required: true
   }
   🧾 CreateCheckpoint response: success=true, status=200, message=null

✅ Checkpoint visible in list:
   [Lock Icon] Dart is developed...
   Answer: Google
```

---

### Scenario 2: Empty Question ❌→✅ (Fixed)

**Input**:
```
Timestamp:      150
Question:       [EMPTY]
Choices:        Option A; Option B
Correct Ans:    Option A
Required:       ✓
```

**Expected Result**:
```
❌ Click "Add Checkpoint"
❌ Error shows: "Question cannot be empty"
❌ Dialog STAYS OPEN (user can fix)
❌ Red snackbar: Message with error
```

**Fix**: Type something in Question field, retry

---

### Scenario 3: Wrong Correct Answer ❌→✅ (Fixed)

**Input**:
```
Timestamp:      150
Question:       Which language?
Choices:        Python; JavaScript; Dart
Correct Ans:    Go  [WRONG - not in list]
Required:       ✓
```

**Expected Result**:
```
❌ Click "Add Checkpoint"
❌ Error shows: "Correct answer must match one of the choices exactly. Available: Python, JavaScript, Dart"
❌ Dialog STAYS OPEN (user can fix)
❌ Red snackbar: Message with available choices
```

**Fix**: Change to "Python" or "JavaScript" or "Dart", retry

---

### Scenario 4: Negative Timestamp ❌→✅ (Fixed)

**Input**:
```
Timestamp:      -50  [INVALID]
Question:       Test?
Choices:        A; B; C
Correct Ans:    A
Required:       ✓
```

**Expected Result**:
```
❌ Click "Add Checkpoint"
❌ Error shows: "Timestamp must be 0 or greater"
❌ Dialog STAYS OPEN (user can fix)
❌ Red snackbar: Message about timestamp
```

**Fix**: Change to positive number (e.g., 0, 100, 150), retry

---

### Scenario 5: Empty Choices ❌→✅ (Fixed)

**Input**:
```
Timestamp:      150
Question:       What?
Choices:        [EMPTY]
Correct Ans:    A
Required:       ✓
```

**Expected Result**:
```
❌ Click "Add Checkpoint"
❌ Error shows: "Choices cannot be empty"
❌ Dialog STAYS OPEN (user can fix)
❌ Red snackbar: Message about choices
```

**Fix**: Add choices separated by semicolon or comma, retry

---

### Scenario 6: Choices Format Variations ✅ (All Work)

**Test**: All these input formats should work

```
Format 1: Facebook; Microsoft; Google; Oracle
         ↓ (processed as)
         Facebook;Microsoft;Google;Oracle

Format 2: Facebook, Microsoft, Google, Oracle
         ↓ (processed as)
         Facebook;Microsoft;Google;Oracle

Format 3: Facebook;Microsoft;Google;Oracle
         ↓ (processed as)
         Facebook;Microsoft;Google;Oracle

Format 4: Facebook , Microsoft , Google , Oracle
         ↓ (processed as)
         Facebook;Microsoft;Google;Oracle
```

**Expected**: All formats result in same API call with `"Facebook;Microsoft;Google;Oracle"`

---

## 📊 Console Log Monitoring

Open terminal where you ran `flutter run` and watch for these logs:

### On Successful Creation
```
🧾 CreateCheckpoint payload: {video_id: 2, timestamp: 150, question: Dart is developed..., choices: Facebook;Microsoft;Google;Oracle, correct_answer: Google, required: true}
🧾 CreateCheckpoint response: success=true, status=200, message=null
```

✅ Everything looks good! Checkpoint was created successfully.

### On Validation Error (Before API Call)
```
❌ No "CreateCheckpoint payload" log
❌ Red snackbar shows error instead
```

User input didn't pass validation, so API wasn't called. This is GOOD - prevents invalid data.

### On API Error (After API Call)
```
🧾 CreateCheckpoint payload: {...}
🧾 CreateCheckpoint response: success=false, status=500, message=Internal Server Error
```

❌ Request was sent but API rejected it. Check:
1. Backend logs
2. Video ID is valid
3. No duplicate checkpoint at same timestamp

---

## 🔍 What to Check in Expanded Video List

After successful checkpoint creation, expand the video card by tapping on it:

```
Video Title: [Video Name]
Duration: 150 seconds
Checkpoints: 1 checkpoint

[Icon] Question Text
Answer: Correct Answer
[Lock/Unlock Icon] (based on required status)

[Next checkpoint if exists...]
```

---

## 🛠️ Troubleshooting

### Issue: Dialog didn't close, got error "Internal Server Error"

**Check**:
1. Console logs - what was the payload?
2. Is video ID valid? (Should match a loaded video)
3. Did backend server restart? (Sometimes resets)
4. Are there any backend error logs?

**Solution**:
- Check backend logs for details
- Try with a different video
- Restart backend server
- Share console logs with developer

### Issue: Dialog closed but checkpoint didn't appear in list

**Check**:
1. Refresh the page
2. Check if "1 checkpoints" shows under video
3. Expand video to see checkpoint

**Solution**:
- Page might need refresh to show new data
- Check backend to confirm checkpoint was created

### Issue: Wrong choices format was sent

**Check**:
1. Console log shows payload format
2. Should be: `"Facebook;Microsoft;Google;Oracle"` (no spaces, semicolon)
3. NOT: `"Facebook, Microsoft, Google, Oracle"` (spaces, comma)

**Solution**: 
- This is now FIXED - should auto-format correctly
- But if still wrong, check VideoViewModel code

### Issue: Token expired (401 error)

**Check**:
1. Dialog shows: "Your session has expired. Please login again."
2. Console shows: `status=401`

**Solution**:
1. Click the "Login" button in dialog
2. Re-enter credentials
3. Go back to Video Management
4. Try creating checkpoint again

---

## ✅ Validation Checklist

Before submitting bug report, verify:

- ✅ Ran `flutter pub get` recently
- ✅ App is fully rebuilt (hot restart, not hot reload)
- ✅ Logged in with admin account
- ✅ Video exists and is loaded in list
- ✅ Token is valid (not expired)
- ✅ All form fields filled with valid data
- ✅ Checked console logs for error details
- ✅ Tried with different test data
- ✅ Restarted backend server if available

---

## 📝 Bug Report Template

If you still get errors, share this info:

```
### Issue: [Your description]

#### What I Did
1. Step 1
2. Step 2
3. Step 3

#### Expected Result
[What should happen]

#### Actual Result
[What actually happened]

#### Console Output
[Paste the 🧾 log lines]

#### Form Data Used
- Timestamp: 150
- Question: [exact text]
- Choices: [exact text]
- Correct Answer: [exact text]
- Required: [checked/unchecked]

#### Video ID
- Video ID: [from dialog]
- Video Title: [from dialog]

#### Token Status
- Token is valid: [yes/no]
- Token expires: [timestamp or "soon"]
```

---

## 🎯 Success Criteria

Checkpoint creation is working correctly when:

1. ✅ Valid data → Creates successfully
2. ✅ Invalid data → Shows specific error without dialog closing
3. ✅ Error message → Clear and actionable
4. ✅ Console logs → Shows payload and status 200
5. ✅ UI updates → Checkpoint appears in video list
6. ✅ Multiple attempts → Works for multiple checkpoints per video
7. ✅ Format flexibility → Accepts ; and , separators
8. ✅ Session handling → Shows login dialog on 401

If all 8 pass, checkpoint creation is FULLY WORKING! 🎉
