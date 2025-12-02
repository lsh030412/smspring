package edu.sm.controller;

import edu.sm.app.springai.service1.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import reactor.core.publisher.Flux;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


@RestController
@RequestMapping("/ai1")
@Slf4j
@RequiredArgsConstructor
public class Ai1Controller {
    final AiServiceByChatClient aiServiceByChatClient;
    final AiServiceChainOfThoughtPrompt aiServiceChainOfThoughtPrompt;
    final AiServiceFewShotPrompt aiServiceFewShotPrompt;
    final AiServiceFewShotPrompt2 aiServiceFewShotPrompt2;
    final AiServicePromptTemplate  aiServicePromptTemplate;
    final AiServiceStepBackPrompt aiServiceStepBackPrompt;
    final RestTemplate restTemplate = new RestTemplate();

    @RequestMapping("/chat-model")
    public String chatModel(@RequestParam("question") String question) {
        return aiServiceByChatClient.generateText(question);
    }
    @RequestMapping("/few-shot-prompt")
    public String fewShotPrompt(@RequestParam("question") String question) {
        return aiServiceFewShotPrompt.fewShotPrompt(question);
    }
    @RequestMapping("/chat-model-stream")
    public Flux<String> chatModelStream(@RequestParam("question") String question) {
        return aiServiceByChatClient.generateStreamText(question);
    }
    @RequestMapping("/chat-of-thought")
    public Flux<String> chatOfThought(@RequestParam("question") String question) {
        return aiServiceChainOfThoughtPrompt.chainOfThought(question);
    }
    @RequestMapping(value = "/prompt-template")
    public Flux<String> promptTemplate(      @RequestParam("question") String question,
                                             @RequestParam("language") String language) {
        Flux<String> response = aiServicePromptTemplate.promptTemplate3(question, language);
        return response;
    }
    @RequestMapping(value = "/role-assignment")
    public Flux<String> roleAssignment(@RequestParam("question") String question) {
        return aiServicePromptTemplate.roleAssignment(question);
    }
    @PostMapping(value = "/step-back-prompt")
    public String stepBackPrompt(@RequestParam("question") String question) throws Exception {
        String answer = aiServiceStepBackPrompt.stepBackPrompt(question);
        return answer;
    }

}
