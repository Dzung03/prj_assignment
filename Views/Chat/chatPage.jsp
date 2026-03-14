<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SafeMove AI – Trợ lý thông minh</title>
    <style>
        /* ===== RESET ===== */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: #0f0f1a;
            color: #e2e8f0;
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* ===== TOP BAR ===== */
        .topbar {
            background: rgba(26, 32, 44, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,.08);
            padding: 0 1.5rem;
            height: 58px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
            z-index: 10;
        }
        .topbar-left { display: flex; align-items: center; gap: .8rem; }
        .topbar-left a {
            color: #94a3b8; text-decoration: none; font-size: .85rem;
            display: flex; align-items: center; gap: .3rem; transition: color .2s;
        }
        .topbar-left a:hover { color: #63b3ed; }
        .topbar-title {
            font-size: 1rem; font-weight: 700; color: #fff;
            display: flex; align-items: center; gap: .5rem;
        }
        .ai-badge {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff; font-size: .68rem; padding: .15rem .5rem;
            border-radius: 20px; font-weight: 700; letter-spacing: .5px;
        }
        .topbar-right { display: flex; align-items: center; gap: .8rem; }
        .btn-clear {
            background: rgba(255,255,255,.08); color: #94a3b8;
            border: 1px solid rgba(255,255,255,.1);
            padding: .4rem .9rem; border-radius: 8px;
            font-size: .82rem; cursor: pointer; text-decoration: none;
            display: flex; align-items: center; gap: .3rem;
            transition: all .2s;
        }
        .btn-clear:hover { background: rgba(229,62,62,.15); color: #fc8181; border-color: rgba(229,62,62,.3); }

        /* ===== CHAT LAYOUT ===== */
        .chat-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            max-width: 860px;
            width: 100%;
            margin: 0 auto;
            padding: 0 1rem;
            overflow: hidden;
        }

        /* ===== MESSAGES ===== */
        #messages {
            flex: 1;
            overflow-y: auto;
            padding: 1.5rem 0;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            scroll-behavior: smooth;
        }
        #messages::-webkit-scrollbar { width: 5px; }
        #messages::-webkit-scrollbar-track { background: transparent; }
        #messages::-webkit-scrollbar-thumb { background: rgba(255,255,255,.1); border-radius: 10px; }

        /* Welcome screen */
        .welcome {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            gap: 1rem;
            padding: 2rem;
            opacity: 1;
            transition: opacity .3s;
        }
        .welcome.hidden { display: none; }
        .welcome-icon { font-size: 3.5rem; animation: float 3s ease-in-out infinite; }
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        .welcome h2 { font-size: 1.5rem; font-weight: 700; color: #fff; }
        .welcome p { color: #94a3b8; font-size: .92rem; max-width: 400px; line-height: 1.6; }
        .suggestions {
            display: flex; flex-wrap: wrap; gap: .6rem;
            justify-content: center; margin-top: .5rem;
        }
        .suggestion-btn {
            background: rgba(255,255,255,.06); border: 1px solid rgba(255,255,255,.1);
            color: #cbd5e0; padding: .5rem 1rem; border-radius: 20px;
            font-size: .82rem; cursor: pointer; transition: all .2s;
        }
        .suggestion-btn:hover {
            background: rgba(102,126,234,.2); border-color: rgba(102,126,234,.4);
            color: #a78bfa;
        }

        /* Message bubbles */
        .msg {
            display: flex;
            gap: .8rem;
            animation: fadeInUp .25s ease;
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .msg.user { flex-direction: row-reverse; }

        .msg-avatar {
            width: 34px; height: 34px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: .9rem; flex-shrink: 0; margin-top: 2px;
        }
        .msg.user .msg-avatar {
            background: linear-gradient(135deg, #3182ce, #63b3ed);
        }
        .msg.ai .msg-avatar {
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        .msg-bubble {
            max-width: 70%;
            padding: .75rem 1rem;
            border-radius: 16px;
            font-size: .92rem;
            line-height: 1.65;
            white-space: pre-wrap;
            word-break: break-word;
        }
        .msg.user .msg-bubble {
            background: linear-gradient(135deg, #2b6cb0, #3182ce);
            color: #fff;
            border-bottom-right-radius: 4px;
        }
        .msg.ai .msg-bubble {
            background: rgba(255,255,255,.07);
            border: 1px solid rgba(255,255,255,.08);
            color: #e2e8f0;
            border-bottom-left-radius: 4px;
        }

        /* Typing indicator */
        .typing-indicator {
            display: none;
            align-items: center;
            gap: .8rem;
            padding: 0 0 .5rem;
        }
        .typing-indicator.visible { display: flex; }
        .typing-dots {
            background: rgba(255,255,255,.07);
            border: 1px solid rgba(255,255,255,.08);
            border-radius: 16px; border-bottom-left-radius: 4px;
            padding: .75rem 1rem;
            display: flex; gap: 4px; align-items: center;
        }
        .typing-dots span {
            width: 7px; height: 7px; border-radius: 50%;
            background: #94a3b8;
            animation: bounce 1.2s infinite ease-in-out;
        }
        .typing-dots span:nth-child(2) { animation-delay: .2s; }
        .typing-dots span:nth-child(3) { animation-delay: .4s; }
        @keyframes bounce {
            0%, 80%, 100% { transform: translateY(0); opacity: .4; }
            40% { transform: translateY(-6px); opacity: 1; }
        }

        /* ===== INPUT AREA ===== */
        .input-area {
            padding: 1rem 0 1.5rem;
            flex-shrink: 0;
        }
        .input-box {
            display: flex;
            align-items: flex-end;
            gap: .6rem;
            background: rgba(255,255,255,.06);
            border: 1.5px solid rgba(255,255,255,.12);
            border-radius: 14px;
            padding: .6rem .6rem .6rem 1rem;
            transition: border-color .2s, box-shadow .2s;
        }
        .input-box:focus-within {
            border-color: rgba(102,126,234,.6);
            box-shadow: 0 0 0 3px rgba(102,126,234,.1);
        }
        #msgInput {
            flex: 1;
            background: transparent;
            border: none;
            outline: none;
            color: #e2e8f0;
            font-size: .93rem;
            line-height: 1.5;
            resize: none;
            max-height: 140px;
            min-height: 26px;
            font-family: inherit;
        }
        #msgInput::placeholder { color: #4a5568; }
        #sendBtn {
            width: 38px; height: 38px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none; border-radius: 10px;
            color: #fff; font-size: 1rem;
            cursor: pointer; display: flex;
            align-items: center; justify-content: center;
            flex-shrink: 0;
            transition: all .2s;
        }
        #sendBtn:hover:not(:disabled) { transform: scale(1.08); filter: brightness(1.1); }
        #sendBtn:disabled { opacity: .4; cursor: not-allowed; transform: none; }

        .input-hint {
            text-align: center; color: #4a5568;
            font-size: .75rem; margin-top: .6rem;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 640px) {
            .msg-bubble { max-width: 85%; }
            .chat-wrapper { padding: 0 .75rem; }
        }
    </style>
</head>
<body>

<!-- TOP BAR -->
<div class="topbar">
    <div class="topbar-left">
        <a href="<%= request.getContextPath() %>/home">← Trang chủ</a>
    </div>
    <div class="topbar-title">
        🚚 SafeMove AI <span class="ai-badge">GROQ</span>
    </div>
    <div class="topbar-right">
        <a href="<%= request.getContextPath() %>/chat/clear" class="btn-clear"
           onclick="return confirm('Xoá toàn bộ lịch sử trò chuyện?')">
            🗑️ Xoá chat
        </a>
    </div>
</div>

<!-- CHAT -->
<div class="chat-wrapper">
    <div id="messages">

        <!-- Welcome Screen -->
        <div class="welcome" id="welcome">
            <div class="welcome-icon">🤖</div>
            <h2>Xin chào! Tôi là SafeMove AI</h2>
            <p>Trợ lý thông minh giúp bạn tìm hiểu về dịch vụ chuyển nhà, báo giá, và mọi thứ liên quan đến SafeMove.</p>
            <div class="suggestions">
                <button class="suggestion-btn" onclick="sendSuggestion(this)">💰 Báo giá chuyển nhà</button>
                <button class="suggestion-btn" onclick="sendSuggestion(this)">🚛 Các loại xe có sẵn</button>
                <button class="suggestion-btn" onclick="sendSuggestion(this)">📅 Đặt lịch chuyển nhà</button>
                <button class="suggestion-btn" onclick="sendSuggestion(this)">👷 Dịch vụ bốc xếp</button>
                <button class="suggestion-btn" onclick="sendSuggestion(this)">📦 Chuyển văn phòng</button>
            </div>
        </div>

    </div>

    <!-- Typing indicator -->
    <div class="typing-indicator" id="typingIndicator">
        <div class="msg-avatar">🤖</div>
        <div class="typing-dots">
            <span></span><span></span><span></span>
        </div>
    </div>

    <!-- Input -->
    <div class="input-area">
        <div class="input-box">
            <textarea id="msgInput" placeholder="Nhập câu hỏi của bạn..." rows="1"></textarea>
            <button id="sendBtn" onclick="sendMessage()" title="Gửi (Enter)">➤</button>
        </div>
        <div class="input-hint">Nhấn Enter để gửi · Shift+Enter xuống dòng</div>
    </div>
</div>

<script>
    const CONTEXT = '<%= request.getContextPath() %>';
    const messagesEl = document.getElementById('messages');
    const typingEl   = document.getElementById('typingIndicator');
    const inputEl    = document.getElementById('msgInput');
    const sendBtn    = document.getElementById('sendBtn');
    const welcomeEl  = document.getElementById('welcome');

    /* ===== AUTO-RESIZE TEXTAREA ===== */
    inputEl.addEventListener('input', () => {
        inputEl.style.height = 'auto';
        inputEl.style.height = Math.min(inputEl.scrollHeight, 140) + 'px';
    });

    /* ===== ENTER KEY ===== */
    inputEl.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });

    /* ===== SUGGESTION BUTTONS ===== */
    function sendSuggestion(btn) {
        inputEl.value = btn.textContent.replace(/^[^\s]+\s/, '');
        sendMessage();
    }

    /* ===== ADD MESSAGE BUBBLE ===== */
    function addMsg(role, text) {
        welcomeEl.classList.add('hidden');

        const div = document.createElement('div');
        div.className = `msg ${role}`;

        const avatar = document.createElement('div');
        avatar.className = 'msg-avatar';
        avatar.textContent = role === 'user' ? '👤' : '🤖';

        const bubble = document.createElement('div');
        bubble.className = 'msg-bubble';
        bubble.textContent = text;   // dùng textContent để tránh XSS

        div.appendChild(avatar);
        div.appendChild(bubble);
        messagesEl.appendChild(div);
        scrollToBottom();
    }

    /* ===== SCROLL ===== */
    function scrollToBottom() {
        messagesEl.scrollTop = messagesEl.scrollHeight;
    }

    /* ===== SEND MESSAGE ===== */
    async function sendMessage() {
        const msg = inputEl.value.trim();
        if (!msg) return;

        // Reset input
        inputEl.value = '';
        inputEl.style.height = 'auto';
        sendBtn.disabled = true;

        addMsg('user', msg);

        // Show typing
        typingEl.classList.add('visible');
        scrollToBottom();

        try {
            // URLSearchParams → application/x-www-form-urlencoded
            // (FormData gửi multipart → request.getParameter() không đọc được)
            const params = new URLSearchParams();
            params.append('message', msg);

            const res = await fetch(CONTEXT + '/chat/send', {
                method: 'POST',
                body: params
            });

            // Kiểm tra status trước khi parse JSON
            if (!res.ok) {
                const text = await res.text();
                typingEl.classList.remove('visible');
                addMsg('ai', '❌ Server lỗi (HTTP ' + res.status + '). Hãy Clean & Build lại project.');
                console.error('Server response:', text);
                return;
            }

            let data;
            try {
                data = await res.json();
            } catch (parseErr) {
                typingEl.classList.remove('visible');
                addMsg('ai', '❌ Phản hồi không hợp lệ từ server. Hãy thử lại!');
                return;
            }

            typingEl.classList.remove('visible');

            if (data.error) {
                addMsg('ai', '❌ ' + data.error);
            } else {
                addMsg('ai', data.reply);
            }
        } catch (err) {
            typingEl.classList.remove('visible');
            addMsg('ai', '❌ Lỗi mạng: ' + err.message);
            console.error('Fetch error:', err);
        } finally {
            sendBtn.disabled = false;
            inputEl.focus();
        }
    }
</script>
</body>
</html>
