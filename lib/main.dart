import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:photos_personalized_gemini/components/photo_gemini.dart';
import 'package:photos_personalized_gemini/photos_library_api/album.dart';
import 'package:photos_personalized_gemini/photos_library_api/photos_library_api_client.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider:
        ReCaptchaV3Provider(const String.fromEnvironment("RECAPTCHA_SITE_KEY")),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos Personalized Gemini Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Photos Personalized Gemini Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignInPlugin? _plugin;

  PhotosLibraryApiClient? _client;
  List<Album> _albums = [];

  @override
  void initState() {
    super.initState();
    initGoogleSignInPlugin();
  }

  void initGoogleSignInPlugin() async {
    _plugin = GoogleSignInPlugin();
    await _plugin?.init();
    _plugin?.userDataEvents?.listen((userData) async {
      if (userData == null) {
        return;
      }

      final authorized = await _plugin?.requestScopes([
        'https://www.googleapis.com/auth/photoslibrary.readonly',
      ]);
      if (userData.idToken != null && authorized!) {
        final signInTokenData = await _plugin?.getTokens(email: userData.email);
        _client = PhotosLibraryApiClient({
          "Authorization": "Bearer ${signInTokenData?.accessToken}",
          "Content-type": "application/json",
        });
        final res = await _client!.listAlbums();
        setState(() {
          _albums = res.albums?.map((e) => e!).toList() ?? [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        transformAlignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 5 * 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container()),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'コンテキスト情報として使いたい Google Photo のアカウントでログイン:',
                ),
              ),
              _plugin!.renderButton(),
              (_client == null)
                  ? Container()
                  : PhotoGemini(client: _client!, albums: _albums),
            ],
          ),
        ),
      ),
    );
  }
}
