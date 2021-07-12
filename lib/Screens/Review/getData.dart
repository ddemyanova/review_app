import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:review_app/Models/ProductsData.dart';
import 'package:review_app/Models/ReviewData.dart';
import '../../constants.dart';

Future<List<Review>> getReviews(Product product) async {

  var response = await http.get(
      Uri.parse(URL + "reviews/"+ product.Id.toString())
  );
  if (response.statusCode == 200)
  {
    List<dynamic> body = jsonDecode(response.body);
    List<Review> reviews = body.map((dynamic item) => Review.fromJson(item),).toList();
    reviews.sort((a, b) => b.Id.compareTo(a.Id));

    return reviews;
  }
  else
  {
    throw "Unable to read products.";
  }
}

