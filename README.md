# clinicaldatascanner

A new Flutter project.

## CRL for gemini chat

```bash
curl \
  -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=YOU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [
      {
        "parts": [
          { "text": "can you help me identifying text?" }
        ]
      }
    ]
  }'
```
## Listing available models
```bash
  curl "https://generativelanguage.googleapis.com/v1beta/models?key=YOU_API_KEY"
```





