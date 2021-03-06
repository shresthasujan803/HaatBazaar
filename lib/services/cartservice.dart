import 'package:firebase_auth/firebase_auth.dart';
import 'package:haatbazaar/Screens/conform_order.dart';
import 'package:haatbazaar/model/cartitemmodel.dart';
import 'package:haatbazaar/model/ordermodel.dart';
import 'package:haatbazaar/model/productmodel.dart';
import 'package:haatbazaar/model/usermodel.dart';
import 'package:haatbazaar/services/userservices.dart';
import 'package:uuid/uuid.dart';

class CartService {
  UserModel _userModel; //it is a vip object
  UserModel get userModel => _userModel;

  // public variables
  List<OrderModel> orders = [];
  UserInfoService _userInfoService = UserInfoService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String getUserId() {
    final User user = auth.currentUser;
    final uid = user.uid;
    return uid;
  }

  Future<bool> addToCart({ProductModel product, double quantity}) async {
    var uuid = Uuid();
    String cartItemId = uuid.v4(); //creating cart id
    Map cartItem = {
      "cartID": cartItemId,
      "name": product.productName,
      "imageURL": product.imageURL,
      "id": product.id,
      "price": product.getPrice,
      // "quantities": product.quantity,
      "quantity": quantity,
    };
    try {
      // List<CartItemModel> cart = _userModel.cart; //not really used
      print(getUserId());
      CartItemModel item = CartItemModel.fromMap(
          cartItem); //mapping to the cart_item_model (for mapping database)
      print(getUserId());
      print(getUserId());
      await _userInfoService.addToCart(userId: getUserId(), cartItem: item);

      //print("CART ITEMS ARE: ${cart.toString()}");
      return true;
    } catch (e) {
      print("THE ERROR1 $e}");
      return false;
    }
  }

  Future<bool> reloadUserModel() async {
    try {
      _userModel = await _userInfoService.getUserById(getUserId());
      print('length ${_userModel.cart.length}');
      print('cart list ${_userModel.cart}');
      return true;
    } catch (e) {
      print('reload error $e');
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem}) async {
    print("THE PRODUCT IS: ${cartItem.toString()}");

    try {
      _userInfoService.removeFromCart(userId: getUserId(), cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> getOrders() async {
    try {
      orders = await orderServices.getUserOrders(userId: getUserId());
      return true;
    } catch (e) {
      return false;
    }
  }
}
