import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_delivery_flutter_app/utils/colors.dart';
import 'package:food_delivery_flutter_app/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
class OrderCardWidget extends StatefulWidget {
  final String imageName;
  final String title;
  final int price;
  final int counter;
  final int totalPrice;
  final VoidCallback onDeleteAll;


  const OrderCardWidget({
    Key? key,
    required this.imageName,
    required this.title,
    required this.price,
    required this.totalPrice,
    required this.counter,
    required this.onDeleteAll,
  }) : super(key: key);

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: widget.onDeleteAll),
        children: [
          SlidableAction(
            onPressed: (context) {
              widget.onDeleteAll.call();
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            autoClose: true,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(22),
        ),
        width: context.width(),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 120,
              height: 62,
              child: Center(
                child: Image.network(
                  "http://kasimadalan.pe.hu/yemekler/resimler/${widget.imageName}",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(
              width: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                  Text(
                    "Adet: ${widget.counter}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: primaryColor),
                  ),
                  Text(
                    "Fiat: ${widget.price} ₺",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: primaryColor),
                  ),
                ],
              ).paddingAll(5),
            ),
            SizedBox(
              width: 110,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" ${widget.totalPrice} ₺",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: primaryColor),),
                ],
              ).paddingAll(4),
            ),
          ],
        ),
      ),
    );
  }
}