<template>
<div>
  <div v-if="!token">
    <h3>log in</h3>
    <div>account: user01@mail.comm</div>
    <div>password: 123</div>
    <br>
    <form>
      email<input type="text" id="email"><br>
      password<input type="password" id="password"><br>
      <button v-on:click="userLogin">submit</button>
    </form>
  </div>

  <div v-if="token">
    <h2>USER DETAIL</h2>
    <h3>token:</h3>
    <p>{{token}}</p>
    <h3>username:</h3>
    <p>{{username}}</p>
    <h3>email:</h3>
    <p>{{email}}</p>
    <h3>created_at:</h3>
    <p>{{created_at}}</p>

    <button v-on:click="userLogout">log out</button>
  </div>

</div>

</template>

<script>

GV_TOKEN=window.localStorage.getItem("token");

module.exports={
  data:function(){
    return {

      token:GV_TOKEN,
      username:"",
      email:"",
      created_at:"",
    }
  },

  methods:{
    userLogout:function(){
      window.localStorage.removeItem("token");
      this.token="";
    },
    set_data_token:function(token){
      this.token=token;
    },
    set_data_user_detail:function(data){
      this.username=data.username;
      this.email=data.email;
      this.created_at=data.created_at;
    },

    userLogin:function(){
      event.preventDefault();
      path="http://localhost:3000/auth/login";

    var GV = this;
      $.ajax({
        
        // url: "/auth/login",
        url:path,
        type: "POST",
        contentType: 'application/json',
        dataType: "json",
        data:JSON.stringify({
          user:{
            "email":$("#email").val(),
            "password":$("#password").val(),
          }
       }),
        success: function(data) {
          console.log("success!!");
          console.log(data);

          window.localStorage.setItem("token", data.token);
          window.localStorage.setItem("email", $("#email").val());
          GV.set_data_token(localStorage.getItem("token"));

        },
        
        error: function(err) {
          console.log("ERROR!!!");
          console.log(err.status);
          console.log(err);
        }
      }).then(function(){
         $.ajax({
          beforeSend: function(request) {
            request.setRequestHeader("Authorization", GV.token);
          },
          
          url: "http://localhost:3000/users",
          type: "GET",
  
          success: function(data) {
            GV.set_data_user_detail(data.user);
            console.log("user detail:");
            
            console.log(data.user);
          },
          
          error: function(err) {
            console.log("err:unable to fetch user detail");
            console.log(err.status);
            console.log(err);
          }
        });
      });
    }
  }
}

  userLogin = function(){

     //需加上這句以避免form進行自動提交
      event.preventDefault();
      
      path="http://localhost:3000/auth/login";

      $.ajax({
        
        // url: "/auth/login",
        url:path,
        type: "POST",
        contentType: 'application/json',
        dataType: "json",
        data:JSON.stringify({
          user:{
            "email":$("#email").val(),
            "password":$("#password").val(),
          }
       }),
        success: function(data) {
          console.log("success!!");
          // console.log(data);

          window.localStorage.setItem("token", data.token);
          window.localStorage.setItem("email", $("#email").val());
          token = window.localStorage.getItem("token");
          
          console.log(token);
        },
        
        error: function(err) {
          console.log("ERROR!!!");
          console.log(err.status);
          console.log(err);
        }
      }).then(function(){
         $.ajax({
          beforeSend: function(request) {
            request.setRequestHeader("Authorization", token);
          },
          
          // url: "http://localhost:3000/users/" + window.localStorage.getItem("email"),
          url: "http://localhost:3000/users",
          type: "GET",
  
          success: function(data) {
            // console.log("user detail:");
            // console.log(data.user);
            console.log("user email:");
            console.log(data.username);
          },
          
          error: function(err) {
            console.log("err:unable to fetch user detail");
            console.log(err.status);
            console.log(err);
          }
        });
      });

  }

</script>
