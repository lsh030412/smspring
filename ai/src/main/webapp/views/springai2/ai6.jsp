<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  let ai6 = {
    init() {
      $('#send').click(() => this.send());
      $('#spinner').css('visibility','hidden');
      this.loadMenu();
    },

    async loadMenu() {
      try {
        const res = await fetch('/ai2/ai6-menu');
        const menus = await res.json();
        const byCat = {10:[], 20:[], 30:[]};

        menus.forEach(m => {
          if (!byCat[m.categoryId]) byCat[m.categoryId] = [];
          byCat[m.categoryId].push(m);
        });

        const li = (m) => `<li>${m.menuName} - ${m.menuPrice.toLocaleString()}원 <img src="/image/${m.menuImage}" style="width:50px;"></li>`;

        $('#menu-gukbab').html((byCat[10]||[]).map(li).join(''));
        $('#menu-side').html((byCat[20]||[]).map(li).join(''));
        $('#menu-drink').html((byCat[30]||[]).map(li).join(''));
      } catch (e) {
        console.error(e);
      }
    },

    async send() {
      $('#spinner').css('visibility','visible');

      const question = $('#question').val();
      const qForm = `
        <div class="media border p-3">
          <img src="/image/user.png" alt="User" class="mr-3 mt-3 rounded-circle" style="width:60px;">
          <div class="media-body">
            <h6>고객</h6>
            <p>${this.escape(question)}</p>
          </div>
        </div>`;
      $('#result').prepend(qForm);

      const response = await fetch('/ai2/ai6-order', {
        method: "post",
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: new URLSearchParams({ question })
      });

      const uuid = this.makeUi("result");
      const jsonString = await response.text();
      console.log("서버 응답:", jsonString);

      try {
        const obj = JSON.parse(jsonString);

        // 최소 변경: 루트에 있는 order_items, unavailable, follow_up만 사용
        const items = Array.isArray(obj.order_items) ? obj.order_items : [];
        const unavailable = Array.isArray(obj.unavailable) ? obj.unavailable : [];
        const followUp = obj.follow_up || "";

        let html = "", total = 0;

        // 없는 메뉴 경고 (추가)
        if (unavailable.length > 0) {
          html += `
            <div class="alert alert-danger mt-2">
              <strong>주문 불가:</strong> ${unavailable.map(this.escape).join(', ')}
            </div>`;
        }

        // 사이즈 미지정 등 추가 질문 (추가)
        if (followUp) {
          html += `
            <div class="alert alert-warning mt-2">
              <strong>추가 확인:</strong> ${this.escape(followUp)}
            </div>`;
        }

        // 확정된 주문 아이템 카드/합계 (기존 유지)
        items.forEach(it => {
          const price = Number(it.price ?? 0);
          const qty = Number(it.quantity ?? 0);
          const itemTotal = price * qty;
          total += itemTotal;

          html += `
            <div class="card mb-2 shadow-sm">
              <div class="row no-gutters align-items-center">
                <div class="col-md-3 text-center">
                  <img src="/image/${this.escape(it.image_name)}" class="img-fluid p-2" style="max-height:100px;">
                </div>
                <div class="col-md-9">
                  <div class="card-body py-2">
                    <h5 class="card-title mb-1">${this.escape(it.menu_name)}</h5>
                    <p class="mb-0">수량: ${qty}개</p>
                    <p class="mb-0">단가: ${price.toLocaleString()}원</p>
                    <p class="font-weight-bold">합계: ${itemTotal.toLocaleString()}원</p>
                  </div>
                </div>
              </div>
            </div>`;
        });

        html += `<hr><h5>총합: ${total.toLocaleString()}원</h5>`;
        $('#'+uuid).html(html);
      } catch (e) {
        console.error("JSON 파싱 실패:", e, jsonString);
        $('#'+uuid).html('<span style="color:red;">JSON 파싱 실패. 원문: '+this.escape(jsonString)+'</span>');
      }

      $('#spinner').css('visibility','hidden');
    },

    makeUi(target) {
      const uuid = "id-" + crypto.randomUUID();
      const aForm = `
        <div class="media border p-3">
          <div class="media-body">
            <h6>GPT</h6>
            <div id="${uuid}"></div>
          </div>
          <img src="/image/assistant.png" alt="GPT" class="ml-3 mt-3 rounded-circle" style="width:60px;">
        </div>`;
      $('#'+target).prepend(aForm);
      return uuid;
    },

    // 간단 이스케이프
    escape(s) {
      return String(s ?? '')
              .replace(/&/g,'&amp;')
              .replace(/</g,'&lt;')
              .replace(/>/g,'&gt;')
              .replace(/"/g,'&quot;')
              .replace(/'/g,'&#39;');
    }
  };

  $(()=> ai6.init());
</script>



<div class="col-sm-10">
  <h2>AI6 – DB 메뉴 기반 주문</h2>
  <div class="row mb-2">
    <div class="col-sm-6">
      <textarea id="question" class="form-control">돼지국밥 2개랑 수육 소짜 하나, 그리고 사이다 3개 주세요.</textarea>
    </div>
    <div class="col-sm-2">
      <button type="button" class="btn btn-primary" id="send">Send</button>
    </div>
    <div class="col-sm-2">
      <button class="btn btn-info" data-toggle="modal" data-target="#menuModal">메뉴판 보기</button>
    </div>
    <div class="col-sm-2">
      <button class="btn btn-primary" disabled>
        <span class="spinner-border spinner-border-sm" id="spinner"></span>
        Loading..
      </button>
    </div>
  </div>

  <div id="result" class="container p-3 my-3 border" style="overflow:auto; height:500px;"></div>
</div>

<div class="modal fade" id="menuModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">메뉴판 (DB)</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <h6>[국밥]</h6><ul id="menu-gukbab"></ul>
        <h6>[사이드]</h6><ul id="menu-side"></ul>
        <h6>[음료]</h6><ul id="menu-drink"></ul>
      </div>
    </div>
  </div>
</div>
