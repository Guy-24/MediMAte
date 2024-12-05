import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "";
  
  static addproduct(Map data) async {
    try { 
      final res = await http.post(Uri.parse("uri"), body: data);

      if(res.statusCode == 200){

      }else{

      }
    } catch (error) {
      print("Connecting failed:");
      print(error.toString());
    }
  }
}