// The point below all this thing just for setting api, ty
// Regard Previous Programmer
// Online


  String host = 'https://eventzhee.alamraya.club/';
    // String host = 'http://192.168.100.3/alamraya/myocin/';
  //  String host = 'http://192.168.100.11/bisniskita_myocin/';


  //  String host = 'http://alamraya.club/';
  

  //  String host = 'http://eventzhee.bisniskita.com/';
  // String host = 'http://192.168.137.1/myocin/';
  //  String host = 'http://192.168.43.115/myocin/public/';
   

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
        // print(outp);

	return outp;
}

urlpath(pathname){
  var path = pathname;  
	var outp = host + path;

	return Uri.parse(outp);
}