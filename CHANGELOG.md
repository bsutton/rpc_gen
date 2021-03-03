## 0.1.3

- Added the ability to use `named method parameters`, which allows in most cases not to declare the data type specifically for the purpose of sending complex data from the client to the server
- Added the ability to specify that the value of the method parameter should not be sent if its value is `null` (can be used when sending `http` requests using the `GET` method, because unspecified values will not be included in the `query parameters`)
- Added the ability to specify a method parameter `alias` (key name)

## 0.1.2

- Minor source code improvements

## 0.1.1

- Minor modification of `example.dart` and `README.md` files
- For full JSON compatibility, all generated methods accept and return strongly typed `Map<String, dynamic>` values

## 0.1.0

- Initial release
