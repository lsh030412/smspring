package edu.sm.app.springai.service4;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.PromptChatMemoryAdvisor;
import org.springframework.ai.chat.client.advisor.SimpleLoggerAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.core.Ordered;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

@Service
@Slf4j
public class AiChatService {
  // ##### 필드 ##### 
  private ChatClient chatClient;
  
  // ##### 생성자 #####
  public AiChatService(
      ChatMemory chatMemory, 
      ChatClient.Builder chatClientBuilder) {   
      this.chatClient = chatClientBuilder
          .defaultAdvisors(
              //MessageChatMemoryAdvisor.builder(chatMemory).build(),
              PromptChatMemoryAdvisor.builder(chatMemory).build(),
              new SimpleLoggerAdvisor(Ordered.LOWEST_PRECEDENCE-1)
          )
          .build();
  }
  
  
  // ##### 메소드 #####
  // 사용자 질문, 사용자의 브라우저의 세션 정보
  // 이 aiservice는 여러명이 동시 접속할 수 있으니 각각 세션 정보를 기억하고 있다가 그거에 맞는 답변을 해준다.
//   로그인한 사용자의 아이디로 지정할 수 있다. 그 사람과의 대화 내용을 계속해서 저장하고 있다.
//    이런 형태로 서로 llm에 대화할때 이런 형식으로 저장 가능
//    ai2의 rag에서도 사용할수 있다.
  public Flux<String> chat(String userText, String conversationId) {
//    String answer = chatClient.prompt()
//      .user(userText)
//      .advisors(advisorSpec -> advisorSpec.param(
//        ChatMemory.CONVERSATION_ID, conversationId
//      ))
//      .call()
//      .content();
    Flux<String> answer = chatClient.prompt()
            .user(userText)
            .advisors(advisorSpec -> advisorSpec.param(
                    ChatMemory.CONVERSATION_ID, conversationId
            ))
            .stream()
            .content();
    return answer;
//
  }
}
