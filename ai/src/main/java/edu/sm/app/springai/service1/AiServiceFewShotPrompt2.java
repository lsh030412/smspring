package edu.sm.app.springai.service1;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.prompt.ChatOptions;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class AiServiceFewShotPrompt2 {
  // ##### 필드 #####
  private ChatClient chatClient;

  // ##### 생성자 #####
  public AiServiceFewShotPrompt2(ChatClient.Builder chatClientBuilder) {
    chatClient = chatClientBuilder.build();
  }

  // ##### 메소드 #####
  public String fewShotPrompt2(String order) {
    // 프롬프트 생성
    String strPrompt = """
        고객 주문을 주어진 메뉴판 정보를 바탕으로 유효한 JSON 형식으로 바꿔주세요.
        아래 규칙을 반드시 지켜주세요:
        1. 반드시 아래 제공된 '메뉴판' 정보만을 사용하여 각 항목의 'price'와 'image_name'을 찾아야 합니다.
        2. 전체 주문은 'order_items' 배열 안에 각 메뉴를 객체로 포함해야 합니다.
        3. 각 메뉴 객체는 'menu_name'(메뉴이름), 'quantity'(수량), 'price'(가격), 'image_name'(이미지 파일명)을 필수로 포함해야 합니다.
        4. 가격은 '11,000원'이 아닌 숫자 `11000` 형식으로 입력해야 합니다.
        5. '수육'과 같이 사이즈가 있는 메뉴는 고객이 '대', '중', '소'를 언급했을 때 메뉴판에서 정확한 항목을 찾아야 합니다. (예: '수육(대)')
        6. 메뉴판에 없는 메뉴는 주문에 포함시키지 마세요.
        7. 추가 설명, 주석, 그리고 ```json 같은 마크다운 형식 없이 순수한 JSON 문자열로만 응답해야 합니다.

        --- 메뉴판 ---
        [국밥]
        - 소머리국밥 / 가격: 11000 / 이미지: k1.jpg
        - 돼지국밥 / 가격: 9000 / 이미지: k2.jpg
        - 순대국밥 / 가격: 9000 / 이미지: k3.jpg
        - 내장국밥 / 가격: 10000 / 이미지: k4.jpg
        - 얼큰이국밥 / 가격: 9500 / 이미지: k5.jpg
        - 설렁탕국밥 / 가격: 10000 / 이미지: k6.jpg
        - 뼈해장국 / 가격: 10000 / 이미지: k7.jpg
        - 김치말이국밥 / 가격: 9000 / 이미지: k8.jpg

        [사이드]
        - 순대 / 가격: 12000 / 이미지: k9.jpg
        - 수육(대) / 가격: 20000 / 이미지: k10.jpg
        - 수육(중) / 가격: 18000 / 이미지: k11.jpg
        - 수육(소) / 가격: 15000 / 이미지: k12.jpg
        - 머리고기 / 가격: 22000 / 이미지: k13.jpg
        - 편육 / 가격: 10000 / 이미지: k14.jpg
        
        [음료]
        - 콜라 / 가격: 2000 / 이미지: k15.jpg
        - 사이다 / 가격: 2000 / 이미지: k16.jpg
        - 아이스티 / 가격: 3000 / 이미지: k17.jpg
        - 식혜 / 가격: 3000 / 이미지: k18.jpg
        - 수정과 / 가격: 3000 / 이미지: k19.jpg
        --- 메뉴판 끝 ---

        예시1:
        순대국밥 하나랑 콜라 하나요.
        JSON 응답:
        {
          "order_items": [
            {
              "menu_name": "순대국밥",
              "quantity": 1,
              "price": 9000,
              "image_name": "k3.jpg"
            },
            {
              "menu_name": "콜라",
              "quantity": 1,
              "price": 2000,
              "image_name": "k15.jpg"
            }
          ]
        }

        예시2:
        돼지국밥 2개랑 수육 소짜 하나, 그리고 사이다 3개 주세요.
        JSON 응답:
        {
          "order_items": [
            {
              "menu_name": "돼지국밥",
              "quantity": 2,
              "price": 9000,
              "image_name": "k2.jpg"
            },
            {
              "menu_name": "수육(소)",
              "quantity": 1,
              "price": 15000,
              "image_name": "k12.jpg"
            },
            {
              "menu_name": "사이다",
              "quantity": 3,
              "price": 2000,
              "image_name": "k16.jpg"
            }
          ]
        }

        고객 주문: %s""".formatted(order);

    Prompt prompt = Prompt.builder()
            .content(strPrompt)
            .build();

    // LLM으로 요청하고 응답을 받음
    String pizzaOrderJson = chatClient.prompt(prompt)
            .options(ChatOptions.builder()
                    .build())
            .call()
            .content();
    log.info(pizzaOrderJson);
    return pizzaOrderJson;
  }
}
