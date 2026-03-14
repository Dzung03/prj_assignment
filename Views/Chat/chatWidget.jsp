<%@ page contentType="text/html;charset=UTF-8" %>
<%-- =====================================================================
     chatWidget.jsp – Floating AI Chat Widget
     Cách nhúng vào JSP: <jsp:include page="/Views/Chat/chatWidget.jsp"/>
     Đặt ngay trước </body> của trang JSP muốn hiển thị widget.
     ===================================================================== --%>

<style>
/* ===== FLOATING BUTTON ===== */
#chat-fab {
    position: fixed;
    bottom: 28px;
    right: 28px;
    width: 58px;
    height: 58px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: #fff;
    border: none;
    cursor: pointer;
    font-size: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 20px rgba(102, 126, 234, .5);
    z-index: 9999;
    transition: all .25s;
    animation: fabPulse 2.5s ease-in-out infinite;
}
#chat-fab:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 28px rgba(102, 126, 234, .7);
    animation: none;
}
@keyframes fabPulse {
    0%, 100% { box-shadow: 0 4px 20px rgba(102,126,234,.5); }
    50%       { box-shadow: 0 4px 30px rgba(102,126,234,.9); }
}

/* Badge unread */
#chat-badge {
    position: absolute;
    top: -3px; right: -3px;
    width: 18px; height: 18px;
    background: #fc8181;
    border-radius: 50%;
    font-size: .65rem;
    font-weight: 700;
    display: none;
    align-items: center;
    justify-content: center;
    border: 2px solid #0f0f1a;
    color: #fff;
}
#chat-badge.show { display: flex; }

/* ===== POPUP WINDOW ===== */
#chat-popup {
    position: fixed;
    bottom: 98px;
    right: 28px;
    width: 370px;
    max-height: 520px;
    background: #1a1a2e;
    border: 1px solid rgba(255,255,255,.1);
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,.5);
    display: flex;
    flex-direction: column;
    z-index: 9998;
    overflow: hidden;
    transform: scale(0.85) translateY(20px);
    opacity: 0;
    pointer-events: none;
    transition: all .25s cubic-bezier(.34, 1.56, .64, 1);
    transform-origin: bottom right;
}
#chat-popup.open {
    transform: scale(1) translateY(0);
    opacity: 1;
    pointer-events: all;
}

/* Header */
.cw-header {
    background: linear-gradient(135deg, #667eea, #764ba2);
    padding: .9rem 1rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-shrink: 0;
}
.cw-header-left { display: flex; align-items: center; gap: .6rem; }
.cw-avatar {
    width: 36px; height: 36px; border-radius: 50%;
    background: rgba(255,255,255,.2);
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem;
}
.cw-title { font-weight: 700; color: #fff; font-size: .95rem; }
.cw-subtitle { font-size: .72rem; color: rgba(255,255,255,.75); display: flex; align-items: center; gap: .3rem; }
.cw-dot { width: 6px; height: 6px; border-radius: 50%; background: #68d391; }
.cw-header-right { display: flex; gap: .4rem; }
.cw-btn {
    background: rgba(255,255,255,.15); border: none;
    color: #fff; width: 28px; height: 28px;
    border-radius: 8px; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    font-size: .8rem; text-decoration: none;
    transition: background .2s;
}
.cw-btn:hover { background: rgba(255,255,255,.3); }

/* Messages */
.cw-messages {
    flex: 1;
    overflow-y: auto;
    padding: 1rem;
    display: flex;
    flex-direction: column;
    gap: .7rem;
    scroll-behavior: smooth;
}
.cw-messages::-webkit-scrollbar { width: 4px; }
.cw-messages::-webkit-scrollbar-thumb { background: rgba(255,255,255,.1); border-radius: 10px; }

.cw-msg {
    display: flex;
    gap: .5rem;
    animation: cwFade .2s ease;
}
@keyframes cwFade {
    from { opacity: 0; transform: translateY(6px); }
    to   { opacity: 1; transform: translateY(0); }
}
.cw-msg.user { flex-direction: row-reverse; }

.cw-msg-av {
    width: 26px; height: 26px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: .75rem; flex-shrink: 0; margin-top: 2px;
}
.cw-msg.user .cw-msg-av { background: linear-gradient(135deg, #3182ce,#63b3ed); }
.cw-msg.ai   .cw-msg-av { background: linear-gradient(135deg, #667eea,#764ba2); }

.cw-bubble {
    max-width: 78%;
    padding: .55rem .8rem;
    border-radius: 14px;
    font-size: .84rem;
    line-height: 1.55;
    white-space: pre-wrap;
    word-break: break-word;
    color: #e2e8f0;
}
.cw-msg.user .cw-bubble {
    background: linear-gradient(135deg, #2b6cb0, #3182ce);
    border-bottom-right-radius: 3px;
}
.cw-msg.ai .cw-bubble {
    background: rgba(255,255,255,.07);
    border: 1px solid rgba(255,255,255,.08);
    border-bottom-left-radius: 3px;
}

/* Typing dots */
.cw-typing {
    display: none;
    align-items: center;
    gap: .5rem;
}
.cw-typing.show { display: flex; }
.cw-dots {
    background: rgba(255,255,255,.07);
    border: 1px solid rgba(255,255,255,.08);
    border-radius: 14px; border-bottom-left-radius: 3px;
    padding: .55rem .8rem;
    display: flex; gap: 4px; align-items: center;
}
.cw-dots span {
    width: 6px; height: 6px; border-radius: 50%;
    background: #94a3b8;
    animation: cwBounce 1.2s infinite ease-in-out;
}
.cw-dots span:nth-child(2) { animation-delay: .2s; }
.cw-dots span:nth-child(3) { animation-delay: .4s; }
@keyframes cwBounce {
    0%, 80%, 100% { transform: translateY(0); opacity:.4; }
    40% { transform: translateY(-5px); opacity:1; }
}

/* Input */
.cw-input-area {
    padding: .7rem;
    border-top: 1px solid rgba(255,255,255,.06);
    display: flex;
    gap: .5rem;
    align-items: flex-end;
    flex-shrink: 0;
}
#cwInput {
    flex: 1;
    background: rgba(255,255,255,.06);
    border: 1.5px solid rgba(255,255,255,.1);
    border-radius: 10px;
    padding: .5rem .75rem;
    color: #e2e8f0;
    font-size: .85rem;
    font-family: inherit;
    resize: none;
    outline: none;
    max-height: 80px;
    min-height: 36px;
    line-height: 1.5;
    transition: border-color .2s;
}
#cwInput:focus { border-color: rgba(102,126,234,.6); }
#cwInput::placeholder { color: #4a5568; }
#cwSend {
    width: 36px; height: 36px;
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none; border-radius: 10px;
    color: #fff; font-size: .9rem;
    cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
    transition: all .2s;
}
#cwSend:hover:not(:disabled) { transform: scale(1.08); filter: brightness(1.1); }
#cwSend:disabled { opacity: .4; cursor: not-allowed; }

/* Welcome msg */
.cw-welcome {
    text-align: center; padding: .5rem;
    color: #94a3b8; font-size: .8rem; line-height: 1.5;
}

/* ===== RESPONSIVE ===== */
@media (max-width: 430px) {
    #chat-popup { width: calc(100vw - 24px); right: 12px; bottom: 90px; }
    #chat-fab   { right: 16px; bottom: 20px; }
}
</style>

<!-- ===== FAB BUTTON ===== -->
<button id="chat-fab" onclick="cwToggle()" title="Chat với AI SafeMove">
    <span id="cwFabIcon">💬</span>
    <div id="chat-badge">1</div>
</button>

<!-- ===== POPUP ===== -->
<div id="chat-popup">

    <!-- Header -->
    <div class="cw-header">
        <div class="cw-header-left">
            <div class="cw-avatar">🤖</div>
            <div>
                <div class="cw-title">SafeMove AI</div>
                <div class="cw-subtitle">
                    <div class="cw-dot"></div> Trực tuyến
                </div>
            </div>
        </div>
        <div class="cw-header-right">
            <a href="<%= request.getContextPath() %>/chat/page"
               class="cw-btn" title="Mở trang chat đầy đủ" target="_blank">⛶</a>
            <button class="cw-btn" onclick="cwToggle()" title="Thu nhỏ">✕</button>
        </div>
    </div>

    <!-- Messages -->
    <div class="cw-messages" id="cwMessages">
        <div class="cw-welcome">
            👋 Xin chào! Tôi có thể giúp gì cho bạn về dịch vụ <strong>SafeMove</strong>?
        </div>
    </div>

    <!-- Typing -->
    <div class="cw-typing" id="cwTyping">
        <div class="cw-msg-av" style="background:linear-gradient(135deg,#667eea,#764ba2)">🤖</div>
        <div class="cw-dots"><span></span><span></span><span></span></div>
    </div>

    <!-- Input -->
    <div class="cw-input-area">
        <textarea id="cwInput" placeholder="Nhập câu hỏi..." rows="1"></textarea>
        <button id="cwSend" onclick="cwSend()" title="Gửi">➤</button>
    </div>

</div>

<script>
(function() {
    const CW_CONTEXT = '<%= request.getContextPath() %>';
    const popup    = document.getElementById('chat-popup');
    const fab      = document.getElementById('chat-fab');
    const fabIcon  = document.getElementById('cwFabIcon');
    const badge    = document.getElementById('chat-badge');
    const msgs     = document.getElementById('cwMessages');
    const typing   = document.getElementById('cwTyping');
    const inp      = document.getElementById('cwInput');
    const sendBtn  = document.getElementById('cwSend');

    let isOpen = false;

    /* ===== TOGGLE ===== */
    window.cwToggle = function() {
        isOpen = !isOpen;
        if (isOpen) {
            popup.classList.add('open');
            fabIcon.textContent = '✕';
            badge.classList.remove('show');
            inp.focus();
        } else {
            popup.classList.remove('open');
            fabIcon.textContent = '💬';
        }
    };

    /* ===== AUTO RESIZE ===== */
    inp.addEventListener('input', () => {
        inp.style.height = 'auto';
        inp.style.height = Math.min(inp.scrollHeight, 80) + 'px';
    });

    /* ===== ENTER KEY ===== */
    inp.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            cwSend();
        }
    });

    /* ===== ADD BUBBLE ===== */
    function addMsg(role, text) {
        const div = document.createElement('div');
        div.className = `cw-msg ${role}`;

        const av = document.createElement('div');
        av.className = 'cw-msg-av';
        av.textContent = role === 'user' ? '👤' : '🤖';

        const bubble = document.createElement('div');
        bubble.className = 'cw-bubble';
        bubble.textContent = text;

        div.appendChild(av);
        div.appendChild(bubble);
        msgs.appendChild(div);
        msgs.scrollTop = msgs.scrollHeight;
    }

    /* ===== SEND ===== */
    window.cwSend = async function() {
        const msg = inp.value.trim();
        if (!msg || sendBtn.disabled) return;

        inp.value = '';
        inp.style.height = 'auto';
        sendBtn.disabled = true;

        addMsg('user', msg);

        typing.classList.add('show');
        msgs.scrollTop = msgs.scrollHeight;

        try {
            // URLSearchParams → application/x-www-form-urlencoded
            // (FormData gửi multipart → request.getParameter() không đọc được)
            const params = new URLSearchParams();
            params.append('message', msg);

            const res = await fetch(CW_CONTEXT + '/chat/send', {
                method: 'POST',
                body: params
            });

            // Kiểm tra status trước khi parse JSON
            if (!res.ok) {
                const text = await res.text();
                typing.classList.remove('show');
                addMsg('ai', '❌ Server lỗi (HTTP ' + res.status + '). Hãy Clean & Build lại project.');
                console.error('Server response:', text);
                return;
            }

            let data;
            try {
                data = await res.json();
            } catch (parseErr) {
                typing.classList.remove('show');
                addMsg('ai', '❌ Phản hồi không hợp lệ từ server. Hãy thử lại!');
                return;
            }

            typing.classList.remove('show');
            addMsg('ai', data.error ? '❌ ' + data.error : data.reply);

            // Show badge nếu popup đang đóng
            if (!isOpen) {
                badge.classList.add('show');
                badge.textContent = '1';
            }
        } catch (err) {
            typing.classList.remove('show');
            addMsg('ai', '❌ Lỗi mạng: ' + err.message + '. Kiểm tra server đang chạy không?');
            console.error('Fetch error:', err);
        } finally {
            sendBtn.disabled = false;
            inp.focus();
        }
    };
})();
</script>
