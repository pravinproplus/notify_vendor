import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? id;
  String? msg;
  TextEditingController orderid = TextEditingController();
  String? devicetoken;
  String tokens =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImI1ZTc2MmM2NzU2NWRlNWE0OGE2ZDljNjYwOTE0Y2Y4ZWFmYzQ4OGE4MGYxMTE4YzM5ZmMwYzUzOTUxM2Q3ZGZjMDk0ZjA5MmYyZGI4OTlkIn0.eyJhdWQiOiIxIiwianRpIjoiYjVlNzYyYzY3NTY1ZGU1YTQ4YTZkOWM2NjA5MTRjZjhlYWZjNDg4YTgwZjExMThjMzlmYzBjNTM5NTEzZDdkZmMwOTRmMDkyZjJkYjg5OWQiLCJpYXQiOjE2MzIzMDY3NDcsIm5iZiI6MTYzMjMwNjc0NywiZXhwIjoxNjYzODQyNzQ3LCJzdWIiOiIxMjIiLCJzY29wZXMiOltdfQ.ei8jQ1XITw3I5VE_1sZWG4MWM3BhNYFixTEnX6vNUMnIfVZ90cz-lbvn8R5pXMOcePTvSl_tmJdZuOQHRfvtvJn5NEGOhrKGIVbLqYKgbroX9m-0nQUU8NTzkz32zG62fMtkBIdFUMdb22P1JKpPOGgGbyKYb1rNa_g3evVj7Ts3WAt5vR9E1o8Be3doCTJor86bLdZxxzZWZ65E1K-9VJGYZHZYdFc3zR7iiFdaLwRvEY6dFqxElnX3bY_W8HEaL0YRP71M49DpAGZ8ChNJImgauE0h_rbzG4zri-_l5OJqtr0ayl3UlDJTn0p7WevoFKUUKP_wqDkS0lTsoA2_On4Kle5JbR_5hrtZq8NkQiKVutj6wHfUiigS6PFKa8_CYljRZwCPg-2uMdSnD9CE-zt0XzcdTBOrv0fW9bH7AL6AC5JdAhrTqj8yejuTrX42nYYXB85vBG9jkWtBMkWwg0c9MfsJnQcPsJzEkU5wcyBQDb1_l4I8k7ttGAtkt2qYiZoqGCiPka-Apvq5dhEoLElMriBR4wFDnBMgRYabmpsi2tiSRI3QV5lTcNgohtHdKxWBmTk8d6S46Uzqhopo_IQ97-EC-7OANynqAW_RNzoa_Dx3UfwiNQv7yHfwTo8rpKU_6Izv1TuF1K0m6shah6msDahfsBncnkvzZJNcgnk';
  String url =
      'https://propluslogics.in/onefarmer_test_api/api/order_status_update';
  String? serverKey =
      'AAAA3-SQPvo:APA91bEEIeIaFAgnLC4l95XugzR-eGT1-Q2yQEEm2d39yQuOOmjD94k9PD7tYmEQ4F7yeZ1XI55yGtYdKp5nly4oJoFn7oN0Rp09feZMJ5KBF5-dfgs5BOxuE-EWX-utHU_Tlsijvl9P';

  Future<void> sendAndRetrieveMessage(String token, String content) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'click to more information',
            'title': content,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
  }

  toast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future getToken(int status, String id) async {
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $tokens',
          },
          body: json.encode({
            "status": status,
            "order_id": id,
          }));
      var jsondata = json.decode(response.body);

      setState(() {
        devicetoken = jsondata['token'];
        msg = jsondata['data'];
      });
      if (status == 2) {
        sendAndRetrieveMessage(devicetoken!, 'hi john');
        toast(msg!);
      } else if (status == 7) {
        sendAndRetrieveMessage(devicetoken!, 'denied john');
        toast(msg!);
      }
      // ignore: avoid_print
      print(jsondata['token']);
    } catch (e) {
      toast(msg!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 250.0,
          width: 200.0,
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Order id'),
                  ),
                  controller: orderid),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      id = orderid.text;
                    });
                  },
                  child: const Text('Enter')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      getToken(2, id!);
                    });
                  },
                  child: const Text('booking accept')),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      getToken(7, id!);
                    });
                  },
                  child: const Text('booking denied')),
            ],
          ),
        ),
      ),
    );
  }
}
