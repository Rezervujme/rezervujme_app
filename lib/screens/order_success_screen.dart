import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vrouter/vrouter.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () => context.vRouter.to('/tabs'),
                      icon: Icon(
                        Icons.close_outlined,
                        color: Theme.of(context).primaryColor,
                      ))),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: SvgPicture.asset(
                  'assets/images/order-success.svg',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              ),
              Text(
                'Stôl bol úspešne rezervovaný.\nDetaily rezervácie nájdeš vo svojom profile.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => context.vRouter.to('/tabs'),
                    // onPressed: _reservationDate == null
                    //     ? null
                    //     : () => {
                    //           context.vRouter.to(
                    //               '/tabs/restaurants/${_restaurant.id}/order/${_reservationDate!.toIso8601String()}')
                    //         },
                    child: const Text('Zavrieť')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
