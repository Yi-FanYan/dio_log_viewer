

# dio_log_viewer
[![Pub](https://img.shields.io/pub/v/flutter_shake_animated.svg?style=flat-square)](https://github.com/aiyakuaile/flutter_shake_animated)
[![support](https://img.shields.io/badge/platform-flutter%7Cflutter%20web%7Cdart%20vm-ff69b4.svg?style=flat-square)](https://github.com/aiyakuaile/flutter_shake_animated)

## Features
A dio helper plug-in,captures requests and views them within the application,providing functions such as request replication and JSON expansion

## Preview
![App preview](https://raw.githubusercontent.com/aiyakuaile/dio_log_viewer/main/preview.jpg)

## Getting started

```dart
import 'package:dio_log_viewer/dio_log_viewer.dart';
```

## Usage

1. init dio and add interceptor

```dart
Dio dio = Dio();
...
dio.interceptors.add(DioLogViewerInterceptor());
```
```dart
  // enable: true, default true
  final bool enable;
  // max log count, default 50
  final int maxLogCount;

  DioLogViewerInterceptor({this.enable = true,this.maxLogCount = 50});
```

2. show log drag button to app entry
```dart
DioLogViewer.showLogButton(context);
```

3. Click the Log button and you will see the intercepted request log

4. hidden log button

```dart
DioLogViewer.dismiss()
```

#### Note: By the way, you can also use the following code to get the log data

navigate to the log page `LogViewerListPage()`
```dart
Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                  return const LogViewerListPage();
                }));
```

