<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Floating Chatbot Launcher Button -->
<button class="chatbot-toggler shadow-lg" id="chatbotToggler" aria-label="Open AI Assistant" title="Chat with SmartShop AI">
    <i class="bi bi-chat-dots-fill"></i>
</button>

<!-- Chatbot Popup Container -->
<div class="chatbot-container" id="chatbotContainer">
    <!-- Chatbot Header -->
    <div class="chatbot-header">
        <div class="d-flex align-items-center gap-2">
            <div class="rounded-circle bg-white text-primary p-2 d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                <i class="bi bi-robot fs-6"></i>
            </div>
            <div>
                <h6 class="mb-0 text-white fw-bold">SmartShop AI Assistant</h6>
                <small class="text-white-50" style="font-size: 0.75rem;">Online &bull; Instant Answers</small>
            </div>
        </div>
        <button type="button" class="btn btn-sm text-white border-0" id="closeChatbot" aria-label="Close">
            <i class="bi bi-x-lg fs-6"></i>
        </button>
    </div>

    <!-- Chat Messages Body -->
    <div class="chatbot-body" id="chatMessages">
        <div class="chat-message bot">
            Hello! 👋 I'm your SmartShop automated AI assistant. How can I help you today?
        </div>
        <div class="quick-replies-container d-flex flex-wrap mt-1">
            <button type="button" class="quick-reply-chip" onclick="document.getElementById('chatInput').value='Where is my order?'; document.getElementById('chatForm').dispatchEvent(new Event('submit'));">Where is my order?</button>
            <button type="button" class="quick-reply-chip" onclick="document.getElementById('chatInput').value='Recommend products'; document.getElementById('chatForm').dispatchEvent(new Event('submit'));">Recommend products</button>
            <button type="button" class="quick-reply-chip" onclick="document.getElementById('chatInput').value='Return policy'; document.getElementById('chatForm').dispatchEvent(new Event('submit'));">Return policy</button>
            <button type="button" class="quick-reply-chip" onclick="document.getElementById('chatInput').value='Payment methods'; document.getElementById('chatForm').dispatchEvent(new Event('submit'));">Payment methods</button>
        </div>
    </div>

    <!-- Chat Input Form -->
    <div class="chatbot-footer">
        <form id="chatForm" class="d-flex gap-2">
            <input type="text" id="chatInput" class="form-control form-control-sm rounded-pill px-3" 
                   placeholder="Ask about orders, products, returns..." autocomplete="off" required>
            <button type="submit" class="btn btn-primary btn-sm rounded-circle d-flex align-items-center justify-content-center" style="width: 34px; height: 34px;">
                <i class="bi bi-send-fill fs-6"></i>
            </button>
        </form>
    </div>
</div>
