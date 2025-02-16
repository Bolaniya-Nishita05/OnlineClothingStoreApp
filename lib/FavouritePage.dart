import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/DetailPage.dart';
import 'package:onlineclothingstoreapp/api/FavouriteApi.dart';
import 'package:onlineclothingstoreapp/api/OrderApi.dart';
import 'package:onlineclothingstoreapp/api/ProductApi.dart';

class FavouritePage extends StatefulWidget {
  @override
  State<FavouritePage> createState() => _FavouritePageState();

  int? loggedUserId=0;

  FavouritePage(int? loggedUserId)
  {
    this.loggedUserId=loggedUserId;
  }
}

class _FavouritePageState extends State<FavouritePage> {
  var loggedUserId;

  @override
  void initState()
  {
    super.initState();

    this.loggedUserId=widget.loggedUserId;
  }

  void refreshFavourites() {
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
        title: Text("My Favourites"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.favorite_border_rounded, color: Colors.white),
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
                  future: FavouriteApi().getFavouriteByUserID(loggedUserId),
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
                        var favourites = snapshot.data!;

                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 1,
                          ),
                          itemCount: favourites.length,
                          itemBuilder: (context, index) {
                            return FavouriteItem(
                              favourite: favourites[index],
                              onDelete: refreshFavourites,
                            );
                          },
                        );

                      }

                      else {
                        return Center(
                            child: Text("Your Favourite List is Empty......",
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
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class FavouriteItem extends StatefulWidget {
  Map<String,dynamic> favourite=new Map();
  final VoidCallback onDelete;

  FavouriteItem({
    required this.favourite,
    required this.onDelete
  });

  @override
  State<FavouriteItem> createState() => _FavouriteItemState();
}

class _FavouriteItemState extends State<FavouriteItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      shadowColor: Colors.black87,
      surfaceTintColor: Colors.purple.shade100,
      child: Container(
        child: Column(
            children: [
              ClipRRect(
                child: Image.network(
                  widget.favourite['imgUrl'].toString(),
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width*0.3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              Row(
                children: [
                  Container(
                    child: Text(widget.favourite['productName'].toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.brown.shade700,
                          fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    width: MediaQuery.of(context).size.width*0.3,
                    margin: EdgeInsets.only(left: 10),
                  ),
                  InkWell(
                    onTap: (){
                      Map<String,dynamic> favourite = new Map();

                      // setState(() {
                      //   l2[index].isLiked=!l2[index].isLiked;
                      // });
                    },
                    child: Container(
                      child: Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.orange.shade700,
                        size: 15,
                      ),
                      padding: EdgeInsets.only(right: 10),
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ],
        ),
      ),
    );
  }
}