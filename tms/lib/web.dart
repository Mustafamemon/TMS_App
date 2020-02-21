import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:url_launcher/url_launcher.dart';

class WebFunctions {
  static PersistCookieJar persistentCookies;
  static final String url = "http://tms-studentportal.herokuapp.com";
  static final Dio _dio = Dio();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localCoookieDirectory async {
    final path = await _localPath;
    print(path);
    final Directory dir = new Directory('$path/cookies');
    await dir.create();
    return dir;
  }
  

  Future<String> _getCsrftoken() async {
    try {
      String csrfTokenValue;
      final Directory dir = await _localCoookieDirectory;
      final cookiePath = dir.path;
      persistentCookies = new PersistCookieJar(dir: '$cookiePath');
      persistentCookies
          .deleteAll(); //clearing any existing cookies for a fresh start
      _dio.interceptors.add(CookieManager(
              persistentCookies) //this sets up _dio to persist cookies throughout subsequent requests
          );

      _dio.options = new BaseOptions(
        baseUrl: url,
        contentType: ContentType.json.toString(),
        responseType: ResponseType.plain,
        connectTimeout: 6000,
        receiveTimeout: 100000,
        headers: {
          HttpHeaders.userAgentHeader: "dio",
          "Connection": "keep-alive",
        },
      ); //BaseOptions will be persisted throughout subsequent requests made with _dio
      _dio.interceptors.add(InterceptorsWrapper(
        onResponse: (Response response) {
          List<Cookie> cookies =
              persistentCookies.loadForRequest(Uri.parse(url));

          csrfTokenValue = cookies
              .firstWhere((c) => c.name == 'csrftoken', orElse: () => null)
              ?.value;

          if (csrfTokenValue != null) {
            _dio.options.headers['X-CSRF-TOKEN'] =
                csrfTokenValue; //setting the csrftoken from the response in the headers

          }
          return response;
        },
      ));

      await _dio.get("/admin_portal/check_if_online");
      return csrfTokenValue;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<String> getSessionId(String rollnum, String password) async {
    try {
      final csrf = await _getCsrftoken();
      print("IN Session: " + csrf);
      FormData formData = new FormData.fromMap({
        "roll_num": rollnum,
        "password": password,
        "csrfmiddlewaretoken": '$csrf'
      });
      Response response =
          await _dio.post("/admin_portal/Student_Login_View", data: formData);
      print(response);

      return response.toString();
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response.toString();
      } else {
        print(e.request);
        print(e.message);
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
    return null;
  }

  Future<String> registerStd(String rollnum, String password,
      String confirmpassword, String firstname, String lastname) async {
    String email = rollnum[2] + rollnum.replaceAll('K', '') + '@nu.edu.pk';
    print(email);
    try {
      final csrf = await _getCsrftoken();
      print("IN Session: " + csrf);
      FormData formData = new FormData.fromMap({
        "roll_num": rollnum,
        "password": password,
        "first_name": firstname,
        "last_name": lastname,
        "email": email,
        "confirm_password": confirmpassword,
        "csrfmiddlewaretoken": '$csrf'
      });
      Response response =
          await _dio.post("/admin_portal/Student_Sign_Up_View", data: formData);
      print(response);
      return response.toString();
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response.toString();
      } else {
        print(e.request);
        print(e.message);
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
    return null;
  }

  static String get urlGetter {
    return url;
  }

  static Dio get dioGetter {
    return _dio;
  }

  static PersistCookieJar get persistGetter {
    return persistentCookies;
  }
}
