import 'dart:async';
import '../models/school/school_model.dart';
import 'base_repository.dart';
import '../../core/enums/app_enums.dart';

abstract class SubscriptionRepository extends BaseRepository<SubscriptionModel> {
  Future<SubscriptionModel?> getActiveSubscription(String schoolId);
  Future<List<SubscriptionModel>> getExpiringSubscriptions(int days);
  Future<void> cancelSubscription(String subscriptionId);
  Future<SubscriptionModel> renewSubscription(String subscriptionId);
  Future<List<SubscriptionModel>> getSubscriptionsByStatus(PaymentStatus status);
  Future<SubscriptionModel> upgradeSubscription(String subscriptionId, SubscriptionPlan newPlan);
  Future<List<SubscriptionModel>> getSubscriptionHistory(String schoolId);
  Future<Map<String, dynamic>> getSubscriptionAnalytics(String schoolId);
}

class MockSubscriptionRepository implements SubscriptionRepository {
  final List<SubscriptionModel> _subscriptions = [];

  @override
  Future<List<SubscriptionModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredSubscriptions = List<SubscriptionModel>.from(_subscriptions);

    if (filters != null) {
      if (filters.containsKey('schoolId')) {
        final schoolId = filters['schoolId'] as String;
        filteredSubscriptions = filteredSubscriptions.where((sub) => sub.schoolId == schoolId).toList();
      }

      if (filters.containsKey('paymentStatus')) {
        final status = filters['paymentStatus'] as PaymentStatus;
        filteredSubscriptions = filteredSubscriptions.where((sub) => sub.paymentStatus == status).toList();
      }

      if (filters.containsKey('plan')) {
        final plan = filters['plan'] as SubscriptionPlan;
        filteredSubscriptions = filteredSubscriptions.where((sub) => sub.plan == plan).toList();
      }

      if (filters.containsKey('isActive')) {
        final isActive = filters['isActive'] as bool;
        if (isActive) {
          filteredSubscriptions = filteredSubscriptions.where((sub) =>
          sub.paymentStatus == PaymentStatus.paid &&
              sub.endDate.isAfter(DateTime.now())
          ).toList();
        } else {
          filteredSubscriptions = filteredSubscriptions.where((sub) =>
          sub.paymentStatus != PaymentStatus.paid ||
              sub.endDate.isBefore(DateTime.now())
          ).toList();
        }
      }
    }

    return filteredSubscriptions;
  }

  @override
  Future<SubscriptionModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _subscriptions.firstWhere((sub) => sub.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<SubscriptionModel> create(SubscriptionModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _subscriptions.add(item);
    return item;
  }

  @override
  Future<SubscriptionModel> update(String id, SubscriptionModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _subscriptions.indexWhere((sub) => sub.id == id);
    if (index != -1) {
      _subscriptions[index] = item;
      return item;
    }

    throw RepositoryFailure('Subscription not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _subscriptions.length;
    _subscriptions.removeWhere((sub) => sub.id == id);

    return _subscriptions.length < initialLength;
  }

  @override
  Stream<List<SubscriptionModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_subscriptions);
  }

  @override
  Stream<SubscriptionModel?> watchById(String id) {
    try {
      final subscription = _subscriptions.firstWhere((sub) => sub.id == id);
      return Stream.value(subscription);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<SubscriptionModel?> getActiveSubscription(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _subscriptions.firstWhere((sub) =>
      sub.schoolId == schoolId &&
          sub.paymentStatus == PaymentStatus.paid &&
          sub.endDate.isAfter(DateTime.now())
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<SubscriptionModel>> getExpiringSubscriptions(int days) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final threshold = DateTime.now().add(Duration(days: days));
    return _subscriptions.where((sub) =>
    sub.paymentStatus == PaymentStatus.paid &&
        sub.endDate.isBefore(threshold) &&
        sub.endDate.isAfter(DateTime.now())
    ).toList();
  }

  @override
  Future<void> cancelSubscription(String subscriptionId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final subscription = _subscriptions.firstWhere((sub) => sub.id == subscriptionId);
    if (subscription != null) {
      final index = _subscriptions.indexOf(subscription);
      _subscriptions[index] = subscription.copyWith(
        paymentStatus: PaymentStatus.cancelled,
        autoRenew: false,
      );
    }
  }

  @override
  Future<SubscriptionModel> renewSubscription(String subscriptionId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final subscription = _subscriptions.firstWhere((sub) => sub.id == subscriptionId);
    if (subscription != null) {
      final index = _subscriptions.indexOf(subscription);
      final renewedSubscription = subscription.copyWith(
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        paymentStatus: PaymentStatus.paid,
      );

      _subscriptions[index] = renewedSubscription;
      return renewedSubscription;
    }

    throw RepositoryFailure('Subscription not found');
  }

  @override
  Future<List<SubscriptionModel>> getSubscriptionsByStatus(PaymentStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _subscriptions.where((sub) => sub.paymentStatus == status).toList();
  }

  @override
  Future<SubscriptionModel> upgradeSubscription(String subscriptionId, SubscriptionPlan newPlan) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final subscription = _subscriptions.firstWhere((sub) => sub.id == subscriptionId);
    if (subscription != null) {
      final index = _subscriptions.indexOf(subscription);

      // Calculate new amount based on plan
      double newAmount;
      switch (newPlan) {
        case SubscriptionPlan.basic:
          newAmount = 99.99;
          break;
        case SubscriptionPlan.premium:
          newAmount = 199.99;
          break;
        case SubscriptionPlan.enterprise:
          newAmount = 399.99;
          break;
      }

      final upgradedSubscription = subscription.copyWith(
        plan: newPlan,
        amount: newAmount,
        paymentStatus: PaymentStatus.pending, // Need new payment
      );

      _subscriptions[index] = upgradedSubscription;
      return upgradedSubscription;
    }

    throw RepositoryFailure('Subscription not found');
  }

  @override
  Future<List<SubscriptionModel>> getSubscriptionHistory(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _subscriptions.where((sub) => sub.schoolId == schoolId).toList();
  }

  @override
  Future<Map<String, dynamic>> getSubscriptionAnalytics(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final schoolSubscriptions = await getSubscriptionHistory(schoolId);

    double totalRevenue = 0;
    int activeSubscriptions = 0;
    int expiredSubscriptions = 0;
    int cancelledSubscriptions = 0;

    for (final sub in schoolSubscriptions) {
      totalRevenue += sub.amount;

      if (sub.paymentStatus == PaymentStatus.paid && sub.endDate.isAfter(DateTime.now())) {
        activeSubscriptions++;
      } else if (sub.endDate.isBefore(DateTime.now())) {
        expiredSubscriptions++;
      } else if (sub.paymentStatus == PaymentStatus.cancelled) {
        cancelledSubscriptions++;
      }
    }

    return {
      'totalRevenue': totalRevenue,
      'activeSubscriptions': activeSubscriptions,
      'expiredSubscriptions': expiredSubscriptions,
      'cancelledSubscriptions': cancelledSubscriptions,
      'totalSubscriptions': schoolSubscriptions.length,
      'averageMonthlyRevenue': totalRevenue / (schoolSubscriptions.length > 0 ? schoolSubscriptions.length : 1),
    };
  }
}