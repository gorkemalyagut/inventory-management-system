import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/icons_data.dart';
import '../screens/warehouse_product_add_screen.dart';

class WarehouseProductsScreen extends StatelessWidget {
  const WarehouseProductsScreen({Key? key}) : super(key: key);

  Widget buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            document['productName'],
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        subtitle: Text(
          document['productBarcode'],
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        leading: Icon(
          CustomIcons.label,
          color: Colors.blue.shade700,
          size: 36,
        ),
        trailing: Text(
          document['productQuantity'],
        ),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     final productId =
        ModalRoute.of(context)!.settings.arguments as String; 
        
    final userId = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .doc(userId!.uid)
            .collection('user_product_list')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                buildListItem(context, snapshot.data!.docs[index]),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 65.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(WarehouseProductAddScreen.routeName);
          },
        ),
      ),
    );
  }
}
