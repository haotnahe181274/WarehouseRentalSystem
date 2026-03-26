<%@ page contentType="text/html;charset=UTF-8" %>
<%
    model.UserView user = (model.UserView) session.getAttribute("user");
    String role = null;
    if (user != null) {
        role = user.getRole();
    }
%>

<% if (user != null) { %>
    <!-- SUPPORT CHAT BUTTON -->
    <div id="supportBtn" onclick="toggleSupport()">💬</div>

    <div id="supportPopup">
        <div id="supportHeader">
            Hỗ trợ
            <span style="float:right; cursor:pointer;" onclick="toggleSupport()">✖</span>
        </div>
        <iframe id="supportFrame"></iframe>
    </div>

    <script>
        function toggleSupport() {
            var popup = document.getElementById("supportPopup");
            var frame = document.getElementById("supportFrame");

            if (popup.style.display === "none" || popup.style.display === "") {
                if (!frame.src) {
                    <% if ("RENTER".equals(role)) { %>
                        frame.src = "<%=request.getContextPath()%>/support";
                    <% } else { %>
                        frame.src = "<%=request.getContextPath()%>/send-support-message";
                    <% } %>
                }
                popup.style.display = "block";
            } else {
                popup.style.display = "none";
            }
        }
    </script>

    
    <style>
        #supportBtn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            background: #0d6efd;
            color: white;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 26px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 999;
        }
        #supportPopup {
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 380px;
            max-width: 90%;
            height: 520px;
            max-height: 80%;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
            display: none;
            overflow: hidden;
            z-index: 999;
        }
        #supportHeader {
            background: #0d6efd;
            color: white;
            padding: 10px;
            font-weight: bold;
        }
        #supportFrame {
            width: 100%;
            height: calc(100% - 40px);
            border: none;
        }
    </style>
    <script>
     window.onload = function() {
    const urlParams = new URLSearchParams(window.location.search);
    const openChat = urlParams.get('openChat');
    const conversationId = urlParams.get('conversationId');

    if (openChat === 'true') {
        // Nếu có conversationId, ta cập nhật lại source của iframe trước khi mở
        if (conversationId) {
            var frame = document.getElementById("supportFrame");
            var contextPath = "<%=request.getContextPath()%>";
            
            // Ép link iframe vào thẳng nội dung tin nhắn đó
            frame.src = contextPath + "/send-support-message?conversationId=" + conversationId;
        }
        
        // Gọi hàm mở popup
        toggleSupport();
    }
};

function toggleSupport() {
    var popup = document.getElementById("supportPopup");
    var frame = document.getElementById("supportFrame");

    if (popup.style.display === "none" || popup.style.display === "") {
        // Nếu chưa có src (trường hợp click tay bình thường) thì mới set mặc định
        if (!frame.src) {
            <% if ("RENTER".equals(role)) { %>
                frame.src = "<%=request.getContextPath()%>/support";
            <% } else { %>
                frame.src = "<%=request.getContextPath()%>/send-support-message";
            <% } %>
        }
        popup.style.display = "block";
    } else {
        popup.style.display = "none";
    }
}
    </script>
 } %>