class User{

  String email,userName,password;
  User({required this.password,required this.email,required this.userName});
  toJsonForRegister(){
    return {
      "email":email,
      "username":userName,
      "password1":password,
      "password2":password
    };
  }

  toJsonForLogin(){
    return {
      "email":email,
      "username":userName,
      "password":password
    };
  }
}