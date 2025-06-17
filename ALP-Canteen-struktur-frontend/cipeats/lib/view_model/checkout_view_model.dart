import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../model/checkout_item_model.dart';
import '../../view/checkout.dart';

enum DeliveryMethod { pickup, delivered }
enum DeliveryTime { now, scheduled }
enum PaymentMethod { cash, qris }

class CheckoutViewModel extends StateNotifier<CheckoutState> {
  CheckoutViewModel()
      : super(
          CheckoutState(
            items: [
              CheckoutItemModel(
                name: 'Kentang Goreng',
                price: 15000,
                quantity: 1,
                imagePath: 'assets/images/Kentang_Goreng.png',
              ),
              CheckoutItemModel(
                name: 'Nasi Gila',
                price: 25000,
                quantity: 2,
                imagePath: 'assets/images/Nasi_Gila.png',
              ),
            ],
            deliveryMethod: DeliveryMethod.pickup,
            deliveryTime: DeliveryTime.now,
            paymentMethod: PaymentMethod.cash,
            location: '',
            locationDetail: '',
            note: '',
            scheduledTime: const TimeOfDay(hour: 8, minute: 0),
          ),
        );

  void toggleDeliveryMethod(DeliveryMethod method) => state = state.copyWith(deliveryMethod: method);
  void toggleDeliveryTime(DeliveryTime time) => state = state.copyWith(deliveryTime: time);
  void setPaymentMethod(PaymentMethod method) => state = state.copyWith(paymentMethod: method);
  void setLocation(String loc) => state = state.copyWith(location: loc);
  void setLocationDetail(String detail) => state = state.copyWith(locationDetail: detail);
  void setNote(String note) => state = state.copyWith(note: note);
  void setScheduledTime(TimeOfDay time) => state = state.copyWith(scheduledTime: time);
  void setItems(List<CheckoutItemModel> items) => state = state.copyWith(items: items);
}

class CheckoutState {
  final List<CheckoutItemModel> items;
  final DeliveryMethod deliveryMethod;
  final DeliveryTime deliveryTime;
  final PaymentMethod paymentMethod;
  final String location;
  final String locationDetail;
  final String note;
  final TimeOfDay scheduledTime;

  CheckoutState({
    required this.items,
    required this.deliveryMethod,
    required this.deliveryTime,
    required this.paymentMethod,
    required this.location,
    required this.locationDetail,
    required this.note,
    required this.scheduledTime,
  });

  int get adminFee => 1000;

  int get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalPrice) + adminFee;

  CheckoutState copyWith({
    List<CheckoutItemModel>? items,
    DeliveryMethod? deliveryMethod,
    DeliveryTime? deliveryTime,
    PaymentMethod? paymentMethod,
    String? location,
    String? locationDetail,
    String? note,
    TimeOfDay? scheduledTime,
  }) {
    return CheckoutState(
      items: items ?? this.items,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      location: location ?? this.location,
      locationDetail: locationDetail ?? this.locationDetail,
      note: note ?? this.note,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }
}

final checkoutProvider = StateNotifierProvider<CheckoutViewModel, CheckoutState>(
  (ref) => CheckoutViewModel(),
);
