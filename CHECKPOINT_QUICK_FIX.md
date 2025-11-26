# Checkpoint API Integration - Quick Reference

## What Was Wrong ❌

1. **Dialog allowed manual video ID entry**
   - Users could enter wrong/non-existent video IDs
   - Server would return 500 error

2. **No client-side validation**
   - Invalid data reached the API
   - Server had to reject it with error

3. **Choices format was wrong**
   - Sent: `"Facebook, Microsoft, Google, Oracle"` (with spaces, comma)
   - Expected: `"Facebook;Microsoft;Google;Oracle"` (no spaces, semicolon)

4. **Dialog closed on error**
   - User had to re-enter all data after fixing one field

## What's Fixed ✅

### 1. Dialog UI Changes
```dart
// BEFORE: Had manual video ID input field
TextField(
  controller: videoIdController,
  decoration: const InputDecoration(labelText: 'Video ID'),
  keyboardType: TextInputType.number,
),

// AFTER: Video ID is read-only and auto-populated
Text(
  'Video ID: $videoId',
  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
),
```

### 2. Validation Logic
```dart
// Now validates BEFORE sending to API:
if (!_videos.any((v) => v.id == videoId)) {
  _errorMessage = 'Selected video not found';
  return false;
}

if (timestamp < 0) {
  _errorMessage = 'Timestamp must be 0 or greater';
  return false;
}

if (question.trim().isEmpty) {
  _errorMessage = 'Question cannot be empty';
  return false;
}

// Split by BOTH comma and semicolon
final choicesList = choices
    .split(RegExp('[,;]'))  // Handles both separators!
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .toList();

// Validate correct answer matches
if (!choicesList.contains(correctAnswer.trim())) {
  _errorMessage = 'Correct answer must match one of the choices exactly.';
  return false;
}
```

### 3. Choices Format Fix
```dart
// BEFORE: Normalized to comma + space
choices: choices
    .replaceAll(';', ',')
    .split(',')
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .join(', ')  // ❌ "A, B, C"

// AFTER: Normalized to semicolon (no spaces)
choices: choicesList.join(';')  // ✅ "A;B;C"
```

### 4. Error Handling
```dart
// BEFORE: Dialog closed immediately
Navigator.of(dialogContext).pop();

// AFTER: Dialog stays open on validation errors
if (success) {
  Navigator.of(dialogContext).pop();  // Close only on success
} else {
  // Dialog stays open, user can fix
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(viewModel.errorMessage))
  );
}
```

## Test with This Data

**Fill these exact values in the dialog:**

| Field | Value |
|-------|-------|
| Timestamp | `150` |
| Question | `Dart is developed by which company?` |
| Choices | `Facebook; Microsoft; Google; Oracle` |
| Correct Answer | `Google` |
| Required | ☑ (checked) |

**Expected Result:**
- ✅ No error message
- ✅ Dialog closes
- ✅ Green snackbar: "Checkpoint added successfully"
- ✅ New checkpoint appears in the list
- ✅ Console shows: `success=true, status=200`

## Common Errors Fixed

### Error: "Selected video not found"
- **Cause**: Video doesn't exist in loaded list
- **Fix**: Make sure you selected a valid video before adding checkpoint

### Error: "Correct answer must match one of the choices exactly"
- **Before**: User had to close dialog, reopen, and enter again
- **After**: Error message shows available choices, dialog stays open to fix

### Error: "Timestamp must be 0 or greater"
- **Before**: Silent failure, server error
- **After**: Clear error, user knows to fix timestamp

### Error: "Internal Server Error"
- **Before**: Happened because choices format was wrong
- **After**: Choices automatically formatted correctly before sending

## Console Output for Debugging

When creating a checkpoint, you'll see in console (if you have Flutter running):

```
🧾 CreateCheckpoint payload: {video_id: 2, timestamp: 150, question: Dart..., choices: Facebook;Microsoft;Google;Oracle, correct_answer: Google, required: true}
🧾 CreateCheckpoint response: success=true, status=200, message=null
```

If you see `success=false`, the `message` field will tell you why.

## API Call Made

```
POST http://16.170.31.99:8000/checkpoints/
Authorization: Bearer {token}
Content-Type: application/json

{
  "video_id": 2,
  "timestamp": 150,
  "question": "Dart is developed by which company?",
  "choices": "Facebook;Microsoft;Google;Oracle",
  "correct_answer": "Google",
  "required": true
}
```

✅ Now exactly matches the curl example format you provided!

---

## Migration Guide

| Before | After | Benefit |
|--------|-------|---------|
| Manual video ID input | Auto video ID | Prevents invalid IDs |
| No validation | Full validation | Prevents server errors |
| Choices: `"A, B, C"` | Choices: `"A;B;C"` | Matches API format |
| Dialog closes on error | Dialog stays open | User can fix without re-entering |
| Generic errors | Specific errors | Easy to debug |
| No logging | Console logs | Can see exact request/response |

All changes are backward compatible - existing code still works, but checkpoint creation now works correctly!
