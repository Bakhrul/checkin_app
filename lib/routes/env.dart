// The point below all this thing just for setting api, ty
// Regard Previous Programmer
  // Online

<<<<<<< HEAD
   String host = 'http://192.168.100.12/alamraya/myocin/';
=======

   String host = 'http://192.168.43.115/bisniskita_myocin/';

  //  String host = 'http://192.168.100.1/order/myocin';
  //  String host = 'http://192.168.43.115/myocin/public/';
>>>>>>> 9e86a6ba04b4de0f419012a59151b31e13b59b9d
   String clientSecret = '0zxvmtgG2PkVw0NfQ0HwxjKYHVbhoaFBZyDlmJEp';



  String clientId = '2';
  String grantType = 'password';

  String appId = '859057';
  String key = "aaf58bdb288796ca641a";
  String secret = "c4ab4e43e9c599c3852d";
  String cluster = "ap1";

url(pathname){
  var path = pathname;  
	var outp = host + path;
        print(outp);

	return outp;
}

urlpath(pathname){
  var path = pathname;  
	var outp = host + path;

	return Uri.parse(outp);
}