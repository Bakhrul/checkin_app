// The point below all this thing just for setting api, ty
// Regard Previous Programmer
  // Online
   String host = 'http://192.168.100.17/';



  String clientId = '2';
  String grantType = 'password';

  String appId = '859057';
  String key = "aaf58bdb288796ca641a";
  String secret = "c4ab4e43e9c599c3852d";
  String cluster = "ap1";

url(pathname){
  var path = pathname;  
	var outp = host + path;

	return outp;
}

urlpath(pathname){
  var path = pathname;  
	var outp = host + path;

	return Uri.parse(outp);
}