# Guide for Yahia: Connecting n8n to Local DocBot

To make n8n talk to the local Django server, we use **Serveo** to create a secure tunnel. Follow these steps:

## 1. How to "Run" Serveo
You don't actually need to download anything! Serveo works through standard SSH. 

Open your terminal (PowerShell, CMD, or Linux Terminal) and run:
```bash
ssh -R 80:localhost:8000 serveo.net
```

### Important:
- **Port 8000**: This is the port where Django is running (`python manage.py runserver`).
- **The URL**: Once you run the command, Serveo will give you a link (e.g., `https://xyz.serveo.net`). **This is the link you use in n8n.**
- **Keep it Open**: If you close the terminal, the connection to n8n will break.

---

## 2. Setting up n8n (HTTP Request Nodes)
Whenever n8n calls the Django API (to read or write data), you **MUST** include these headers to bypass security blocks:

| Header Name | Value | Purpose |
| :--- | :--- | :--- |
| `bypass-tunnel-reminder` | `true` | Bypasses the Serveo warning page. |
| `X-Chatbot-Token` | `[The Token]` | Sent in the initial chat payload. |
| `Content-Type` | `application/json` | Standard JSON format. |

### Webhook URL Example:
`https://[YOUR_SERVEO_URL]/chat/api/webhook/`

---

## 3. Data Structure
The chatbot sends messages to n8n in this format:
```json
{
  "chatInput": "The user's message",
  "text": "The user's message",
  "sessionId": "user_1",
  "user_id": "1",
  "token": "..."
}
```
Use the `sessionId` for the **Window Buffer Memory** node in n8n to keep the conversation history alive.
