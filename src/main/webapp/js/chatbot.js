/**
 * SmartShop AI Chatbot Widget Interaction
 */
document.addEventListener('DOMContentLoaded', () => {
    const chatbotToggler = document.getElementById('chatbotToggler');
    const chatbotContainer = document.getElementById('chatbotContainer');
    const closeChatbotBtn = document.getElementById('closeChatbot');
    const chatForm = document.getElementById('chatForm');
    const chatInput = document.getElementById('chatInput');
    const chatMessages = document.getElementById('chatMessages');
    const contextPath = window.APP_CONTEXT_PATH || '';

    if (!chatbotToggler || !chatbotContainer) return;

    // Toggle Chatbot
    chatbotToggler.addEventListener('click', () => {
        chatbotContainer.classList.toggle('active');
        if (chatbotContainer.classList.contains('active')) {
            chatInput.focus();
            scrollToBottom();
        }
    });

    closeChatbotBtn.addEventListener('click', () => {
        chatbotContainer.classList.remove('active');
    });

    // Handle Form Submit
    chatForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const text = chatInput.value.trim();
        if (!text) return;

        appendMessage(text, 'user');
        chatInput.value = '';

        showTypingIndicator();

        // Call backend API
        fetch(`${contextPath}/api/chatbot`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message: text })
        })
        .then(res => res.json())
        .then(data => {
            removeTypingIndicator();
            appendMessage(data.reply, 'bot', data.quickReplies);
        })
        .catch(err => {
            console.error('Chatbot error:', err);
            removeTypingIndicator();
            appendMessage("Sorry, I'm having trouble connecting right now. Please try again shortly.", 'bot');
        });
    });

    function appendMessage(content, sender, quickReplies = []) {
        const msgDiv = document.createElement('div');
        msgDiv.className = `chat-message ${sender}`;
        msgDiv.innerHTML = content;
        chatMessages.appendChild(msgDiv);

        if (quickReplies && quickReplies.length > 0) {
            const chipsContainer = document.createElement('div');
            chipsContainer.className = 'quick-replies-container mt-1 d-flex flex-wrap';
            quickReplies.forEach(chipText => {
                const chip = document.createElement('button');
                chip.type = 'button';
                chip.className = 'quick-reply-chip';
                chip.innerText = chipText;
                chip.addEventListener('click', () => {
                    chatInput.value = chipText;
                    chatForm.dispatchEvent(new Event('submit'));
                });
                chipsContainer.appendChild(chip);
            });
            chatMessages.appendChild(chipsContainer);
        }

        scrollToBottom();
    }

    function showTypingIndicator() {
        const typingDiv = document.createElement('div');
        typingDiv.id = 'chatbotTypingIndicator';
        typingDiv.className = 'chat-message bot text-muted fst-italic';
        typingDiv.innerHTML = '<span class="spinner-grow spinner-grow-sm me-1" role="status"></span> Thinking...';
        chatMessages.appendChild(typingDiv);
        scrollToBottom();
    }

    function removeTypingIndicator() {
        const ind = document.getElementById('chatbotTypingIndicator');
        if (ind) ind.remove();
    }

    function scrollToBottom() {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
});
