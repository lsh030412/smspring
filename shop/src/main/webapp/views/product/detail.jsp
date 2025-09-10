<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
  #productimg{
    height: 400px;
    width: 300px;
  }
</style>
<script>
  let productDetail = {
    init:function(){
      $('#product_update_form > #update_btn').click(()=>{
        let c = confirm("수정 하시겠습니까 ?");
        if(c == true){
          $('#product_update_form').attr("method", "post");
          $('#product_update_form').attr("action", "/product/updateimpl");
          $('#product_update_form').attr("enctype", "multipart/form-data");
          $('#product_update_form').submit();
        }
      });
      $('#delete_btn').click(()=>{
        let c = confirm('삭제 하시겠습니까 ?');
        if(c == true){
          location.href='/product/delete?id=${p.productId}';
        }
      });
    }
  }
  $().ready(()=>{
    productDetail.init();
  });
</script>



<%-- Login Page --%>
<div class="col-sm-9">
  <h2>product Detail Page</h2>
  <form id="product_update_form">
    <div class="form-group">
      <img id="productimg" src="<c:url value="/imgs/${p.productImg}"/>">
    </div>
    <div class="form-group">
      <label for="id">Id:</label>
      <input type="text" readonly value="${p.productId}" class="form-control" placeholder="Enter id" id="id" name="productId">
    </div>
    <div class="form-group">
      <label for="name">Name:</label>
      <input type="text" class="form-control" value="${p.productName}"placeholder="Enter name" id="name" name="productName">
    </div>
    <div class="form-group">
      <label for="price">Price:</label>
      <input type="number" class="form-control" value="${p.productPrice}" id="price" name="productPrice">
    </div>
    <div class="form-group">
      <label for="rate">Discount Rate:</label>
      <input type="text" class="form-control" value="${p.discountRate}" id="rate" name="discountRate">
    </div>
    <%--기존의 이미지 --%>
    <input type="hidden" value="${p.productImg}" name="productImg">
    <%--새로운 이미지를 선택하면 새로운 파일에 대한 이미지로 데이터를 수정해야한다.--%>
    <div class="form-group">
      <label for="newpimg">New Product Image:</label>
      <input type="file" class="form-control" id="newpimg" name="productImgFile">
    </div>
    <div class="form-group">
      <label for="cate">Cate Id:</label>
      <input type="number" class="form-control"  value="${p.cateId}" id="cate" name="cateId">
    </div>
    <div class="form-group">
      <label for="rdate">Register Date:</label>
      <p id="rdate">
        <fmt:parseDate value="${ p.productRegdate }"
                       pattern="yyyy-MM-dd HH:mm:ss" var="parsedDateTime" type="both" />
        <fmt:formatDate pattern="yyyy년MM월dd일 HH시mm분ss시" value="${ parsedDateTime }" /></p>
    </div>
    <div class="form-group">
      <label for="udate">Update Date:</label>
      <p id="udate">
        <fmt:parseDate value="${ p.productUpdate }"
                       pattern="yyyy-MM-dd HH:mm:ss" var="parsedDateTime" type="both" />
        <fmt:formatDate pattern="yyyy년MM월dd일 HH시mm분ss시" value="${ parsedDateTime }" />
      </p>
    </div>
    <button type="button" class="btn btn-primary" id="update_btn">Update</button>
    <button type="button" class="btn btn-primary" id="delete_btn">Delete</button>
  </form>
</div>