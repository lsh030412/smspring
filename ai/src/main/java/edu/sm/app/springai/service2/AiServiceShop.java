package edu.sm.app.springai.service2;

import edu.sm.app.dto.Menu;
import edu.sm.app.repository.MenuRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.prompt.ChatOptions;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class AiServiceShop {

  private final ChatClient chatClient;
  private final MenuRepository menuRepository;

  public AiServiceShop(ChatClient.Builder chatClientBuilder, MenuRepository menuRepository) {
    this.chatClient = chatClientBuilder.build();
    this.menuRepository = menuRepository;
  }

  /** 프런트 모달이나 초기 메뉴표 노출용 */
  public List<Menu> getMenus() {
    return menuRepository.findAll();
  }

  /**
   * 사용자 자연어 주문 → DB의 메뉴만을 근거로 '순수 JSON' 주문서 생성
   * {"order_items":[{"menu_name","quantity","price","image_name"}...]}
   */
  public String makeOrderJson(String userOrderText) {
    // 1) DB 메뉴 로드
    List<Menu> menus = this.getMenus();

    // 2) LLM에 전달할 메뉴 문자열 (DB 데이터만)
    String menuBlock = menus.stream()
            .map(m -> "- %s / 가격: %d / 이미지: %s"
                    .formatted(m.getMenuName(), m.getMenuPrice(), m.getMenuImage()))
            .collect(Collectors.joining("\n"));

    // 3) 강한 규칙 프롬프트
    String userPrompt = """
        고객 주문을 주어진 **메뉴판(DB)** 정보만을 바탕으로 '순수 JSON'으로 변환하세요.

        규칙:
        1) 반드시 아래 '메뉴판(DB)' 정보만 사용하여 price, image_name을 매칭하세요.
        2) 응답은 오직 JSON 문자열 하나만. (설명/주석/마크다운 금지)
        3) 전체 구조는 {"order_items":[{menu_name, quantity, price, image_name}...]}.
        4) price는 정수(예: 11000). image_name은 DB의 파일명 그대로.
        5) 사이즈(수육 대/중/소)는 고객 요구에 맞게 DB의 정확한 항목명으로(예: "수육(소)").
        6) 메뉴판(DB)에 없는 메뉴는 제외.
        7) 만약 메뉴명이 모호하면 주문을 확정하지 말고 필요한 추가 질문을 "follow_up" 필드에 한국어로 담아 JSON에 포함해라.
           단, "order_items"는 빈 배열로 유지해라.

        --- 메뉴판(DB) ---
        %s
        --- 끝 ---

        고객 주문: %s
        """.formatted(menuBlock, userOrderText);

    String json = chatClient
            .prompt()
            .system("너는 주문 파서다. 반드시 '순수 JSON'만 출력한다.")
            .user(userPrompt)
            .options(ChatOptions.builder().build())
            .call()
            .content();

    log.info("LLM JSON: {}", json);
    return json;
  }
}
