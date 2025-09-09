<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
  let custDetail = {
    init:function(){
      $('#cust_update_form > #update_btn').click(()=>{
        let c = confirm("수정 하시겠습니까 ?");
        if(c == true){
          $('#cust_update_form').attr("method", "post");
          $('#cust_update_form').attr("action", "/cust/updateimpl");
          $('#cust_update_form').submit();
        }
      });
      $('#cust_update_form > #delete_btn').click(()=>{
        let c = confirm("삭제 하시겠습니까 ?");
        if(c == true){
          let id = $('#id').val();
          location.href='/cust/delete?id='+id;
        }
      });
    }
  }
  $().ready(()=>{
    custDetail.init();
  });
</script>



<%-- Login Page --%>
<div class="col-sm-9">
  <h2>Cust Detail Page</h2>
  <form id="cust_update_form">
    <div class="form-group">
      <label for="id">Id:</label>
      <input type="text" readonly value="${cust.custId}" class="form-control" placeholder="Enter id" id="id" name="custId">
    </div>
    <div class="form-group">
      <label for="pwd">Password:</label>
      <input type="password" readonly value="${cust.custPwd}" class="form-control" placeholder="Enter password" id="pwd" name="custPwd">
    </div>
    <div class="form-group">
      <label for="pwd">Name:</label>
      <input type="text" class="form-control" value="${cust.custName}"placeholder="Enter name" id="name" name="custName">
    </div>
    <button type="button" class="btn btn-primary" id="update_btn">Update</button>
    <button type="button" class="btn btn-primary" id="delete_btn">Delete</button>
  </form>
</div>