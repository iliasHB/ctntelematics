
class SendLocationReqEntity {
  final String email;
  final String url;
  final String token;

  SendLocationReqEntity({
    required this.email,
    required this.url,
    required this.token
  });

  Map<String, dynamic> toJson() => {
    email: "email",
    url: "url",
    token: "token",
  };

}