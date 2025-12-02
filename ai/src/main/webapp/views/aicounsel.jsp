<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>AI 고객센터</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { font-family: '맑은 고딕'; margin: 30px; }
        #chat-box { border: 1px solid #ccc; padding: 10px; width: 500px; height: 400px; overflow-y: scroll; }
        .user { text-align: right; color: blue; margin: 5px; }
        .ai { text-align: left; color: green; margin: 5px; }
    </style>
</head>
<body>
<h3>🧠 AI 고객센터</h3>
<div id="chat-box"></div>

<div style="margin-top:10px;">
    <input type="text" id="question" style="width:400px;" placeholder="궁금한 점을 입력하세요..." />
    <button id="send">전송</button>
</div>

<script>
    $(function() {
        $('#send').click(async function() {
            const msg = $('#question').val().trim();
            if (msg === '') return;

            $('#chat-box').append('<div class="user">🙋‍♂️ 나: ' + msg + '</div>');
            $('#question').val('');

            const response = await fetch('/ai11/chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'question=' + encodeURIComponent(msg) + '&userId=user001'
            });

            const answer = await response.text();
            $('#chat-box').append('<div class="ai">🤖 AI: ' + answer + '</div>');
            $('#chat-box').scrollTop($('#chat-box')[0].scrollHeight);
        });
    });
</script>
</body>
</html>
