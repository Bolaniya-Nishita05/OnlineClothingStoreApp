import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/DetailPage.dart';
import 'package:onlineclothingstoreapp/api/OrderApi.dart';
import 'package:onlineclothingstoreapp/api/ProductApi.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();

  int? loggedUserId=0;

  CartPage(int? loggedUserId)
  {
    this.loggedUserId=loggedUserId;
  }
}

class _CartPageState extends State<CartPage> {
  var loggedUserId;

  @override
  void initState()
  {
    super.initState();

    this.loggedUserId=widget.loggedUserId;
  }

  void refreshOrders() {
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        title: Text("My Cart"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder(
                  future: OrderApi().getOrderByUserID(loggedUserId),
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Center(
                          child: Text("Error occured : "+snapshot.error.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                            ),
                          )
                      );
                    }

                    if(snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        var orders = snapshot.data!;

                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return CartItem(
                              order: orders[index],
                              onDelete: refreshOrders
                            );
                          },
                        );
                      }

                      else {
                        return Center(
                            child: Text("Your Cart is Empty......",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.02
                              ),
                            )
                        );
                      }
                    }

                    else{
                      return Center(child: CircularProgressIndicator(color: Colors.blueAccent,));
                    }
                  }

              ),
            ),
            // SizedBox(height: 20),
            // CouponField(),
            // SizedBox(height: 20),
            // PriceSummary(),
            // SizedBox(height: 20),
            // CheckoutButton(),
            // SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  Map<String,dynamic> order=new Map();
  final VoidCallback onDelete;

  CartItem({
    required this.order,
    required this.onDelete
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black87,
      surfaceTintColor: Colors.purple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.order['imgUrl'],
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.order['productName'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.brown.shade700,
                      fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text("Ready To Wear\nQuantity : ${widget.order['quantity']}", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text("\u{20B9}"+widget.order['totalAmount'].toString(),
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(onPressed: () async {
                  var product=await ProductApi().getProductByProductID(widget.order['productID']);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(product: product,loggedUserID:
                  widget.order['userID'],order: widget.order),))
                      .then((value) {
                    if(value){
                      setState(() {

                      });
                    }
                  }
                  );
                }, icon: Container(
                    child: Icon(Icons.edit_note_outlined, color: Colors.green,),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green,width: 2),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.all(5),
                  )
                ),
                IconButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("DELETE!!", style: TextStyle(color: Colors.red)),
                          content: Text("Are you sure, you want to delete this order?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Close the confirmation dialog first

                                bool isDeleted = await OrderApi().deleteOrder(widget.order['orderID'].toString());

                                bool? result = await showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        isDeleted ? "SUCCESS!!" : "FAILURE!!",
                                        style: TextStyle(color: isDeleted ? Colors.green : Colors.red),
                                      ),
                                      content: Text(
                                        isDeleted
                                            ? "Order deleted successfully!!"
                                            : "Deletion failed!! Try again!!",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context,true);
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                    );
                                  },
                                );

                                if (result == true) {
                                  widget.onDelete(); // Refresh the UI
                                }

                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

class CouponField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.shade700),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Coupon Code",
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
            onPressed: () {},
            child: Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class PriceSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SummaryRow(label: "Subtotal", value: "88.97 US\$"),
        SummaryRow(label: "Shipping Fee", value: "Standard - Fee"),
        SummaryRow(label: "Estimated Total", value: "88.97 UK£ + Tax", isBold: true),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  SummaryRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(20),
      ),
      onPressed: () {},
      child: Center(
        child: Text("Checkout",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: MediaQuery.of(context).size.height*0.02
            )
        ),
      ),
    );
  }
}